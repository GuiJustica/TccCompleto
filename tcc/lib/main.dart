import 'package:flutter/material.dart';
import 'package:tcc/cadastro.dart';
import 'package:tcc/cadastro_hardware.dart';
import 'package:tcc/login.dart';
import 'package:tcc/my_home_page.dart';
import 'package:tcc/perfil.dart';
import 'package:tcc/splash_screen.dart';
import 'package:tcc/cad_or_login.dart';
import 'package:tcc/settings.dart';
import 'package:tcc/tutorial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CadOrLogin(),
      routes: {
        'home': (context) => MyHomePage(),
        'settings': (context) => Settings(),
        'perfil': (context) => Perfil(),
        'tutorial': (context) => Tutorial(),
        'cadastro': (context) => Cadastro(),
        'login': (context) => Login(),
        'cadastroHardware': (context) => CadastroHardware(),
      },
    );
  }
}
