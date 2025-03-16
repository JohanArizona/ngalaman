import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> registerWithEmail(String email, String password); // Tambahkan ini
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _auth;

  AuthDataSourceImpl({required FirebaseAuth auth}) : _auth = auth;

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw FirebaseAuthException(code: 'LOGIN_FAILED', message: e.toString());
    }
  }

  @override
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw FirebaseAuthException(code: 'REGISTER_FAILED', message: e.toString());
    }
  }
}