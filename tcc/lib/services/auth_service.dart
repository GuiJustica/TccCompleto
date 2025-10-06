import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 Envia email de redefinição de senha
  Future<void> resetarSenha(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// 🔹 Login com email e senha
  Future<User?> login(String email, String senha) async {
    final credenciais = await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return credenciais.user;
  }

  /// 🔹 Cadastro com email e senha
  Future<User?> cadastrar(String email, String senha) async {
    final credenciais = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return credenciais.user;
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
