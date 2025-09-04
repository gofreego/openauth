import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/groups/data/repositories/groups_repository.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GroupsRepository repository;


  String? _currentSearchQuery;

  GroupsBloc({
    required this.repository,
  }) : super(const GroupsInitial()) {
    on<LoadGroups>(_onLoadGroups);
    on<RefreshGroups>(_onRefreshGroups);
    on<SearchGroups>(_onSearchGroups);
    on<LoadGroup>(_onLoadGroup);
    on<LoadGroupUsers>(_onLoadGroupUsers);
    on<LoadUserGroups>(_onLoadUserGroups);
    on<CreateGroup>(_onCreateGroup);
    on<UpdateGroup>(_onUpdateGroup);
    on<DeleteGroup>(_onDeleteGroup);
  }

  Future<void> _onLoadGroups(
      LoadGroups event, Emitter<GroupsState> emit) async {
    try {
      if (state is! GroupsLoaded) {
        emit(const GroupsLoading());
      }

      _currentSearchQuery = event.search;

      final result = await repository.getGroups(
      request:   ListGroupsRequest(
          search: _currentSearchQuery,
          limit: event.limit ?? 20,
          offset: event.offset ?? 0,
        ),
      );

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (groups) {
          if (state is GroupsLoaded && event.offset != null) {
            // This is pagination - append to existing groups
            final currentState = state as GroupsLoaded;
            final allGroups = List<Group>.from(currentState.groups)
              ..addAll(groups);
            emit(GroupsLoaded(
              groups: allGroups,
              currentSearch: event.search,
              nextPageToken:
                  null, // TODO: Get from response when pagination is implemented
              hasReachedMax: groups.isEmpty,
            ));
          } else {
            // This is initial load or refresh - replace groups
            emit(GroupsLoaded(
              groups: groups,
              currentSearch: event.search,
              nextPageToken:
                  null, // TODO: Get from response when pagination is implemented
              hasReachedMax: false,
            ));
          }
        },
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onRefreshGroups(
      RefreshGroups event, Emitter<GroupsState> emit) async {
    add(LoadGroups(search: event.search));
  }

  Future<void> _onSearchGroups(
      SearchGroups event, Emitter<GroupsState> emit) async {
    _currentSearchQuery = event.query;
    add(LoadGroups(search: event.query));
  }

  Future<void> _onLoadGroup(LoadGroup event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupLoading());

      final result = await repository.getGroup(event.groupId);

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (group) => emit(GroupLoaded(group)),
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onLoadGroupUsers(
      LoadGroupUsers event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupUsersLoading());

      final result = await repository.getGroupUsers(event.groupId);

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
      CreateGroup event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupCreating());

      final result = await repository.createGroup(
        request: CreateGroupRequest(
          name: event.name,
          displayName: event.displayName,
          description: event.description,
        ),
      );

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (group) {
          emit(GroupCreated(group));
          // Refresh the groups list
          add(LoadGroups(search: _currentSearchQuery));
        },
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onUpdateGroup(
      UpdateGroup event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupUpdating());

      final result = await repository.updateGroup(
        request: UpdateGroupRequest(
          id: event.groupId,
          newName: event.name,
          displayName: event.displayName,
          description: event.description,
        ),
      );

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (group) {
          emit(GroupUpdated(group));
          // Refresh the groups list
          add(LoadGroups(search: _currentSearchQuery));
        },
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onDeleteGroup(
      DeleteGroup event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupDeleting());

      final result = await repository.deleteGroup(event.groupId);

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (_) {
          emit(const GroupDeleted());
          // Refresh the groups list
          add(LoadGroups(search: _currentSearchQuery));
        },
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> _onLoadUserGroups(
      LoadUserGroups event, Emitter<GroupsState> emit) async {
    try {
      emit(const GroupsLoading());

      final result = await repository.getUserGroups(event.userId);

      result.fold(
        (failure) => emit(GroupsError(failure.message)),
        (userGroups) => emit(UserGroupsLoaded(userGroups)),
      );
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }
}
