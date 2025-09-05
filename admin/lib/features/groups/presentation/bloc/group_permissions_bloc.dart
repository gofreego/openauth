import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/permissions/permissions.dart';
import 'package:openauth/src/generated/openauth/v1/permission_assignments.pb.dart';
import 'package:protobuf/protobuf.dart';
import 'group_permissions_state.dart';

class GroupPermissionsBloc extends Bloc<GeneratedMessage, GroupPermissionsState> {
  final PermissionsRepository repository;

  GroupPermissionsBloc({
    required this.repository,
  }) : super(GroupPermissionsInitial()) {
    on<ListGroupPermissionsRequest>(_onLoadGroupPermissions);
    on<AssignPermissionsToGroupRequest>(_onAssignPermissionToGroup);
    on<RemovePermissionsFromGroupRequest>(_onRemovePermissionFromGroup);
  }

  Future<void> _onLoadGroupPermissions(
      ListGroupPermissionsRequest event, Emitter<GroupPermissionsState> emit) async {
    try {
      emit(GroupPermissionsLoading());

      final result = await repository.getGroupPermissions(event);

      result.fold(
        (failure) => emit(GroupPermissionsError(failure.message)),
        (response) => emit(GroupPermissionsLoaded(response.permissions)),
      );
    } catch (e) {
      emit(GroupPermissionsError('Failed to load group permissions: ${e.toString()}'));
    }
  }

  Future<void> _onAssignPermissionToGroup(
      AssignPermissionsToGroupRequest event, Emitter<GroupPermissionsState> emit) async {
    try {
      emit(GroupPermissionAssigning());

      final result = await repository.assignPermissionsToGroup(event);

      result.fold(
        (failure) => emit(GroupPermissionsError(failure.message)),
        (response) => emit(const GroupPermissionsBulkAssigned()),
      );
    } catch (e) {
      emit(GroupPermissionsError('Failed to assign permission: ${e.toString()}'));
    }
  }

  Future<void> _onRemovePermissionFromGroup(
      RemovePermissionsFromGroupRequest event, Emitter<GroupPermissionsState> emit) async {
    try {
      emit(GroupPermissionRemoving());

      final result = await repository.removePermissionsFromGroup(event);

      result.fold(
        (failure) => emit(GroupPermissionsError(failure.message)),
        (response) => emit(const GroupPermissionRemoved("Permission removed successfully")),
      );
    } catch (e) {
      emit(GroupPermissionsError('Failed to remove permission: ${e.toString()}'));
    }
  }
}
