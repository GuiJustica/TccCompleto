import 'package:flutter/material.dart';
import 'package:tcc/constants/CoresDefinidas/branco_sujo.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';
import 'package:tcc/constants/my_textfield.dart';

class CadastroHardware extends StatelessWidget {
  CadastroHardware({super.key});

  final wifiController = TextEditingController();
  final senhaWifiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoBranco,
      appBar: AppBar(
        backgroundColor: fundoRoxoTres,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
              _buildHeader("Conecte-se a uma rede Wi-Fi"),
              const SizedBox(height: 12),
              _buildHeader(
                "O smartphone deve estar conectado na rede em que você deseja que o dispositivo se conecte.",
                fontSize: 15,
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
                    final wifi = wifiController.text.trim();
                    final senha = senhaWifiController.text.trim();

                    if (wifi.isEmpty || senha.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preencha todos os campos'),
                        ),
                      );
                      return;
                    }

                    Navigator.pushNamed(
                      context,
                      'vincHardware',
                      arguments: {'wifi': wifi, 'senha': senha},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fundoRoxoTres,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Vincular',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Urbanist',
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

  Widget _buildHeader(String text, {double fontSize = 18}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
