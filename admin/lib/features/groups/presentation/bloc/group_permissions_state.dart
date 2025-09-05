import 'package:equatable/equatable.dart';
import 'package:openauth/src/generated/openauth/v1/permission_assignments.pb.dart';

abstract class GroupPermissionsState extends Equatable {
  const GroupPermissionsState();

  @override
  List<Object> get props => [];
}

class GroupPermissionsInitial extends GroupPermissionsState {}

class GroupPermissionsLoading extends GroupPermissionsState {}

class GroupPermissionsLoaded extends GroupPermissionsState {
  final List<EffectivePermission> permissions;

  const GroupPermissionsLoaded(this.permissions);

  @override
  List<Object> get props => [permissions];
}

class GroupPermissionsError extends GroupPermissionsState {
  final String message;

  const GroupPermissionsError(this.message);

  @override
  List<Object> get props => [message];
}

class GroupPermissionAssigning extends GroupPermissionsState {}

class GroupPermissionAssigned extends GroupPermissionsState {
  final String message;

  const GroupPermissionAssigned([this.message = 'Permissions assigned successfully']);

  @override
  List<Object> get props => [message];
}

class GroupPermissionsBulkAssigned extends GroupPermissionsState {
  final String message;

  const GroupPermissionsBulkAssigned([this.message = 'Permissions assigned successfully']);

  @override
  List<Object> get props => [message];
}

class GroupPermissionRemoving extends GroupPermissionsState {}

class GroupPermissionRemoved extends GroupPermissionsState {
  final String message;

  const GroupPermissionRemoved([this.message = 'Permission removed successfully']);

  @override
  List<Object> get props => [message];
}
