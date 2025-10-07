import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tcc/constants/CoresDefinidas/branco_sujo.dart';
import 'package:tcc/constants/CoresDefinidas/preto_azulado.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';
import 'package:tcc/constants/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late final DatabaseReference dispositivosRef;

  @override
  void initState() {
    super.initState();
    dispositivosRef = FirebaseDatabase.instance
        .ref()
        .child('usuarios')
        .child(uid)
        .child('dispositivos');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Usuário não autenticado.")),
      );
    }

    final uid = user.uid;
    final dispositivosRef = FirebaseDatabase.instance
        .ref()
        .child('usuarios')
        .child(uid)
        .child('dispositivos');
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
      drawer: AppDrawer(parentContext: context),
      backgroundColor: fundoBranco,
      body: Column(
        children: [
          Container(
            height: 75,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.deepPurple.shade100),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  const Text(
                    "Dispositivos",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      color: pretoAzulado,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'cadastroHardware');
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    color: fundoRoxoTres,
                  ),
                  IconButton(
                    onPressed: () {
                      // futuro: editar layout
                    },
                    icon: const Icon(Icons.brush),
                    color: fundoRoxoTres,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: dispositivosRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(
                    child: Text(
                      'Adicione um novo dispositivo!',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                final data = snapshot.data!.snapshot.value as Map;
                final dispositivos = data.entries.toList();

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: dispositivos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      final dispositivo = dispositivos[index].value as Map;
                      final dispositivoId = dispositivos[index].key;

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'infoHardware',
                            arguments: {
                              'nome': dispositivo['nome'],
                              'id': dispositivoId,
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.memory,
                                size: 40,
                                color: fundoRoxoTres,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                dispositivo['nome'] ?? 'Sem nome',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                dispositivo['id'] ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon, color: fundoRoxoTres),
      title: Text(
        label,
        style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
