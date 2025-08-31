import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final String? currentSearch;
  final bool? currentFilter;
  final bool hasReachedMax;

  const UsersLoaded({
    required this.users,
    this.currentSearch,
    this.currentFilter,
    this.hasReachedMax = true,
  });

  UsersLoaded copyWith({
    List<UserEntity>? users,
    String? currentSearch,
    bool? currentFilter,
    bool? hasReachedMax,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      currentSearch: currentSearch ?? this.currentSearch,
      currentFilter: currentFilter ?? this.currentFilter,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [users, currentSearch, currentFilter, hasReachedMax];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object> get props => [message];
}

class UserCreating extends UsersState {}

class UserCreated extends UsersState {
  final UserEntity user;

  const UserCreated(this.user);

  @override
  List<Object> get props => [user];
}

class UserUpdating extends UsersState {}

class UserUpdated extends UsersState {
  final UserEntity user;

  const UserUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class UserDeleting extends UsersState {}

class UserDeleted extends UsersState {
  final String deletedUserUuid;

  const UserDeleted(this.deletedUserUuid);

  @override
  List<Object> get props => [deletedUserUuid];
}