import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:unifi_solutions/features/manage_users/domain/user_repository.dart';
import '../../../core/domain/error_handler/failures.dart';
import '../../../core/domain/error_handler/repository_handler.dart';
import '../data/data_sources/user_remote_data_source.dart';
import 'entities/user_entity.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> addUser({
    required String name,
    required String email,
    required String gender,
    required String status,
  }) async {
    try {
      final userModel = await remoteDataSource.addUser(
        name: name,
        email: email,
        gender: gender,
        status: status,
      );
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      final networkExceptions = RepositoryHandler.getDioException(e);
      return Left(RepositoryHandler.getResultFailure(networkExceptions));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> fetchUsers({
    required int page,
    required int perPage,
  }) async {
    try {
      final userModels = await remoteDataSource.fetchUsers(
        page: page,
        perPage: perPage,
      );
      final userEntities = userModels.map((model) => model.toEntity()).toList();
      return Right(userEntities);
    } on DioException catch (e) {
      final networkExceptions = RepositoryHandler.getDioException(e);
      return Left(RepositoryHandler.getResultFailure(networkExceptions));
    }
  }
}