import 'package:dartz/dartz.dart';
import '../../../../core/domain/error_handler/failures.dart';
import '../entities/user_entity.dart';
import '../user_repository.dart';

class FetchUsersUseCase {
  final UserRepository repository;

  FetchUsersUseCase({required this.repository});

   Future<Either<Failure, List<UserEntity>>> call({
    required int page,
    required int perPage,
  }) async {
    return await repository.fetchUsers(page: page, perPage: perPage);
  }
}
