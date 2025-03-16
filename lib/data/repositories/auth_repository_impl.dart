import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<User?> login(String email, String password) async {
    return await authDataSource.signInWithEmail(email, password);
  }
  
  @override
  Future<User?> register(String email, String password) async {
    return await authDataSource.registerWithEmail(email, password);
  }
}