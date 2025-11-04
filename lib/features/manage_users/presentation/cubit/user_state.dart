import 'package:equatable/equatable.dart';

import '../../../../core/domain/error_handler/failures.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class FetchUsersSuccess extends UserState {
  final List<UserEntity> users;
  final bool isFetchingNextPage;
  final int currentPage;
  final bool hasMore;

  const FetchUsersSuccess({
    required this.users,
    this.isFetchingNextPage = false,
    required this.currentPage,
    required this.hasMore,
  });

  FetchUsersSuccess copyWith({
    List<UserEntity>? users,
    bool? isFetchingNextPage,
    int? currentPage,
    bool? hasMore,
  }) {
    return FetchUsersSuccess(
      users: users ?? this.users,
      isFetchingNextPage: isFetchingNextPage ?? this.isFetchingNextPage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [users, isFetchingNextPage, currentPage, hasMore];
}

class FetchUsersFailure extends UserState {
  final Failure failure;
  final bool isFetchingNextPage;

  const FetchUsersFailure({
    required this.failure,
    this.isFetchingNextPage = false,
  });

  @override
  List<Object?> get props => [failure, isFetchingNextPage];
}

class AddUserSuccess extends UserState {
  final UserEntity newUser;

  const AddUserSuccess({required this.newUser});

  @override
  List<Object?> get props => [newUser];
}

class AddUserFailure extends UserState {
  final Failure failure;

  const AddUserFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
