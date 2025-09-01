part of 'permissions_bloc.dart';

abstract class PermissionsState extends Equatable {
  const PermissionsState();

  @override
  List<Object?> get props => [];
}

class PermissionsInitial extends PermissionsState {}

class PermissionsLoading extends PermissionsState {}

class PermissionsLoaded extends PermissionsState {
  final List<PermissionEntity> permissions;
  final bool hasReachedMax;
  final int currentPage;
  final bool isLoadingMore;

  const PermissionsLoaded(
    this.permissions, {
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.isLoadingMore = false,
  });

  PermissionsLoaded copyWith({
    List<PermissionEntity>? permissions,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return PermissionsLoaded(
      permissions ?? this.permissions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [permissions, hasReachedMax, currentPage, isLoadingMore];
}

class PermissionsError extends PermissionsState {
  final String message;

  const PermissionsError(this.message);

  @override
  List<Object> get props => [message];
}

// Single permission states
class PermissionLoading extends PermissionsState {}

class PermissionLoaded extends PermissionsState {
  final PermissionEntity permission;

  const PermissionLoaded(this.permission);

  @override
  List<Object> get props => [permission];
}

class PermissionError extends PermissionsState {
  final String message;

  const PermissionError(this.message);

  @override
  List<Object> get props => [message];
}

// Create permission states
class PermissionCreating extends PermissionsState {}

class PermissionCreated extends PermissionsState {
  final PermissionEntity permission;

  const PermissionCreated(this.permission);

  @override
  List<Object> get props => [permission];
}

// Update permission states
class PermissionUpdating extends PermissionsState {}

class PermissionUpdated extends PermissionsState {
  final PermissionEntity permission;

  const PermissionUpdated(this.permission);

  @override
  List<Object> get props => [permission];
}

// Delete permission states
class PermissionDeleting extends PermissionsState {}

class PermissionDeleted extends PermissionsState {}
