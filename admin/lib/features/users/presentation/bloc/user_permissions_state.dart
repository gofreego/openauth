import 'package:equatable/equatable.dart';
import '../../../../src/generated/openauth/v1/permission_assignments.pb.dart' as pb;

abstract class UserPermissionsState extends Equatable {
  const UserPermissionsState();

  @override
  List<Object?> get props => [];
}

class UserPermissionsInitial extends UserPermissionsState {}

class UserPermissionsLoading extends UserPermissionsState {}

class UserPermissionsLoaded extends UserPermissionsState {
  final List<pb.EffectivePermission> permissions;

  const UserPermissionsLoaded(this.permissions);

  @override
  List<Object?> get props => [permissions];
}

class UserPermissionsError extends UserPermissionsState {
  final String message;

  const UserPermissionsError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserPermissionAssigning extends UserPermissionsState {}

class UserPermissionAssigned extends UserPermissionsState {

  const UserPermissionAssigned();

  @override
  List<Object?> get props => [];
}

class UserPermissionRemoving extends UserPermissionsState {}

class UserPermissionRemoved extends UserPermissionsState {
  final String message;

  const UserPermissionRemoved(this.message);

  @override
  List<Object?> get props => [message];
}
