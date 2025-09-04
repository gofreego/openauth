part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroups extends GroupsEvent {
  final String? search;
  final int? limit;
  final int? offset;

  const LoadGroups({
    this.search,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [search, limit, offset];
}

class RefreshGroups extends GroupsEvent {
  final String? search;

  const RefreshGroups({this.search});

  @override
  List<Object?> get props => [search];
}

class SearchGroups extends GroupsEvent {
  final String query;

  const SearchGroups(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadGroup extends GroupsEvent {
  final Int64 groupId;

  const LoadGroup(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class CreateGroup extends GroupsEvent {
  final String name;
  final String displayName;
  final String? description;

  const CreateGroup({
    required this.name,
    required this.displayName,
    this.description,
  });

  @override
  List<Object?> get props => [name, displayName, description];
}

class UpdateGroup extends GroupsEvent {
  final Int64 groupId;
  final String name;
  final String displayName;
  final String? description;

  const UpdateGroup({
    required this.groupId,
    required this.name,
    required this.displayName,
    this.description,
  });

  @override
  List<Object?> get props => [groupId, name, displayName, description];
}

class DeleteGroup extends GroupsEvent {
  final Int64 groupId;

  const DeleteGroup(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class LoadGroupUsers extends GroupsEvent {
  final Int64 groupId;

  const LoadGroupUsers(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class AssignUserToGroup extends GroupsEvent {
  final Int64 groupId;
  final Int64 userId;

  const AssignUserToGroup({
    required this.groupId,
    required this.userId,
  });

  @override
  List<Object?> get props => [groupId, userId];
}

class RemoveUserFromGroup extends GroupsEvent {
  final Int64 groupId;
  final Int64 userId;

  const RemoveUserFromGroup({
    required this.groupId,
    required this.userId,
  });

  @override
  List<Object?> get props => [groupId, userId];
}

class LoadUserGroups extends GroupsEvent {
  final Int64 userId;

  const LoadUserGroups(this.userId);

  @override
  List<Object?> get props => [userId];
}
