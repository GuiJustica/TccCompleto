import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Home', style: TextStyle(color: Colors.white)),
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Container(
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.deepPurple.shade100),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      "Dispositivos",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'cadastroHardware');
                      },
                      icon: Icon(Icons.add_circle_outline),
                      color: Colors.deepPurple,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'cadastroHardware');
                      },
                      icon: Icon(Icons.dehaze),
                      color: Colors.deepPurple,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'cadastroHardware');
                      },
                      icon: Icon(Icons.brush),
                      color: Colors.deepPurple,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'cadastroHardware');
                      },
                      icon: Icon(Icons.view_quilt_rounded),
                      color: Colors.deepPurple,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'cadastroHardware');
                      },
                      icon: Icon(Icons.waves),
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container(color: Colors.amber)),
          ],
        ),
      ),
    );
  }
}
