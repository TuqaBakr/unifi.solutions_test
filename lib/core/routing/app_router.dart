import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/manage_users/domain/use_cases/add_user_use_case.dart';
import '../../features/manage_users/domain/use_cases/fetch_user_use_case.dart';
import '../../features/manage_users/presentation/cubit/user_cubit.dart';
import '../../features/manage_users/presentation/screens/add_user.dart';
import '../../features/manage_users/presentation/screens/user_managment_screen.dart';
import '../../features/section2/screens/native_info_screen.dart';
import '../domain/services/locator.dart';
import '../widgets/error_screen.dart';

class AppRoutes {
  static const String home = 'home';
  static const String userManagement = 'userManagement';
  static const String addUser = 'addUser';
  static const String nativeInfo = '/nativeInfo';
}


final GoRouter appRouter = GoRouter(
  initialLocation: '/users',

  routes: [

    GoRoute(
      path: '/',
      name: AppRoutes.home,
      builder: (context, state) => const PlaceholderPage(title: 'Home /'),
    ),

    //home Page:
    GoRoute(
      path: '/users',
      name: AppRoutes.userManagement,
      builder:(BuildContext context, GoRouterState state) {
         return BlocProvider(
           create: (context) => UserCubit(
             fetchUsersUseCase: getIt<FetchUsersUseCase>(),
             addUserUseCase: getIt<AddUserUseCase>(),
           )..fetchUsers(),
           child: const UserManagementScreen(),
         );
      },
      routes: [
        GoRoute(
          path: 'add-user',
          name: AppRoutes.addUser,
          pageBuilder: (context, state) {
            final userCubit = context.read<UserCubit>();

            return MaterialPage(
              child: BlocProvider.value(
                value: userCubit,
                child: const AddUserScreen(),
              ),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/native-info',
      name: AppRoutes.nativeInfo,
      builder: (context, state) => const NativeInfoScreen(),
    ),

  ],
  errorBuilder: (context, state) => ErrorScreen(error: state.error.toString()),
);


class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Page Placeholder: $title',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

