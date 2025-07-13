import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
    try {
      await device.connect();

      final String nomeDispositivo =
          device.name.isNotEmpty ? device.name : 'Sem nome';
      final String idDispositivo = device.id.toString();
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      // Estrutura para salvar
      final Map<String, dynamic> dadosDispositivo = {
        'nome': nomeDispositivo,
        'id': idDispositivo,
        'wifi': wifi,
        'senha': senha,
        'criado_em': DateTime.now().toIso8601String(),
      };

      // Caminho: /usuarios/uid/dispositivos/gerado_por_push()
      final DatabaseReference ref = FirebaseDatabase.instance
          .ref()
          .child('usuarios')
          .child(uid)
          .child('dispositivos');

      await ref.push().set(dadosDispositivo);

      debugPrint("[DEBUG] Dispositivo salvo no Firebase Realtime");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Dispositivo conectado e salvo')));

      // Voltar à tela principal
      Navigator.popUntil(context, ModalRoute.withName('home'));
    } catch (e) {
      debugPrint("[ERRO] Falha ao conectar ou salvar: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao conectar: $e')));
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
      appBar: AppBar(title: const Text("Vincular Hardware via BLE")),
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
