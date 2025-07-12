import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class VinculacaoHardware extends StatefulWidget {
  const VinculacaoHardware({super.key});

  @override
  State<VinculacaoHardware> createState() => _VinculacaoHardwareState();
}

class _VinculacaoHardwareState extends State<VinculacaoHardware> {
  List<ScanResult> dispositivosEncontrados = [];
  bool buscando = false;

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Conectado a ${device.name}')));
      // Aqui: envio de dados futuros (SSID, senha, ID do usuário...)
    } catch (e) {
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
