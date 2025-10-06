import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc/constants/CoresDefinidas/preto_letra.dart';
import 'package:tcc/constants/CoresDefinidas/branco_sujo.dart';

class ForgetSenha extends StatefulWidget {
  const ForgetSenha({super.key});

  @override
  State<ForgetSenha> createState() => _ForgetSenhaState();
}

class _ForgetSenhaState extends State<ForgetSenha> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("E-mail de redefinição enviado!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // volta para a tela de login
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Erro ao enviar e-mail"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      backgroundColor: fundoBranco,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Digite seu e-mail para receber um link de redefinição de senha.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite um e-mail válido";
                  }
                  if (!value.contains("@")) {
                    return "Formato de e-mail inválido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _resetPassword,
                child:
                    _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Enviar link"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
