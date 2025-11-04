import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/domain/services/locator.dart';
import '../../../../core/routing/app_router.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';
import '../widgets/user_list_item.dart';


class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return BlocProvider(
      create: (_) => getIt<UserCubit>(),
      child: const UserManagementView(),
    );
  }
}

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
     context.read<UserCubit>().fetchUsers();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
       context.read<UserCubit>().fetchUsers();
    }
  }

  Future<void> _navigateToAddUser() async {

    final result = await context.pushNamed(AppRoutes.addUser);

     if (result == true) {
       context.read<UserCubit>().refreshUsers();
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ User added and list updated!'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<UserCubit>().refreshUsers(),
          )
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is AddUserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User ${state.newUser.name} added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          else if (state is AddUserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add user: ${state.failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          else if (state is FetchUsersSuccess) {
            return _buildUserList(context, state);
          }

          else if (state is FetchUsersFailure && !state.isFetchingNextPage) {
            return _buildInitialError(context, state);
          }

          else if (state is UserInitial) {
            return const Center(child: Text('Press refresh to load users.'));
          }

          return const Center(child: Text('Unknown State.'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddUser(),
        label: const Text('Add New User'),
        icon: const Icon(Icons.person_add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Widget _buildUserList(BuildContext context, FetchUsersSuccess state) {
    return RefreshIndicator(
      onRefresh: () => context.read<UserCubit>().refreshUsers(),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: state.users.length + (state.isFetchingNextPage ? 1 : 0),
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == state.users.length) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final user = state.users[index];
          return UserListItem(user: user);
        },
      ),
    );
  }
  Widget _buildInitialError(BuildContext context, FetchUsersFailure state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 16),
            Text(
              'Failed to load users: ${state.failure.message}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<UserCubit>().fetchUsers(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}


