import 'package:equatable/equatable.dart';

abstract class UserPermissionsEvent extends Equatable {
  const UserPermissionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserPermissions extends UserPermissionsEvent {
  final int userId;

  const LoadUserPermissions(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AssignPermissionToUser extends UserPermissionsEvent {
  final int userId;
  final int permissionId;

  const AssignPermissionToUser(this.userId, this.permissionId);

  @override
  List<Object?> get props => [userId, permissionId];
}

class AssignPermissionsToUser extends UserPermissionsEvent {
  final int userId;
  final List<int> permissionIds;

  const AssignPermissionsToUser(this.userId, this.permissionIds);

  @override
  List<Object?> get props => [userId, permissionIds];
}

class RemovePermissionFromUser extends UserPermissionsEvent {
  final int userId;
  final int permissionId;

  const RemovePermissionFromUser(this.userId, this.permissionId);

  @override
  List<Object?> get props => [userId, permissionId];
}

class RefreshUserPermissions extends UserPermissionsEvent {
  final int userId;

  const RefreshUserPermissions(this.userId);

  @override
  List<Object?> get props => [userId];
}
