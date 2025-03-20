import 'package:ngalaman/domain/repositories/user_repository.dart';

class GetUserData {
  final UserRepository repository;

  GetUserData({required this.repository});

  Future<Map<String, dynamic>?> call() {
    return repository.getUserData();
  }
}
