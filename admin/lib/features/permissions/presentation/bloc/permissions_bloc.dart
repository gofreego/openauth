import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:openauth/features/permissions/permissions.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';
import 'package:protobuf/protobuf.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<GeneratedMessage, PermissionsState> {
  final PermissionsRepository repository;
  
  String? _currentSearchQuery; // Store current search query for pagination

  PermissionsBloc({
    required this.repository,
  }) : super(PermissionsInitial()) {
    on<ListPermissionsRequest>(_onLoadPermissions);
    on<GetPermissionRequest>(_onLoadPermission);
    on<CreatePermissionRequest>(_onCreatePermission);
    on<UpdatePermissionRequest>(_onUpdatePermission);
    on<DeletePermissionRequest>(_onDeletePermission);
  }

  Future<void> _onLoadPermissions(
    ListPermissionsRequest event,
    Emitter<PermissionsState> emit,
  ) async {
    _currentSearchQuery = event.search;
    emit(PermissionsLoading());

    final result = await repository.getPermissions(event);

    result.fold(
      (failure) => emit(PermissionsError(failure.message)),
      (permissions) => emit(PermissionsLoaded(
        permissions,
        hasReachedMax: permissions.length < event.limit,
        currentPage: (event.offset / event.limit).floor(),
      )),
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
        // Refresh the list after creating, but only if bloc is still open
        if (!isClosed) {
          add(ListPermissionsRequest(search: _currentSearchQuery));
        }
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
        // Refresh the list after updating, but only if bloc is still open
        if (!isClosed) {
          add(ListPermissionsRequest(search: _currentSearchQuery));
        }
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
        // Refresh the list after deleting, but only if bloc is still open
        if (!isClosed) {
          add(ListPermissionsRequest(
            limit: 20,
            offset: 0,
            search: _currentSearchQuery,
          ));
        }
      },
    );
  }
}
