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
  
  String? _currentSearchQuery; // Store current search query for pagination

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
    on<LoadMorePermissions>(_onLoadMorePermissions);
  }

  Future<void> _onLoadPermissions(
    LoadPermissions event,
    Emitter<PermissionsState> emit,
  ) async {
    _currentSearchQuery = event.search;
    emit(PermissionsLoading());

    final result = await getPermissionsUseCase(
      limit: event.limit ?? 20, // Default page size
      offset: event.offset ?? 0,
      search: event.search,
    );

    result.fold(
      (failure) => emit(PermissionsError(failure.message)),
      (permissions) => emit(PermissionsLoaded(
        permissions,
        hasReachedMax: permissions.length < (event.limit ?? 20),
        currentPage: ((event.offset ?? 0) / (event.limit ?? 20)).floor(),
      )),
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
        // Refresh the list after creating, but only if bloc is still open
        if (!isClosed) {
          add(const RefreshPermissions());
        }
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
        // Refresh the list after updating, but only if bloc is still open
        if (!isClosed) {
          add(const RefreshPermissions());
        }
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
        // Refresh the list after deleting, but only if bloc is still open
        if (!isClosed) {
          add(const RefreshPermissions());
        }
      },
    );
  }

  Future<void> _onRefreshPermissions(
    RefreshPermissions event,
    Emitter<PermissionsState> emit,
  ) async {
    // Clear search query on refresh
    _currentSearchQuery = null;
    
    // Don't show loading for refresh - just silently reload
    final result = await getPermissionsUseCase(
      limit: 20,
      offset: 0,
    );

    result.fold(
      (failure) => emit(PermissionsError(failure.message)),
      (permissions) => emit(PermissionsLoaded(
        permissions,
        hasReachedMax: permissions.length < 20,
        currentPage: 0,
      )),
    );
  }

  Future<void> _onSearchPermissions(
    SearchPermissions event,
    Emitter<PermissionsState> emit,
  ) async {
    _currentSearchQuery = event.query.isEmpty ? null : event.query;
    emit(PermissionsLoading());

    final result = await getPermissionsUseCase(
      search: _currentSearchQuery, // Don't pass empty search
      limit: event.limit ?? 20,
      offset: 0, // Reset offset for search
    );

    result.fold(
      (failure) => emit(PermissionsError(failure.message)),
      (permissions) => emit(PermissionsLoaded(
        permissions,
        hasReachedMax: permissions.length < (event.limit ?? 20),
        currentPage: 0,
      )),
    );
  }

  Future<void> _onLoadMorePermissions(
    LoadMorePermissions event,
    Emitter<PermissionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PermissionsLoaded || currentState.hasReachedMax || currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final offset = nextPage * 20; // Page size is 20

    final result = await getPermissionsUseCase(
      limit: 20,
      offset: offset,
      search: _currentSearchQuery, // Use stored search query
    );

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (newPermissions) {
        final allPermissions = List<PermissionEntity>.from(currentState.permissions)
          ..addAll(newPermissions);
        
        emit(PermissionsLoaded(
          allPermissions,
          hasReachedMax: newPermissions.length < 20,
          currentPage: nextPage,
          isLoadingMore: false,
        ));
      },
    );
  }
}
