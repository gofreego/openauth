import 'package:equatable/equatable.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../../core/errors/failures.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<pb.User> users;
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
    List<pb.User>? users,
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
  final Failure failure;

  const UsersError(this.failure);

  // Keep message getter for backward compatibility
  String get message => failure.message;

  @override
  List<Object> get props => [failure];
}

class UserCreating extends UsersState {}

class UserCreated extends UsersState {
  final pb.User user;

  const UserCreated(this.user);

  @override
  List<Object> get props => [user];
}

class UserUpdating extends UsersState {}

class UserUpdated extends UsersState {
  final pb.User user;

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