import 'package:dartz/dartz.dart';
import '../../../../core/domain/error_handler/failures.dart';
import '../entities/user_entity.dart';
import '../user_repository.dart';

class AddUserUseCase {
  final UserRepository repository;

  AddUserUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String gender,
    required String status,
  }) async {
    return await repository.addUser(
      name: name,
      email: email,
      gender: gender,
      status: status,
    );
  }
}
