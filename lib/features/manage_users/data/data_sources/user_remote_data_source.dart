import '../../../../core/data/models/user_model.dart';

abstract class UserRemoteDataSource{

  Future<List<UserModel>> fetchUsers({required int page, required int perPage});

  Future<UserModel> addUser({
    required String name,
    required String email,
    required String gender,
    required String status,
  });
}
