import 'package:dartz/dartz.dart';
import 'package:unifi_solutions/features/manage_users/domain/entities/user_entity.dart';
import '../../../core/domain/error_handler/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> fetchUsers({
    required int page,
    required int perPage,
  });

  Future<Either<Failure, UserEntity>> addUser({
    required String name,
    required String email,
    required String gender,
    required String status,
  });
}