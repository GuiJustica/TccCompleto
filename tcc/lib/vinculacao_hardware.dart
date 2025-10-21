import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';

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

  void conectarDispositivo(BluetoothDevice device) async {
    debugPrint("🟢 Tentando conectar em ${device.name} (${device.id})");
    // Mostra loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 🔗 Conecta com license exigido pela lib
      await device
          .connect(
            license: License.free, // <- obrigatório na sua versão
            autoConnect: false,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Tempo de conexão esgotado');
            },
          );

      device.connectionState.listen((state) {
        debugPrint("📶 Estado de conexão: $state");
      });
      debugPrint('[DEBUG] Conectado ao dispositivo: ${device.id}');

      // 🔍 Descobre os serviços GATT disponíveis
      List<BluetoothService> services = await device.discoverServices();

      debugPrint(
        '[DEBUG] Serviços descobertos: ${services.map((s) => s.uuid).toList()}',
      );

      // 🔎 Encontra o serviço e a característica correspondentes
      final service = services.firstWhere(
        (s) =>
            s.uuid.toString().toLowerCase() ==
            "12345678-1234-5678-1234-56789abcdef1".toLowerCase(),
        orElse: () => throw Exception("Serviço BLE não encontrado"),
      );

      final characteristic = service.characteristics.firstWhere(
        (c) =>
            c.uuid.toString().toLowerCase() ==
            "12345678-1234-5678-1234-56789abcdef0".toLowerCase(),
        orElse: () => throw Exception("Característica BLE não encontrada"),
      );

      debugPrint('[DEBUG] Característica encontrada: ${characteristic.uuid}');

      // 📦 Monta o JSON com Wi-Fi e senha
      final dadosWifi = jsonEncode({"wifi": wifi, "senha": senha});
      final List<int> payload = utf8.encode(dadosWifi);

      // ✉️ Envia os dados via BLE para a Raspberry Pi
      // Ajuste `withoutResponse` conforme comportamento do seu dispositivo.
      // Se o servidor espera confirmação, use withoutResponse: false
      await characteristic
          .write(payload, withoutResponse: false)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout ao enviar dados via BLE');
            },
          );

      debugPrint("📤 Credenciais Wi-Fi enviadas via BLE: $dadosWifi");

      // ✅ Salva no Firebase (mantive seu fluxo)
      final String nomeDispositivo =
          device.name.isNotEmpty ? device.name : 'Sem nome';
      final String idDispositivo = device.id.toString();
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final dadosDispositivo = {
        'nome': nomeDispositivo,
        'id': idDispositivo,
        'wifi': wifi,
        'senha': senha,
        'criado_em': DateTime.now().toIso8601String(),
      };

      final ref = FirebaseDatabase.instance.ref('usuarios/$uid/dispositivos');
      await ref.push().set(dadosDispositivo);

      // Fecha o loading
      if (mounted) Navigator.pop(context);

      // Mensagem de sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Dispositivo conectado e configurado!'),
          ),
        );
      }

      // Volta para tela inicial
      if (mounted) Navigator.pop(context);
    } catch (e, st) {
      debugPrint('[ERROR] conectarDispositivo: $e\n$st');

      if (mounted) Navigator.pop(context);

      final msg = e is Exception ? e.toString() : 'Erro desconhecido';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Erro ao conectar: $msg')));
      }
    } finally {
      // Para qualquer scan em andamento
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
            padding: const EdgeInsets.only(
              right: 30.0,
            ), // controla distância da borda direita
            child: Image.asset(
              'assets/images/logobranco.png', // caminho da sua logo
              height: 35, // altura da imagem
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: buscarDispositivos,
            icon: Icon(Icons.bluetooth_searching),
            label: Text(buscando ? "Buscando..." : "Buscar Dispositivos"),
          ),
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
        ],
      ),
    );
  }
}
