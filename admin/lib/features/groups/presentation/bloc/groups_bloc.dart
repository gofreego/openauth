import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  Future<void> _onLoadGroups(
      ListGroupsRequest event, Emitter<GroupsState> emit) async {
    try {
      if (state is! GroupsLoaded) {
        emit(const GroupsLoading());
      }

      _currentSearchQuery = event.search;

      final result = await repository.getGroups(event);

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (groups) {
          if (state is GroupsLoaded) {
            // This is pagination - append to existing groups
            final currentState = state as GroupsLoaded;
            final allGroups = List<Group>.from(currentState.groups)
              ..addAll(groups);
            emit(GroupsLoaded(
              groups: allGroups,
              request: event,
              hasReachedMax: groups.length < event.limit,
            ));
          } else {
            // This is initial load or refresh - replace groups
            emit(GroupsLoaded(
              groups: groups,
              request: event,
              hasReachedMax: groups.length < event.limit,
            ));
          }
        },
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onLoadGroupUsers(
      ListGroupUsersRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupUsersLoading());

      final result = await repository.getGroupUsers(event);

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (users) => emit(GroupUsersLoaded(
          users: users,
          groupId: event.groupId,
        )),
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onCreateGroup(
         event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupCreating());

      final result = await repository.createGroup(event);

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (group) {
          emit(GroupCreated(group));
          // Refresh the groups list
          add(ListGroupsRequest(search: _currentSearchQuery));
        },
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onUpdateGroup(
      UpdateGroupRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupUpdating());

      final result = await repository.updateGroup(event);

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (group) {
          emit(GroupUpdated(group));
          // Refresh the groups list
          add(ListGroupsRequest(search: _currentSearchQuery));
        },
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onDeleteGroup(
      DeleteGroupRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupDeleting());

      final result = await repository.deleteGroup(event);

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (_) {
          emit(const GroupDeleted());
          // Refresh the groups list
          add(ListGroupsRequest(search: _currentSearchQuery));
        },
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onLoadUserGroups(
      ListUserGroupsRequest event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupsLoading());

      final result = await repository.getUserGroups(event);

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (userGroups) => emit(UserGroupsLoaded(userGroups)),
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }
}
