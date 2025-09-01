part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPermissions extends PermissionsEvent {
  final int? limit;
  final int? offset;
  final String? search;

  const LoadPermissions({
    this.limit,
    this.offset,
    this.search,
  });

  @override
  List<Object?> get props => [limit, offset, search];
}

class LoadPermission extends PermissionsEvent {
  final int permissionId;

  const LoadPermission(this.permissionId);

  @override
  List<Object> get props => [permissionId];
}

class CreatePermission extends PermissionsEvent {
  final pb.CreatePermissionRequest request;

  const CreatePermission(this.request);

  @override
  List<Object> get props => [request];
}

class UpdatePermission extends PermissionsEvent {
  final pb.UpdatePermissionRequest request;

  const UpdatePermission(this.request);

  @override
  List<Object> get props => [request];
}

class DeletePermission extends PermissionsEvent {
  final int permissionId;

  const DeletePermission(this.permissionId);

  @override
  List<Object> get props => [permissionId];
}

class RefreshPermissions extends PermissionsEvent {
  const RefreshPermissions();
}

class SearchPermissions extends PermissionsEvent {
  final String query;
  final int? limit;

  const SearchPermissions(this.query, {this.limit});

  @override
  List<Object?> get props => [query, limit];
}

class LoadMorePermissions extends PermissionsEvent {
  const LoadMorePermissions();
}
