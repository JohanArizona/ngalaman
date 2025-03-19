import 'package:ngalaman/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase({required this.repository});

  Future<void> execute(String email) async {
    await repository.resetPassword(email);
  }
}
