import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/permissions/permissions.dart';
import 'package:openauth/src/generated/openauth/v1/permission_assignments.pb.dart';
import 'package:protobuf/protobuf.dart';
import 'user_permissions_state.dart';

class UserPermissionsBloc extends Bloc<GeneratedMessage, UserPermissionsState> {
  final PermissionsRepository repository;

  UserPermissionsBloc({
    required this.repository,
  }) : super(UserPermissionsInitial()) {
    on<ListUserPermissionsRequest>(_onLoadUserPermissions);
    on<AssignPermissionsToUserRequest>(_onAssignPermissionToUser);
    on<RemovePermissionsFromUserRequest>(_onRemovePermissionFromUser);
  }
  Future<void> _onLoadUserPermissions(
      ListUserPermissionsRequest event, Emitter<UserPermissionsState> emit) async {
    try {
      emit(UserPermissionsLoading());

      final result = await repository.getUserPermissions(event);

      result.fold(
        (failure) => emit(UserPermissionsError(failure.message)),
        (response) => emit(UserPermissionsLoaded(response.permissions)),
      );
    } catch (e) {
      emit(UserPermissionsError('Failed to load user permissions: ${e.toString()}'));
    }
  }

  Future<void> _onAssignPermissionToUser(
      AssignPermissionsToUserRequest event, Emitter<UserPermissionsState> emit) async {
    try {
      emit(UserPermissionAssigning());

      final result = await repository.assignPermissionsToUser(event);

      result.fold(
        (failure) => emit(UserPermissionsError(failure.message)),
        (response) => emit(const UserPermissionAssigned()),
      );
    } catch (e) {
      emit(UserPermissionsError('Failed to assign permission: ${e.toString()}'));
    }
  }

  Future<void> _onRemovePermissionFromUser(
      RemovePermissionsFromUserRequest event, Emitter<UserPermissionsState> emit) async {
    try {
      emit(UserPermissionRemoving());

      final result = await repository.removePermissionsFromUser(event);

      result.fold(
        (failure) => emit(UserPermissionsError(failure.message)),
        (response) => emit(const UserPermissionRemoved("Permission removed successfully")),
      );
    } catch (e) {
      emit(UserPermissionsError('Failed to remove permission: ${e.toString()}'));
    }
  }
}
