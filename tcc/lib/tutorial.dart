import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tcc/constants/CoresDefinidas/branco_sujo.dart';
import 'package:tcc/constants/CoresDefinidas/preto_letra.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';
import 'package:tcc/constants/drawer.dart';

import 'package:url_launcher/url_launcher.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key});

  // Função para abrir um vídeo do YouTube
  void abrirYoutube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Não foi possível abrir: $url");
    }
  }

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
      backgroundColor: fundoBranco,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.deepPurple.shade100,
              child: Container(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Produzimos uma série de vídeos em \n",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: "LIBRAS ",
                        style: TextStyle(
                          color: fundoRoxoTres,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: "para te ajudar!",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: fundoBranco,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),

                child: ListView(
                  children: [
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          "Sobre nós",
                          style: TextStyle(
                            color: pretoLetra,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        children: [
                          Divider(),
                          ListTile(
                            title: Text(
                              "Quem somos?",
                              style: TextStyle(
                                color: pretoLetra,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Image.asset('assets/images/youtube.png'),
                            onTap:
                                () => abrirYoutube(
                                  "https://www.youtube.com/watch?v=teXn9rfQZ00",
                                ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              "O que é Guilo's Sound?",
                              style: TextStyle(
                                color: pretoLetra,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Image.asset('assets/images/youtube.png'),
                            onTap:
                                () => abrirYoutube(
                                  "https://www.youtube.com/watch?v=teXn9rfQZ00",
                                ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    ExpansionTile(
                      title: Text(
                        "Telas do aplicativo",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Explicação de cada tela!",
                            style: TextStyle(
                              color: pretoLetra,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap:
                              () => abrirYoutube(
                                "https://www.youtube.com/watch?v=teXn9rfQZ00",
                              ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            "O que é Guilo's Sound?",
                            style: TextStyle(
                              color: pretoLetra,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap:
                              () => abrirYoutube(
                                "https://www.youtube.com/watch?v=teXn9rfQZ00",
                              ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Cadastro e Login",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Cadastro",
                            style: TextStyle(
                              color: pretoLetra,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap:
                              () => abrirYoutube(
                                "https://www.youtube.com/watch?v=teXn9rfQZ00",
                              ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            "Login",
                            style: TextStyle(
                              color: pretoLetra,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap:
                              () => abrirYoutube(
                                "https://www.youtube.com/watch?v=teXn9rfQZ00",
                              ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Cadastro do seu amigo ouvinte",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Como e o que fazer?",
                            style: TextStyle(
                              color: pretoLetra,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap:
                              () => abrirYoutube(
                                "https://www.youtube.com/watch?v=teXn9rfQZ00",
                              ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Estatísticas do seu amigo ouvinte",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Pra que servem?",
                            style: TextStyle(
                              color: pretoLetra,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap:
                              () => abrirYoutube(
                                "https://www.youtube.com/watch?v=teXn9rfQZ00",
                              ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Meu perfil",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Minhas informações servem pra que?",
                            style: TextStyle(
                              color: pretoLetra,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap:
                              () => abrirYoutube(
                                "https://www.youtube.com/watch?v=teXn9rfQZ00",
                              ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Configurações",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Notificações",
                            style: TextStyle(
                              color: pretoLetra,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap:
                              () => abrirYoutube(
                                "https://www.youtube.com/watch?v=teXn9rfQZ00",
                              ),
                        ),
                        Divider(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 80,
              width: double.infinity,
              color: Colors.deepPurple.shade100,
              child: Container(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Qualquer dúvida ou sugestão\n",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: "nos avise! ",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: "guilosuporte@gmail.com",
                        style: TextStyle(
                          color: pretoLetra,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
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
