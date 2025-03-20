import 'package:ngalaman/data/datasources/user_remote_data_source.dart';
import 'package:ngalaman/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>?> getUserData() {
    return remoteDataSource.getUserData();
  }
}
