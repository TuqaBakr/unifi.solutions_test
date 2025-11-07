import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../features/manage_users/data/data_sources/user_remote_data_source.dart';
import '../../../features/manage_users/data/data_sources/user_remote_data_source_imp.dart';
import '../../../features/manage_users/domain/use_cases/add_user_use_case.dart';
import '../../../features/manage_users/domain/use_cases/fetch_user_use_case.dart';
import '../../../features/manage_users/domain/user_repository.dart';
import '../../../features/manage_users/domain/user_repository_imp.dart';
import '../../../features/manage_users/presentation/cubit/user_cubit.dart';
import '../../data/data_sources/user_local_data_source.dart';
import '../../data/models/user_model.dart';
import '../../interceptors/token_interceptor.dart';



final getIt = GetIt.instance;

const String _gorestToken = '82fc1a11d403f8709daa5b98093089dbd23141da091abb443ce482ca898a3915';


Future<void> locatorSetUp() async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserModelAdapter());
  }

  await Hive.openBox<String>('user_cache_box');

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

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  //remote data source
  getIt.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  // Local Data Source
  getIt.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
          remoteDataSource: getIt(),
          localDataSource: getIt(),
          connectivity: getIt(),
        ),
  );
  getIt.registerLazySingleton<FetchUsersUseCase>(
        () => FetchUsersUseCase(repository: getIt<UserRepository>()),
  );


  getIt.registerLazySingleton<AddUserUseCase>(
        () => AddUserUseCase(  repository: getIt<UserRepository>(),),
  );


  getIt.registerFactory<UserCubit>(
        () => UserCubit(
      fetchUsersUseCase: getIt<FetchUsersUseCase>(),
      addUserUseCase: getIt<AddUserUseCase>(),
    ),
  );
}



