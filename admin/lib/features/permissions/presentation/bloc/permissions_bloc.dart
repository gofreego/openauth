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
    // Determine if this is a load more request
    final isLoadMore = event.offset > 0;
    final isNewSearch = event.search != _currentSearchQuery;
    
    // If this is a new search, reset offset to 0
    if (isNewSearch) {
      _currentSearchQuery = event.search;
      final resetEvent = ListPermissionsRequest(
        limit: event.limit,
        offset: 0,
        search: event.search,
      );
      emit(PermissionsLoading());
      return _onLoadPermissions(resetEvent, emit);
    }

    _currentSearchQuery = event.search;

    if (!isLoadMore && state is! PermissionsLoaded) {
      emit(PermissionsLoading());
    }

    // If this is a load more request and we already have data, show loading more state
    if (isLoadMore && state is PermissionsLoaded) {
      final currentState = state as PermissionsLoaded;
      emit(currentState.copyWith(isLoadingMore: true));
    }

    final result = await repository.getPermissions(event);

    result.fold(
      (failure) => emit(PermissionsError(failure.message)),
      (newPermissions) {
        if (isLoadMore && state is PermissionsLoaded) {
          // This is pagination - append to existing permissions
          final currentState = state as PermissionsLoaded;
          final allPermissions = List<Permission>.from(currentState.permissions)
            ..addAll(newPermissions);
          
          emit(PermissionsLoaded(
            allPermissions,
            hasReachedMax: newPermissions.length < (event.limit > 0 ? event.limit : _defaultPageSize),
            currentPage: event.limit > 0 ? (event.offset / event.limit).floor() : 0,
            isLoadingMore: false,
          ));
        } else {
          // This is initial load or refresh - replace permissions
          emit(PermissionsLoaded(
            newPermissions,
            hasReachedMax: newPermissions.length < (event.limit > 0 ? event.limit : _defaultPageSize),
            currentPage: event.limit > 0 ? (event.offset / event.limit).floor() : 0,
            isLoadingMore: false,
          ));
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
