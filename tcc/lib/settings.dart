import 'package:flutter/material.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';
import 'package:tcc/constants/drawer.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
      drawer: AppDrawer(parentContext: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: () {
            // abre as configurações do app
          },
          borderRadius: BorderRadius.circular(8), // cantos arredondados
          child: Container(
            width: double.infinity, // ocupa toda a largura
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: fundoRoxoTres,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.settings, color: Colors.white, size: 14),
                SizedBox(width: 12),
                Text(
                  'Configurações do App',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
