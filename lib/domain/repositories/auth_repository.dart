import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> register(String email, String password, String firstName, String lastName); 
  Future<void> resetPassword(String email);
}