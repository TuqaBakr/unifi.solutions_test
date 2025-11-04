import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../features/manage_users/data/data_sources/user_remote_data_source.dart';
import '../../../features/manage_users/data/data_sources/user_remote_data_source_imp.dart';
import '../../../features/manage_users/domain/use_cases/add_user_use_case.dart';
import '../../../features/manage_users/domain/use_cases/fetch_user_use_case.dart';
import '../../../features/manage_users/domain/user_repository.dart';
import '../../../features/manage_users/domain/user_repository_imp.dart';
import '../../../features/manage_users/presentation/cubit/user_cubit.dart';
import '../../interceptors/token_interceptor.dart';


final getIt = GetIt.instance;

const String _gorestToken = '82fc1a11d403f8709daa5b98093089dbd23141da091abb443ce482ca898a3915';


Future<void> locatorSetUp() async {
  if (getIt.isRegistered<Dio>()) {
    return;
  }
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://gorest.co.in/public/v2/',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(GlobalApiInterceptor(bearerToken: _gorestToken));

  getIt.registerLazySingleton<Dio>(() => dio);

  getIt.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(dio: getIt<Dio>()), // ⬅️ طلب صريح لـ Dio
  );
  getIt.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(remoteDataSource: getIt<UserRemoteDataSource>()), // ⬅️ طلب صريح للواجهة المسجلة
  );
  getIt.registerLazySingleton<FetchUsersUseCase>(
        () => FetchUsersUseCase(repository: getIt<UserRepository>()), // ⬅️ طلب صريح لـ UserRepository
  );


  getIt.registerLazySingleton<AddUserUseCase>(
        () => AddUserUseCase(  repository: getIt<UserRepository>(),), // ⬅️ طلب صريح لـ UserRepository
  );


  getIt.registerFactory<UserCubit>(
        () => UserCubit(
      fetchUsersUseCase: getIt<FetchUsersUseCase>(), // ⬅️ طلب صريح
      addUserUseCase: getIt<AddUserUseCase>(), // ⬅️ طلب صريح
    ),
  );
}



