import 'package:flutter/material.dart';
import 'package:tcc/login.dart';
import 'package:tcc/cadastro.dart';

import 'package:tcc/constants/CoresDefinidas/branco_sujo.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';

import 'package:tcc/constants/texto_logo.dart';

class CadOrLogin extends StatelessWidget {
  const CadOrLogin({super.key});

  void irCad(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Cadastro()),
    );
  }

  void irLogin(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoRoxoTres,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: fundoRoxoTres,
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
                                Text(
                                  TextosLogo.slogan,
                                  style: TextosLogo.subtitulo,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: fundoRoxoTres,
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 16, bottom: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Seu melhor",
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: fundoBranco,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "amigo ouvinte!",
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: fundoBranco,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: fundoBranco,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 280,
                    child: ElevatedButton(
                      onPressed: () => irLogin(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        "Entrar com minha conta",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Urbanist',
                          color: fundoRoxoTres,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade400)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "OU",
                            style: TextStyle(
                              color: fundoRoxoTres,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: ElevatedButton(
                      onPressed: () => irCad(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fundoRoxoTres,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        "Criar nova conta",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
