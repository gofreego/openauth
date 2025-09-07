part of 'groups_bloc.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();

  @override
  List<Object?> get props => [];
}

class GroupsInitial extends GroupsState {
  const GroupsInitial();
}

class GroupsLoading extends GroupsState {
  const GroupsLoading();
}

class GroupsLoaded extends GroupsState {
  final List<Group> groups;
  final ListGroupsRequest request;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const GroupsLoaded({
    required this.groups,
    required this.request,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  GroupsLoaded copyWith({
    List<Group>? groups,
    ListGroupsRequest? request,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return GroupsLoaded(
      groups: groups ?? this.groups,
      request: request ?? this.request,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [groups, request, hasReachedMax, isLoadingMore];
}

class GroupsError extends GroupsState {
  final Failure failure;

  const GroupsError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class ListGroupError extends GroupsState {
  final Failure failure;

  const ListGroupError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class UpdateGroupError extends GroupsState {
  final Failure failure;

  const UpdateGroupError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class CreateGroupError extends GroupsState {
  final Failure failure;

  const CreateGroupError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class DeleteGroupError extends GroupsState {
  final Failure failure;

  const DeleteGroupError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class GroupLoading extends GroupsState {
  const GroupLoading();
}

class GroupLoaded extends GroupsState {
  final Group group;

  const GroupLoaded(this.group);

  @override
  List<Object?> get props => [group];
}

class GroupCreating extends GroupsState {
  const GroupCreating();
}

class GroupCreated extends GroupsState {
  final Group group;

  const GroupCreated(this.group);

  @override
  List<Object?> get props => [group];
}

class GroupUpdating extends GroupsState {
  const GroupUpdating();
}

class GroupUpdated extends GroupsState {
  final Group group;

  const GroupUpdated(this.group);

  @override
  List<Object?> get props => [group];
}

class GroupDeleting extends GroupsState {
  const GroupDeleting();
}

class GroupDeleted extends GroupsState {
  const GroupDeleted();
}

class GroupUsersLoading extends GroupsState {
  const GroupUsersLoading();
}

class GroupUsersLoaded extends GroupsState {
  final List<GroupUser> users;
  final Int64 groupId;

  const GroupUsersLoaded({
    required this.users,
    required this.groupId,
  });

  @override
  List<Object?> get props => [users, groupId];
}

class UserAssigning extends GroupsState {
  const UserAssigning();
}

class UserAssigned extends GroupsState {
  const UserAssigned();
}

class UserRemoving extends GroupsState {
  const UserRemoving();
}

class UserRemoved extends GroupsState {
  const UserRemoved();
}

class UserGroupsLoaded extends GroupsState {
  final List<UserGroup> groups;

  const UserGroupsLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}
