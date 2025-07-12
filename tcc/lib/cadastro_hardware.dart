import 'package:flutter/material.dart';
import 'package:tcc/constants/my_textfield.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class CadastroHardware extends StatelessWidget {
  CadastroHardware({super.key});

  final wifiController = TextEditingController();
  final senhaWifiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // ação ao clicar no ícone (voltar, por exemplo)
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Novo Dispositivo',

          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Conecte-se a uma rede Wi-Fi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'O smartphone deve estar conectado na rede em que você deseja que o dispositivo se conecte.',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyTextfield(
                        controller: wifiController,
                        hintText: 'Rede Wi-Fi',
                        isPassword: false,
                        icon: Icons.wifi,
                      ),
                      const SizedBox(height: 10),
                      MyTextfield(
                        controller: senhaWifiController,
                        hintText: 'Senha do Wi-Fi',
                        isPassword: true,
                        // Não precisa do icon para o olho, ele já é automático no MyTextfield
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final wifi = wifiController.text;
                    final senha = senhaWifiController.text;

                    if (wifi.isEmpty || senha.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preencha todos os campos'),
                        ),
                      );
                      return;
                    }

                    await Permission.bluetoothScan.request();
                    await Permission.bluetoothConnect.request();
                    await Permission.locationWhenInUse.request();

                    FlutterBluePlus.startScan(
                      timeout: const Duration(seconds: 5),
                    );
                    BluetoothDevice? dispositivo;

                    // Aguarda o primeiro dispositivo com nome esperado
                    await for (final results in FlutterBluePlus.scanResults) {
                      for (final result in results) {
                        if (result.device.name.contains("RPi") ||
                            result.device.name.isNotEmpty) {
                          dispositivo = result.device;
                          await FlutterBluePlus.stopScan();
                          break;
                        }
                      }
                      if (dispositivo != null) break;
                    }

                    if (dispositivo == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nenhum dispositivo encontrado'),
                        ),
                      );
                      return;
                    }

                    try {
                      await dispositivo!.connect();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Conectado a ${dispositivo!.name}'),
                        ),
                      );

                      // Envia o Wi-Fi e senha (você precisa definir o service/characteristic na Raspberry depois)
                      List<BluetoothService> services =
                          await dispositivo!.discoverServices();
                      for (var service in services) {
                        for (var characteristic in service.characteristics) {
                          if (characteristic.properties.write) {
                            final payload = '$wifi;$senha';
                            await characteristic.write(payload.codeUnits);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Credenciais enviadas via BLE'),
                              ),
                            );
                            break;
                          }
                        }
                      }

                      await dispositivo!.disconnect();
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Vincular',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
