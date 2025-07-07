import 'package:flutter/material.dart';
import 'package:tcc/constants/my_textfield.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
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
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    //topRight: Radius.circular(500),
                  ),
                ),

                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Numero de telefone
                      const SizedBox(height: 50),
                      MyTextfield(
                        controller: emailController,
                        hintText: 'E-mail',
                        isPassword: false,
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
                              onPressed: () {},
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
                          "Entrar",
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
