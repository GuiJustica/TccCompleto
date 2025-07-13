import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Home', style: TextStyle(color: Colors.white)),
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple.shade100,
        child: Column(
          children: [
            Container(
              height: 150,
              color: Colors.deepPurple.shade100,
              child: Center(
                child: SizedBox(
                  height: 60,
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
            ),
            Divider(thickness: 1, color: Colors.grey[300]),
            _buildDrawerItem(Icons.home, "H O M E", 'home'),
            _buildDrawerItem(Icons.person, "P E R F I L", 'perfil'),
            _buildDrawerItem(Icons.help, "A J U D A", 'tutorial'),
            _buildDrawerItem(
              Icons.settings,
              "C O N F I G U R A Ç Õ E S",
              'settings',
            ),
            const Spacer(),
            Divider(thickness: 1, color: Colors.grey[300]),
            ListTile(
              leading: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: const Icon(Icons.exit_to_app, color: Colors.deepPurple),
              ),
              title: const Text(
                "S A I R",
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
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
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'cadastroHardware');
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    color: Colors.deepPurple,
                  ),
                  IconButton(
                    onPressed: () {
                      // futuro: editar layout
                    },
                    icon: const Icon(Icons.brush),
                    color: Colors.deepPurple,
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
                    child: Text('Nenhum dispositivo vinculado ainda.'),
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
                                color: Colors.deepPurple,
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
      leading: Icon(icon, color: Colors.deepPurple),
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
