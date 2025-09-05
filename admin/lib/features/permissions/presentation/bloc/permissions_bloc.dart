import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:openauth/features/permissions/permissions.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';
import 'package:protobuf/protobuf.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<GeneratedMessage, PermissionsState> {
  final PermissionsRepository repository;
  
  String? _currentSearchQuery; // Store current search query for pagination
  static const int _defaultPageSize = 20;

  PermissionsBloc({
    required this.repository,
  }) : super(PermissionsInitial()) {
    on<ListPermissionsRequest>(_onLoadPermissions);
    on<GetPermissionRequest>(_onLoadPermission);
    on<CreatePermissionRequest>(_onCreatePermission);
    on<UpdatePermissionRequest>(_onUpdatePermission);
    on<DeletePermissionRequest>(_onDeletePermission);
  }

  // Helper method to create a refresh request
  void _refreshPermissions({String? searchQuery}) {
    if (!isClosed) {
      add(ListPermissionsRequest(
        limit: _defaultPageSize,
        offset: 0,
        search: searchQuery ?? _currentSearchQuery,
      ));
    }
  }

  Future<void> _onLoadPermissions(
    ListPermissionsRequest event,
    Emitter<PermissionsState> emit,
  ) async {
    final isRefresh = event.offset == 0;
    final isNewSearch = event.search != _currentSearchQuery;
    
    _currentSearchQuery = event.search;

    if (isRefresh || isNewSearch) {
      // Fresh load or new search
      emit(PermissionsLoading());
    } else {
      // Pagination - show loading indicator without replacing content
      if (state is PermissionsLoaded) {
        final currentState = state as PermissionsLoaded;
        emit(currentState.copyWith(isLoadingMore: true));
      }
    }

    final result = await repository.getPermissions(event);

    result.fold(
      (failure) => emit(PermissionsError(failure.message)),
      (newPermissions) {
        if (isRefresh || isNewSearch) {
          // Replace existing permissions
          emit(PermissionsLoaded(
            newPermissions,
            hasReachedMax: newPermissions.length < (event.limit > 0 ? event.limit : 20),
            currentPage: event.limit > 0 ? (event.offset / event.limit).floor() : 0,
          ));
        } else {
          // Append to existing permissions (pagination)
          if (state is PermissionsLoaded) {
            final currentState = state as PermissionsLoaded;
            final allPermissions = List<Permission>.from(currentState.permissions)
              ..addAll(newPermissions);
            
            emit(PermissionsLoaded(
              allPermissions,
              hasReachedMax: newPermissions.length < (event.limit > 0 ? event.limit : 20),
              currentPage: event.limit > 0 ? (event.offset / event.limit).floor() : 0,
              isLoadingMore: false,
            ));
          } else {
            // Fallback if state is not PermissionsLoaded
            emit(PermissionsLoaded(
              newPermissions,
              hasReachedMax: newPermissions.length < (event.limit > 0 ? event.limit : 20),
              currentPage: event.limit > 0 ? (event.offset / event.limit).floor() : 0,
            ));
          }
        }
      },
    );
  }

  Future<void> _onLoadPermission(
    GetPermissionRequest event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionLoading());

    final result = await repository.getPermission(event);

    result.fold(
      (failure) => emit(PermissionError(failure.message)),
      (permission) => emit(PermissionLoaded(permission)),
    );
  }

  Future<void> _onCreatePermission(
    CreatePermissionRequest event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionCreating());

    final result = await repository.createPermission(event);

    result.fold(
      (failure) => emit(PermissionError(failure.message)),
      (permission) {
        emit(PermissionCreated(permission));
        // Refresh the list after creating
        _refreshPermissions();
      },
    );
  }

  Future<void> _onUpdatePermission(
    UpdatePermissionRequest event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionUpdating());

    final result = await repository.updatePermission(event);

    result.fold(
      (failure) => emit(PermissionError(failure.message)),
      (permission) {
        emit(PermissionUpdated(permission));
        // Refresh the list after updating
        _refreshPermissions();
      },
    );
  }

  Future<void> _onDeletePermission(
    DeletePermissionRequest event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionDeleting());

    final result = await repository.deletePermission(event);

    result.fold(
      (failure) => emit(PermissionError(failure.message)),
      (_) {
        emit(PermissionDeleted());
        // Refresh the list after deleting
        _refreshPermissions();
      },
    );
  }
}
