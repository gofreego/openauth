import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UsersEvent {
  final int page;
  final int limit;
  final String? search;
  final bool? isActive;

  const LoadUsersEvent({
    this.page = 1,
    this.limit = 50,
    this.search,
    this.isActive,
  });

  @override
  List<Object?> get props => [page, limit, search, isActive];
}

class RefreshUsersEvent extends UsersEvent {
  final String? search;
  final bool? isActive;

  const RefreshUsersEvent({
    this.search,
    this.isActive,
  });

  @override
  List<Object?> get props => [search, isActive];
}

class CreateUserEvent extends UsersEvent {
  final String username;
  final String email;
  final String password;
  final String? phone;
  final String name;

  const CreateUserEvent({
    required this.username,
    required this.email,
    required this.password,
    this.phone,
    required this.name,
  });

  @override
  List<Object?> get props => [username, email, password, phone, name];
}

class UpdateUserEvent extends UsersEvent {
  final String uuid;
  final String? username;
  final String? email;
  final String? phone;
  final bool? isActive;
  final String? name;
  final String? avatarUrl;

  const UpdateUserEvent({
    required this.uuid,
    this.username,
    this.email,
    this.phone,
    this.isActive,
    this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [uuid, username, email, phone, isActive, name, avatarUrl];
}

class DeleteUserEvent extends UsersEvent {
  final String userIdOrUuid;

  const DeleteUserEvent(this.userIdOrUuid);

  @override
  List<Object> get props => [userIdOrUuid];
}

class SearchUsersEvent extends UsersEvent {
  final String query;

  const SearchUsersEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterUsersEvent extends UsersEvent {
  final bool? isActive;

  const FilterUsersEvent(this.isActive);

  @override
  List<Object?> get props => [isActive];
}