import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tcc/constants/my_textfield.dart';

import 'package:tcc/constants/CoresDefinidas/branco_sujo.dart';

import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';
import 'package:tcc/constants/texto_logo_invertido.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool loading = false;

  Future<void> validacaoCadastro() async {
    final email = emailController.text.trim();
    final senha = passwordController.text.trim();
    final confirmaSenha = confirmPasswordController.text.trim();

    if (email.isEmpty || senha.isEmpty || confirmaSenha.isEmpty) {
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

      // --- Integração FCM ---
      //final userId = FirebaseAuth.instance.currentUser!.uid;
      //await FcmService.saveTokenForUser(userId);

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
      backgroundColor: fundoBranco,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: fundoBranco,
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              TextosLogo.nomeApp,
                              style: TextosLogo.titulo,
                            ),
                          ),
                          Text(TextosLogo.slogan, style: TextosLogo.subtitulo),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: fundoRoxoTres,
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
                        isEmail: true,
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
                        isConfirmPassword: true,
                        mainPasswordController: passwordController,
                      ),

                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: loading ? null : validacaoCadastro,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: fundoBranco,
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
                            color: fundoRoxoTres,
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
