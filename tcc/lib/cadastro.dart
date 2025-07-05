import 'package:flutter/material.dart';
import 'package:tcc/constants/my_textfield.dart';
import 'package:tcc/login.dart';

class Cadastro extends StatelessWidget {
  Cadastro({super.key});

  final telefoneController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void irLog(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
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
                        controller: telefoneController,
                        hintText: 'Número de Telefone',
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
                        onPressed: () => irLog(context),

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
