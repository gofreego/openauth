import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/permission_entity.dart';
import '../../domain/usecases/get_permissions_usecase.dart';
import '../../domain/usecases/get_permission_usecase.dart';
import '../../domain/usecases/create_permission_usecase.dart';
import '../../domain/usecases/update_permission_usecase.dart';
import '../../domain/usecases/delete_permission_usecase.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final GetPermissionsUseCase getPermissionsUseCase;
  final GetPermissionUseCase getPermissionUseCase;
  final CreatePermissionUseCase createPermissionUseCase;
  final UpdatePermissionUseCase updatePermissionUseCase;
  final DeletePermissionUseCase deletePermissionUseCase;

  PermissionsBloc({
    required this.getPermissionsUseCase,
    required this.getPermissionUseCase,
    required this.createPermissionUseCase,
    required this.updatePermissionUseCase,
    required this.deletePermissionUseCase,
  }) : super(PermissionsInitial()) {
    on<LoadPermissions>(_onLoadPermissions);
    on<LoadPermission>(_onLoadPermission);
    on<CreatePermission>(_onCreatePermission);
    on<UpdatePermission>(_onUpdatePermission);
    on<DeletePermission>(_onDeletePermission);
    on<RefreshPermissions>(_onRefreshPermissions);
    on<SearchPermissions>(_onSearchPermissions);
  }

  Future<void> _onLoadPermissions(
    LoadPermissions event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionsLoading());

    final result = await getPermissionsUseCase(
      limit: event.limit,
      offset: event.offset,
      search: event.search,
    );

    result.fold(
      (failure) => emit(PermissionsError(failure.message)),
      (permissions) => emit(PermissionsLoaded(permissions)),
    );
  }

  Future<void> _onLoadPermission(
    LoadPermission event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionLoading());

    final result = await getPermissionUseCase(event.permissionId);

    result.fold(
      (failure) => emit(PermissionError(failure.message)),
      (permission) => emit(PermissionLoaded(permission)),
    );
  }

  Future<void> _onCreatePermission(
    CreatePermission event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionCreating());

    final result = await createPermissionUseCase(event.request);

    result.fold(
      (failure) => emit(PermissionError(failure.message)),
      (permission) {
        emit(PermissionCreated(permission));
        // Refresh the list after creating
        add(const RefreshPermissions());
      },
    );
  }

  Future<void> _onUpdatePermission(
    UpdatePermission event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionUpdating());

    final result = await updatePermissionUseCase(event.request);

    result.fold(
      (failure) => emit(PermissionError(failure.message)),
      (permission) {
        emit(PermissionUpdated(permission));
        // Refresh the list after updating
        add(const RefreshPermissions());
      },
    );
  }

  Future<void> _onDeletePermission(
    DeletePermission event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionDeleting());

    final result = await deletePermissionUseCase(event.permissionId);

    result.fold(
      (failure) => emit(PermissionError(failure.message)),
      (_) {
        emit(PermissionDeleted());
        // Refresh the list after deleting
        add(const RefreshPermissions());
      },
    );
  }

  Future<void> _onRefreshPermissions(
    RefreshPermissions event,
    Emitter<PermissionsState> emit,
  ) async {
    // Don't show loading for refresh - just silently reload
    final result = await getPermissionsUseCase();

    result.fold(
      (failure) => emit(PermissionsError(failure.message)),
      (permissions) => emit(PermissionsLoaded(permissions)),
    );
  }

  Future<void> _onSearchPermissions(
    SearchPermissions event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(PermissionsLoading());

    final result = await getPermissionsUseCase(
      search: event.query,
      limit: event.limit,
      offset: 0, // Reset offset for search
    );

    result.fold(
      (failure) => emit(PermissionsError(failure.message)),
      (permissions) => emit(PermissionsLoaded(permissions)),
    );
  }
}
