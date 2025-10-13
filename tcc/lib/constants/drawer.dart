import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc/constants/CoresDefinidas/preto_azulado.dart';
import 'package:tcc/constants/CoresDefinidas/roxo_tres.dart';

class AppDrawer extends StatelessWidget {
  final BuildContext parentContext; // para navegação

  const AppDrawer({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          Divider(thickness: 1, color: pretoAzulado),
          _buildListTile(
            icon: Icons.home,
            title: "H O M E",
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.pushNamed(parentContext, 'home');
            },
          ),
          _buildListTile(
            icon: Icons.person,
            title: "P E R F I L",
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.pushNamed(parentContext, 'perfil');
            },
          ),
          _buildListTile(
            icon: Icons.help,
            title: "A J U D A",
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.pushNamed(parentContext, 'tutorial');
            },
          ),
          _buildListTile(
            icon: Icons.settings,
            title: "C O N F I G U R A Ç Õ E S",
            onTap: () {
              Navigator.pop(parentContext);
              Navigator.pushNamed(parentContext, 'settings');
            },
          ),
          Spacer(),
          Divider(thickness: 1, color: pretoAzulado),
          _buildListTile(
            iconWidget: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: const Icon(Icons.exit_to_app, color: fundoRoxoTres),
            ),
            title: "S A I R",
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut(); // desloga o usuário
                Navigator.pushReplacementNamed(
                  context, // usar parentContext para navegação correta
                  'login',
                ); // vai para a tela de login
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erro ao sair: $e')));
              }
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile({
    IconData? icon,
    Widget? iconWidget,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading:
          iconWidget ??
          (icon != null ? Icon(icon, color: fundoRoxoTres) : null),
      title: Text(
        title,
        style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
