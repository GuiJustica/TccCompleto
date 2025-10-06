import 'package:flutter/material.dart';
import 'package:tcc/services/auth_service.dart';
import 'package:tcc/constants/my_textfield.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:tcc/constants/CoresDefinidas/branco_sujo.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_um.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_dois.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';
import 'package:tcc/constants/texto_logo_invertido.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  bool loading = false;

  void verificarLogin() async {
    final email = emailController.text.trim();
    final senha = passwordController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      if (!mounted) return;
      // Login bem-sucedido
      Navigator.pushReplacementNamed(context, 'home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao entrar: ${e.message}')));
    } finally {
      setState(() => loading = false);
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
              flex: 2,
              child: Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: fundoRoxoTres,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    //topRight: Radius.circular(500),
                  ),
                ),

                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      MyTextfield(
                        controller: emailController,
                        hintText: 'E-mail',
                        isPassword: false,
                        isEmail: true,
                      ),
                      const SizedBox(height: 5),
                      MyTextfield(
                        controller: passwordController,
                        hintText: 'Senha',
                        isPassword: true,
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'forgetSenha');
                              },
                              child: Text(
                                'Esqueceu a senha?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () => verificarLogin(),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: fundoBranco,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          "Entrar",
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
                            iconSize: 48,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'cadastro');
                            },
                            child: Text(
                              "Criar nova conta!",
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
