import 'dart:developer' as dev;

import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/core/errors/failures.dart';
import 'package:openauth/features/groups/data/repositories/groups_repository.dart';
import 'package:protobuf/protobuf.dart' as pb;
import '../../../../src/generated/openauth/v1/groups.pb.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<pb.GeneratedMessage, GroupsState> {
  final GroupsRepository repository;

  final int listGroupsLimit = 20;

  String? _currentSearchQuery;

  GroupsBloc({
    required this.repository,
  }) : super(const GroupsInitial()) {
    on<ListGroupsRequest>(_onLoadGroups);
    on<ListGroupUsersRequest>(_onLoadGroupUsers);
    on<ListUserGroupsRequest>(_onLoadUserGroups);
    on<CreateGroupRequest>(_onCreateGroup);
    on<UpdateGroupRequest>(_onUpdateGroup);
    on<DeleteGroupRequest>(_onDeleteGroup);
    on<AssignUsersToGroupRequest>(_onAssignUsersToGroup);
    on<RemoveUsersFromGroupRequest>(_onRemoveUsersFromGroup);
  }

  Future<void> _onLoadGroups(
      ListGroupsRequest event, Emitter<GroupsState> emit) async {
    try {
      // Determine if this is a load more request
      final isLoadMore = event.offset > 0;
      
      if (!isLoadMore && state is! GroupsLoaded) {
        emit(const GroupsLoading());
      }

      // If this is a load more request and we already have data, show loading more state
      if (isLoadMore && state is GroupsLoaded) {
        final currentState = state as GroupsLoaded;
        emit(currentState.copyWith(isLoadingMore: true));
      }

      // If this is a new search, reset offset to 0
      if (event.search != _currentSearchQuery) {
        _currentSearchQuery = event.search;
        final resetEvent = ListGroupsRequest(
          limit: event.limit,
          offset: 0,
          search: event.search,
        );
        emit(const GroupsLoading());
        return _onLoadGroups(resetEvent, emit);
      }

      _currentSearchQuery = event.search;

      final result = await repository.getGroups(event);

      result.fold(
        (failure) => emit(ListGroupError(failure)),
        (groups) {
          if (isLoadMore && state is GroupsLoaded) {
            // This is pagination - append to existing groups
            final currentState = state as GroupsLoaded;
            final allGroups = List<Group>.from(currentState.groups)
              ..addAll(groups);
            emit(GroupsLoaded(
              groups: allGroups,
              request: event,
              hasReachedMax: groups.length < event.limit,
              isLoadingMore: false,
            ));
          } else {
            // This is initial load or refresh - replace groups
            emit(GroupsLoaded(
              groups: groups,
              request: event,
              hasReachedMax: groups.length < event.limit,
              isLoadingMore: false,
            ));
          }
        },
      );
    } catch (e) {
      dev.log("Error loading groups: $e");
      emit(const ListGroupError(ServerFailure(message: "Something went wrong")));
    }
  }

  Future<void> _onLoadGroupUsers(
      ListGroupUsersRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupUsersLoading());

      final result = await repository.getGroupUsers(event);

      result.fold(
        (failure) => emit(ListGroupError(failure)),
        (users) => emit(GroupUsersLoaded(
          users: users,
          groupId: event.groupId,
        )),
      );
    } catch (e) {
      dev.log("Error loading group users: $e");
      emit(const ListGroupError(ServerFailure(message: "Something went wrong")));
    }
  }

  Future<void> _onCreateGroup(
         event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupCreating());

      final result = await repository.createGroup(event);

      result.fold(
        (failure) => emit(CreateGroupError(failure)),
        (group) {
          emit(GroupCreated(group));
          // Refresh the groups list
          add(ListGroupsRequest(
            search: _currentSearchQuery,
            limit: listGroupsLimit,
            offset: 0,
          ));
        },
      );
    } catch (e) {
      dev.log("Error creating group: $e");
      emit(const CreateGroupError(ServerFailure(message: "Something went wrong")));
    }
  }

  Future<void> _onUpdateGroup(
      UpdateGroupRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupUpdating());

      final result = await repository.updateGroup(event);

      result.fold(
        (failure) => emit(UpdateGroupError(failure)),
        (group) {
          emit(GroupUpdated(group));
          // Refresh the groups list
          add(ListGroupsRequest(
            search: _currentSearchQuery,
            limit: listGroupsLimit,
            offset: 0,
          ));
        },
      );
    } catch (e) {
      dev.log("Error updating group: $e");
      emit(const UpdateGroupError(ServerFailure(message: "Something went wrong")));
    }
  }

  Future<void> _onDeleteGroup(
      DeleteGroupRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupDeleting());

      final result = await repository.deleteGroup(event);

      result.fold(
        (failure) => emit(DeleteGroupError(failure)),
        (_) {
          emit(const GroupDeleted());
          // Refresh the groups list
          add(ListGroupsRequest(
            search: _currentSearchQuery,
            limit: listGroupsLimit,
            offset: 0,
          ));
        },
      );
    } catch (e) {
      dev.log("Error deleting group: $e");
      emit(const DeleteGroupError(ServerFailure(message: "Something went wrong")));
    }
  }

  Future<void> _onRemoveUsersFromGroup(
      RemoveUsersFromGroupRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const UserRemoving());

      final result = await repository.removeUserFromGroup(event);

      result.fold(
        (failure) => emit(GroupsError(failure)),
        (_) {
          emit(const UserRemoved());
        },
      );
    } catch (e) {
      dev.log("Error removing user from group: $e");
      emit(const GroupsError(ServerFailure(message: "Something went wrong")));
    }
  }

  Future<void> _onAssignUsersToGroup(
      AssignUsersToGroupRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const UserAssigning());

      final result = await repository.assignUserToGroup(event);

      result.fold(
        (failure) => emit(GroupsError(failure)),
        (_) {
          emit(const UserAssigned());
        },
      );
    } catch (e) {
      dev.log("Error assigning user to group: $e");
      emit(const GroupsError(ServerFailure(message: "Something went wrong")));
    }
  }

  Future<void> _onLoadUserGroups(
      ListUserGroupsRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupsLoading());

      final result = await repository.getUserGroups(event);

      result.fold(
        (failure) => emit(GroupsError(failure)),
        (userGroups) => emit(UserGroupsLoaded(userGroups)),
      );
    } catch (e) {
      dev.log("Error loading user groups: $e");
      emit(const GroupsError(ServerFailure(message: "Something went wrong")));
    }
  }
}
