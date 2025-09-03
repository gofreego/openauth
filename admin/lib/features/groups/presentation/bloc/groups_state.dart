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
  final String? currentSearch;
  final String? nextPageToken;
  final bool hasReachedMax;

  const GroupsLoaded({
    required this.groups,
    this.currentSearch,
    this.nextPageToken,
    this.hasReachedMax = false,
  });

  GroupsLoaded copyWith({
    List<Group>? groups,
    String? currentSearch,
    String? nextPageToken,
    bool? hasReachedMax,
  }) {
    return GroupsLoaded(
      groups: groups ?? this.groups,
      currentSearch: currentSearch ?? this.currentSearch,
      nextPageToken: nextPageToken ?? this.nextPageToken,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [groups, currentSearch, nextPageToken, hasReachedMax];
}

class GroupsError extends GroupsState {
  final String message;

  const GroupsError(this.message);

  @override
  List<Object?> get props => [message];
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
