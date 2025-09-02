import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/permission_assignments.pb.dart' as pb;
import '../../../../core/network/api_service.dart';
import 'user_permissions_event.dart';
import 'user_permissions_state.dart';

class UserPermissionsBloc extends Bloc<UserPermissionsEvent, UserPermissionsState> {
  final ApiService _apiService;

  UserPermissionsBloc({
    required ApiService apiService,
  }) : _apiService = apiService,
       super(UserPermissionsInitial()) {
    on<LoadUserPermissions>(_onLoadUserPermissions);
    on<AssignPermissionToUser>(_onAssignPermissionToUser);
    on<RemovePermissionFromUser>(_onRemovePermissionFromUser);
    on<RefreshUserPermissions>(_onRefreshUserPermissions);
  }

  Future<void> _onLoadUserPermissions(
    LoadUserPermissions event,
    Emitter<UserPermissionsState> emit,
  ) async {
    emit(UserPermissionsLoading());

    try {
      final response = await _apiService.get(
        '/openauth/v1/users/${event.userId}/effective-permissions',
        queryParameters: {
          'limit': 50,
          'offset': 0,
        },
      );

      final listResponse = pb.ListUserPermissionsResponse()
        ..mergeFromProto3Json(response.data);
      
      emit(UserPermissionsLoaded(listResponse.permissions));
    } catch (e) {
      emit(UserPermissionsError(_getErrorMessage(e)));
    }
  }

  Future<void> _onAssignPermissionToUser(
    AssignPermissionToUser event,
    Emitter<UserPermissionsState> emit,
  ) async {
    emit(UserPermissionAssigning());

    try {
      final request = pb.AssignPermissionToUserRequest(
        userId: Int64(event.userId),
        permissionId: Int64(event.permissionId),
      );

      await _apiService.post(
        '/openauth/v1/users/${event.userId}/permissions',
        data: request.toProto3Json(),
      );
      emit(const UserPermissionAssigned());
      
      // Refresh the permissions list
      if (!isClosed) {
        add(RefreshUserPermissions(event.userId));
      }
    } catch (e) {
      emit(UserPermissionsError(_getErrorMessage(e)));
    }
  }

  Future<void> _onRemovePermissionFromUser(
    RemovePermissionFromUser event,
    Emitter<UserPermissionsState> emit,
  ) async {
    emit(UserPermissionRemoving());

    try {
      final response = await _apiService.delete(
        '/openauth/v1/users/${event.userId}/permissions/${event.permissionId}',
      );

      final removeResponse = pb.RemovePermissionFromUserResponse()
        ..mergeFromProto3Json(response.data);
      
      emit(UserPermissionRemoved(removeResponse.message));
      
      // Refresh the permissions list
      if (!isClosed) {
        add(RefreshUserPermissions(event.userId));
      }
    } catch (e) {
      emit(UserPermissionsError(_getErrorMessage(e)));
    }
  }

  Future<void> _onRefreshUserPermissions(
    RefreshUserPermissions event,
    Emitter<UserPermissionsState> emit,
  ) async {
    // Don't show loading state for refresh
    try {
      final response = await _apiService.get(
        '/openauth/v1/users/${event.userId}/permissions',
        queryParameters: {
          'limit': 50,
          'offset': 0,
        },
      );

      final listResponse = pb.ListUserPermissionsResponse()
        ..mergeFromProto3Json(response.data);
      
      emit(UserPermissionsLoaded(listResponse.permissions));
    } catch (e) {
      emit(UserPermissionsError(_getErrorMessage(e)));
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('DioException')) {
      return 'Network error occurred. Please try again.';
    }
    return error.toString();
  }
}
