import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<User?> execute(String email, String password, String firstName, String lastName) async {
    return await repository.register(email, password, firstName, lastName);
  }
}