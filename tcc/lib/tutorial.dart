import 'dart:math';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Precisa de Ajuda?',

          style: TextStyle(color: Colors.white),
        ),
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
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: "LIBRAS ",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: "para te ajudar!",
                        style: TextStyle(
                          color: Colors.black87,
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
                  color: Colors.white,
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
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        children: [
                          Divider(),
                          ListTile(
                            title: Text(
                              "Quem somos?",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Image.asset('assets/images/youtube.png'),
                            onTap:
                                () => abrirYoutube(
                                  "https://www.youtube.com/watch?v=88CgS9anXJs",
                                ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              "O que é Guilo's Sound?",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Image.asset('assets/images/youtube.png'),
                            onTap: () => {},
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    ExpansionTile(
                      title: Text(
                        "Telas do aplicativo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Explicação de cada tela!",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            "O que é Guilo's Sound?",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Cadastro e Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Cadastro",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Cadastro do seu amigo ouvinte",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Como e o que fazer?",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Estatisticas do seu amigo ouvinte",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Pra que servem?",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Meu perfil",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Minhas informações servem pra que?",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        "Configurações",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      children: [
                        Divider(),
                        ListTile(
                          title: Text(
                            "Notificações",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            "Não sei",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            "Não sei",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            "Não sei",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset('assets/images/youtube.png'),
                          onTap: () => {},
                        ),
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
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: "nos avise! ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: "guilosuporte@gmail.com",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
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
