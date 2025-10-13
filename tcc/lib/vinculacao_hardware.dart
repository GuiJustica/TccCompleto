import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';

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
    // Mostra loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Tenta conectar com timeout de 20 segundos
      await device
          .connect(license: License.free)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              throw Exception('Tempo de conexão esgotado');
            },
          );

      final String nomeDispositivo =
          device.name.isNotEmpty ? device.name : 'Sem nome';
      final String idDispositivo = device.id.toString();
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final Map<String, dynamic> dadosDispositivo = {
        'nome': nomeDispositivo,
        'id': idDispositivo,
        'wifi': wifi,
        'senha': senha,
        'criado_em': DateTime.now().toIso8601String(),
      };

      final DatabaseReference ref = FirebaseDatabase.instance.ref(
        'usuarios/$uid/dispositivos',
      );

      await ref.push().set(dadosDispositivo);

      // Fecha loading
      if (mounted) Navigator.pop(context);

      // Mostra mensagem de sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dispositivo conectado e salvo')),
        );
      }

      // Volta para tela inicial (Home)
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // Fecha loading caso haja erro
      if (mounted) Navigator.pop(context);

      // Mostra mensagem de erro
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao conectar: $e')));
      }
    } finally {
      // Para qualquer scan em andamento
      FlutterBluePlus.stopScan();
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
