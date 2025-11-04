import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/add_user_use_case.dart';
import '../../domain/use_cases/fetch_user_use_case.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final FetchUsersUseCase fetchUsersUseCase;
  final AddUserUseCase addUserUseCase;

  static const int usersPerPage = 20;
  List<UserEntity> _allUsers = [];
  int _currentPage = 1;
  bool _hasMore = true;

  UserCubit({
    required this.fetchUsersUseCase,
    required this.addUserUseCase,
  }) : super(const UserInitial());

  Future<void> fetchUsers() async {
    if (!_hasMore && _currentPage > 1) return;

    if (_currentPage == 1) {
      emit(const UserLoading());
      _allUsers = [];
    } else {
      final currentState = state;
      if (currentState is FetchUsersSuccess) {
        emit(currentState.copyWith(isFetchingNextPage: true));
      }
    }

    final result = await fetchUsersUseCase(
      page: _currentPage,
      perPage: usersPerPage,
    );

    result.fold(
          (failure) {
        emit(FetchUsersFailure(
          failure: failure,
          isFetchingNextPage: _currentPage > 1, // true إذا فشل تحميل صفحة إضافية
        ));
      },
          (newUsers) {
        _allUsers.addAll(newUsers);
        _currentPage++;
        _hasMore = newUsers.length == usersPerPage;

        emit(FetchUsersSuccess(
          users: _allUsers,
          isFetchingNextPage: false,
          currentPage: _currentPage - 1,
          hasMore: _hasMore,
        ));
      },
    );
  }

  Future<void> refreshUsers() async {
    _currentPage = 1;
    _hasMore = true;
    return fetchUsers();
  }

  Future<void> addUser({
    required String name,
    required String email,
    required String gender,
    required String status,
  }) async {
    emit(const UserLoading());

    final result = await addUserUseCase(
      name: name,
      email: email,
      gender: gender,
      status: status,
    );

    result.fold(
          (failure) {
        emit(AddUserFailure(failure: failure));
        _revertToCurrentListState();
      },
          (newUser) {
        _allUsers.insert(0, newUser);
        emit(AddUserSuccess(newUser: newUser));
        _revertToCurrentListState();
      },
    );
  }

  void _revertToCurrentListState() {
    if (_allUsers.isNotEmpty) {
      emit(FetchUsersSuccess(
        users: _allUsers,
        isFetchingNextPage: false,
        currentPage: _currentPage - 1,
        hasMore: _hasMore,
      ));
    } else {
      emit(const UserInitial());
    }
  }
}
