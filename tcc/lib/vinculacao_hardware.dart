import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tcc/constants/CoresDefinidas/preto_letra.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';
import 'dart:async';

import 'package:http/http.dart' as http;

class VinculacaoHardware extends StatefulWidget {
  const VinculacaoHardware({super.key});

  @override
  State<VinculacaoHardware> createState() => _VinculacaoHardwareState();
}

class _VinculacaoHardwareState extends State<VinculacaoHardware> {
  String? wifi;
  String? senha;

  List<ScanResult> dispositivosEncontrados = [];
  bool buscando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    wifi = args['wifi'];
    senha = args['senha'];

    debugPrint("[DEBUG] WiFi recebido: $wifi");
    debugPrint("[DEBUG] Senha recebida: $senha");

    buscarDispositivos(); // inicia o scan automaticamente
  }

  @override
  void initState() {
    super.initState();
    solicitarPermissoes();
    buscarDispositivos();
  }

  Future<void> solicitarPermissoes() async {
    await Permission.bluetooth.request();
    await Permission.location.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  void buscarDispositivos() async {
    dispositivosEncontrados.clear();
    setState(() => buscando = true);

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() => dispositivosEncontrados = results);
    });

    Future.delayed(const Duration(seconds: 6), () {
      setState(() => buscando = false);
    });
  }

  Future<void> conectarDispositivo(BluetoothDevice device) async {
    debugPrint("🟢 Tentando conectar em ${device.name} (${device.id})");

    // Mostra loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1) Conecta via BLE
      await device
          .connect(license: License.free, autoConnect: false)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Tempo de conexão esgotado'),
          );
      debugPrint('[DEBUG] Conectado ao dispositivo: ${device.id}');

      // 2) Descobre serviços e características
      List<BluetoothService> services = await device.discoverServices();
      final service = services.firstWhere(
        (s) =>
            s.uuid.toString().toLowerCase() ==
            "12345678-1234-5678-1234-56789abcdef1",
        orElse: () => throw Exception("Serviço BLE não encontrado"),
      );

      final writeCharacteristic = service.characteristics.firstWhere(
        (c) =>
            c.uuid.toString().toLowerCase() ==
            "12345678-1234-5678-1234-56789abcdef0",
        orElse:
            () => throw Exception("Característica BLE (write) não encontrada"),
      );

      // 3) Envia credenciais Wi-Fi
      final dadosWifi = jsonEncode({"wifi": wifi, "senha": senha});
      await writeCharacteristic.write(
        utf8.encode(dadosWifi),
        withoutResponse: false,
      );
      debugPrint("📤 Credenciais Wi-Fi enviadas: $dadosWifi");

      // 4) Aguarda até que o dummy_user_id exista no Firebase
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final refDummy = FirebaseDatabase.instance.ref('usuarios/dummy_user_id');

      bool dummyCriado = false;
      const maxTentativas = 10;
      int tentativas = 0;

      while (!dummyCriado && tentativas < maxTentativas) {
        final snapshot = await refDummy.get();
        if (snapshot.exists && snapshot.children.isNotEmpty) {
          dummyCriado = true;
          break;
        }
        await Future.delayed(const Duration(seconds: 1));
        tentativas++;
      }

      if (!dummyCriado) {
        throw Exception(
          "❌ Algo inesperado aconteceu! Verifique as informações de Wi-Fi",
        );
      }

      debugPrint("✅ Dummy_user_id detectado!");

      // 5) Remove dummy_user_id
      try {
        final snapshot = await refDummy.get();
        if (snapshot.exists) await refDummy.remove();
        debugPrint("🧹 Dummy removido com sucesso");
        final String nomeDispositivo =
            device.name.isNotEmpty ? device.name : 'Sem nome';
        final String idDispositivo = device.id.toString();

        final dadosDispositivo = {
          'nome': nomeDispositivo,
          'id': idDispositivo,
          'wifi': wifi,
          'senha': senha,
          'criado_em': DateTime.now().toIso8601String(),
        };

        final refDispositivo = FirebaseDatabase.instance.ref(
          'usuarios/$uid/dispositivos',
        );
        debugPrint(
          "🔹 Salvando dispositivo em usuarios/$uid/dispositivos: $dadosDispositivo",
        );

        await refDispositivo.push().set(dadosDispositivo);
        debugPrint("🔹 Dispositivo salvo com sucesso");
        // 7) Fecha loading e mostra mensagem de sucesso
        if (mounted) Navigator.pop(context);
      } catch (e, st) {
        debugPrint("❌ Erro ao remover dummy: $e\n$st");
      }

      // 6) Cria dispositivo no nó do usuário

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Dispositivo conectado e configurado!'),
          ),
        );
        Navigator.pop(context); // volta à tela anterior
      }
    } catch (e, st) {
      debugPrint('[ERROR] conectarDispositivo: $e\n$st');
      if (mounted) Navigator.pop(context); // fecha loading
      final msg = e is Exception ? e.toString() : 'Erro desconhecido';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Erro ao conectar: $msg')));
      }
    } finally {
      await FlutterBluePlus.stopScan();
    }
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fundoRoxoTres,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Guilo's Sound",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'home',
                  (route) => false,
                );
              },
              child: Image.asset('assets/images/logobranco.png', height: 35),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Procure pelo dispositivo chamado 'HearSafe'.\n\n"
              "Se não encontrar, reinicie a busca.",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Urbanist',
                color: pretoLetra,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child:
                dispositivosEncontrados.isEmpty
                    ? const Center(
                      child: Text("Nenhum dispositivo encontrado."),
                    )
                    : ListView.builder(
                      itemCount: dispositivosEncontrados.length,
                      itemBuilder: (context, index) {
                        final result = dispositivosEncontrados[index];
                        final device = result.device;
                        return ListTile(
                          title: Text(
                            device.name.isNotEmpty ? device.name : "Sem nome",
                          ),
                          subtitle: Text(device.id.toString()),
                          trailing: Text("${result.rssi} dBm"),
                          onTap: () => conectarDispositivo(device),
                        );
                      },
                    ),
          ),
          ElevatedButton.icon(
            onPressed: buscarDispositivos,
            icon: Icon(Icons.bluetooth_searching),
            label: Text(
              buscando ? "Buscando..." : "Buscar Dispositivos",
              style: TextStyle(fontFamily: 'Urbanist'),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
