import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tcc/constants/my_textformfield.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance.ref();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final passwordController = TextEditingController();
  final surdezController = TextEditingController();

  bool loading = false;
  bool editando = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _excluirConta(String email, String senha) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      // 1. Reautenticação
      final credential = EmailAuthProvider.credential(
        email: email,
        password: senha,
      );
      await user.reauthenticateWithCredential(credential);

      // 2. Exclusão da conta
      await user.delete();

      // 3. (Opcional) Remover dados do Realtime Database
      final db = FirebaseDatabase.instance.ref();
      await db.child('usuarios/${user.uid}').remove();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Conta excluída com sucesso")));

      Navigator.pushReplacementNamed(context, 'login');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao excluir conta: ${e.message}")),
      );
    }
  }

  Future<void> _carregarDadosUsuario() async {
    if (user == null) return;

    setState(() => loading = true);

    try {
      // Preenche o e-mail com o valor do FirebaseAuth
      emailController.text = user!.email ?? '';

      final snapshot = await database.child('usuarios/${user!.uid}').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        nomeController.text = data['nome'] ?? '';
        telefoneController.text = data['telefone'] ?? '';
        surdezController.text = data['grauSurdez'] ?? '';
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> salvarDados() async {
    if (user == null) return;

    setState(() => loading = true);

    try {
      await database.child('usuarios/${user!.uid}').update({
        'nome': nomeController.text.trim(),
        'telefone': telefoneController.text.trim(),
        'grauSurdez': surdezController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados salvos com sucesso!')),
      );
    } catch (e) {
      debugPrint('Erro ao salvar dados: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar os dados')),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
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
            ListTile(
              leading: Icon(Icons.home, color: Colors.deepPurple),
              title: Text(
                "H O M E",
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'home');
              },
            ),

            ListTile(
              leading: Icon(Icons.person, color: Colors.deepPurple),
              title: Text(
                "P E R F I L",
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'perfil');
              },
            ),

            ListTile(
              leading: Icon(Icons.help, color: Colors.deepPurple),
              title: Text(
                "A J U D A",
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'tutorial');
              },
            ),

            ListTile(
              leading: Icon(Icons.settings, color: Colors.deepPurple),
              title: Text(
                "C O N F I G U R A Ç Õ E S",
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'settings');
              },
            ),

            Spacer(),
            Divider(thickness: 1, color: Colors.grey[300]),
            ListTile(
              leading: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: const Icon(Icons.exit_to_app, color: Colors.deepPurple),
              ),
              title: Text(
                "S A I R",
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      backgroundColor: Colors.deepPurple.shade100,
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    // Cabeçalho com avatar, nome e botão
                    Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.deepPurple.shade100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.deepPurple.shade300,
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Olá, ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          nomeController.text.isEmpty
                                              ? "Usuário"
                                              : nomeController.text
                                                  .split(" ")
                                                  .first,
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: "!",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),

                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                MyTextformfield(
                                  controller: nomeController,
                                  hintText: 'Nome',
                                  enabled: editando,
                                  isPassword: false,
                                ),
                                MyTextformfield(
                                  controller: emailController,
                                  hintText: 'E-mail',
                                  enabled: false, // e-mail não editável
                                  isPassword: false,
                                ),
                                MyTextformfield(
                                  controller: telefoneController,
                                  hintText: 'Telefone',
                                  enabled: editando,
                                  isPassword: false,
                                ),
                                MyTextformfield(
                                  controller: passwordController,
                                  hintText: 'Senha (não editável aqui)',
                                  enabled:
                                      false, // por segurança, não alterável aqui
                                  isPassword: true,
                                ),
                                MyTextformfield(
                                  controller: surdezController,
                                  hintText: 'Grau de Surdez',
                                  enabled: editando,
                                  isPassword: false,
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (editando) {
                                      await salvarDados();
                                    }
                                    setState(() => editando = !editando);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple.shade100,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 80,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    editando ? "Salvar" : "Editar",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      color: Colors.deepPurple.shade100,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  final emailController =
                                      TextEditingController();
                                  final senhaController =
                                      TextEditingController();

                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Confirmar exclusão'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                labelText: 'E-mail',
                                              ),
                                            ),
                                            TextField(
                                              controller: senhaController,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                labelText: 'Senha',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              await _excluirConta(
                                                emailController.text.trim(),
                                                senhaController.text.trim(),
                                              );
                                            },
                                            child: Text('Excluir'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "Excluir conta",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete_forever),
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
