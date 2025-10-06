import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:tcc/constants/my_textfield.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool loading = false;

  Future<void> validacaoCadastro() async {
    final email = emailController.text.trim();
    final nome = usernameController.text.trim();
    final senha = passwordController.text.trim();
    final confirmaSenha = confirmPasswordController.text.trim();

    if (email.isEmpty ||
        nome.isEmpty ||
        senha.isEmpty ||
        confirmaSenha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    if (senha != confirmaSenha) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não coincidem')));
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, 'login');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.message ?? "Erro desconhecido"}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 250,
                color: Color.fromARGB(255, 247, 247, 247),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 80,
                          width: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Guilo's Sound",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 117, 95, 168),
                              ),
                            ),
                          ),
                          Text(
                            "Sons Inteligentes",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 117, 95, 168),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 99, 59, 145),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Numero de telefone
                      const SizedBox(height: 50),
                      MyTextfield(
                        controller: emailController,
                        hintText: 'Informe seu E-mail',
                        isPassword: false,
                      ),
                      // Nome
                      const SizedBox(height: 5),
                      MyTextfield(
                        controller: usernameController,
                        hintText: 'Nome',
                        isPassword: false,
                      ),
                      // Senha
                      const SizedBox(height: 5),
                      MyTextfield(
                        controller: passwordController,
                        hintText: 'Senha',
                        isPassword: true,
                      ),
                      // Confirmar Senha
                      const SizedBox(height: 5),
                      MyTextfield(
                        controller: confirmPasswordController,
                        hintText: 'Confirmar Senha',
                        isPassword: true,
                      ),

                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: loading ? null : validacaoCadastro,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade400),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Text(
                                "Ou continue com",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {}, // lógica do Google
                            icon: Icon(Icons.g_mobiledata, color: Colors.white),
                            iconSize: 40,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
                            },
                            child: Text(
                              "Já tenho cadastro!",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
