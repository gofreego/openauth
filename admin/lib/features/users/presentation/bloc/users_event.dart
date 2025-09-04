import 'package:equatable/equatable.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';

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
  final SignUpRequest request;

  const CreateUserEvent({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class UpdateUserEvent extends UsersEvent {
  final UpdateUserRequest request;

  const UpdateUserEvent({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
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

class SearchUserByIdEvent extends UsersEvent {
  final String idOrUuid;

  const SearchUserByIdEvent(this.idOrUuid);

  @override
  List<Object> get props => [idOrUuid];
}

class FilterUsersEvent extends UsersEvent {
  final bool? isActive;

  const FilterUsersEvent(this.isActive);

  @override
  List<Object?> get props => [isActive];
}