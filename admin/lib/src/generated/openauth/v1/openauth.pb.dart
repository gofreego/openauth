///
//  Generated code. Do not modify.
//  source: openauth/v1/openauth.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/ping.pb.dart' as $2;
import 'stats.pb.dart' as $3;
import 'permissions.pb.dart' as $4;
import 'groups.pb.dart' as $5;
import 'permission_assignments.pb.dart' as $6;
import 'users.pb.dart' as $1;
import 'sessions.pb.dart' as $7;

class OpenAuthApi {
  $pb.RpcClient _client;
  OpenAuthApi(this._client);

  $async.Future<$2.PingResponse> ping($pb.ClientContext? ctx, $2.PingRequest request) {
    var emptyResponse = $2.PingResponse();
    return _client.invoke<$2.PingResponse>(ctx, 'OpenAuth', 'Ping', request, emptyResponse);
  }
  $async.Future<$3.StatsResponse> stats($pb.ClientContext? ctx, $3.StatsRequest request) {
    var emptyResponse = $3.StatsResponse();
    return _client.invoke<$3.StatsResponse>(ctx, 'OpenAuth', 'Stats', request, emptyResponse);
  }
  $async.Future<$4.Permission> createPermission($pb.ClientContext? ctx, $4.CreatePermissionRequest request) {
    var emptyResponse = $4.Permission();
    return _client.invoke<$4.Permission>(ctx, 'OpenAuth', 'CreatePermission', request, emptyResponse);
  }
  $async.Future<$4.Permission> getPermission($pb.ClientContext? ctx, $4.GetPermissionRequest request) {
    var emptyResponse = $4.Permission();
    return _client.invoke<$4.Permission>(ctx, 'OpenAuth', 'GetPermission', request, emptyResponse);
  }
  $async.Future<$4.ListPermissionsResponse> listPermissions($pb.ClientContext? ctx, $4.ListPermissionsRequest request) {
    var emptyResponse = $4.ListPermissionsResponse();
    return _client.invoke<$4.ListPermissionsResponse>(ctx, 'OpenAuth', 'ListPermissions', request, emptyResponse);
  }
  $async.Future<$4.Permission> updatePermission($pb.ClientContext? ctx, $4.UpdatePermissionRequest request) {
    var emptyResponse = $4.Permission();
    return _client.invoke<$4.Permission>(ctx, 'OpenAuth', 'UpdatePermission', request, emptyResponse);
  }
  $async.Future<$4.DeletePermissionResponse> deletePermission($pb.ClientContext? ctx, $4.DeletePermissionRequest request) {
    var emptyResponse = $4.DeletePermissionResponse();
    return _client.invoke<$4.DeletePermissionResponse>(ctx, 'OpenAuth', 'DeletePermission', request, emptyResponse);
  }
  $async.Future<$5.CreateGroupResponse> createGroup($pb.ClientContext? ctx, $5.CreateGroupRequest request) {
    var emptyResponse = $5.CreateGroupResponse();
    return _client.invoke<$5.CreateGroupResponse>(ctx, 'OpenAuth', 'CreateGroup', request, emptyResponse);
  }
  $async.Future<$5.GetGroupResponse> getGroup($pb.ClientContext? ctx, $5.GetGroupRequest request) {
    var emptyResponse = $5.GetGroupResponse();
    return _client.invoke<$5.GetGroupResponse>(ctx, 'OpenAuth', 'GetGroup', request, emptyResponse);
  }
  $async.Future<$5.ListGroupsResponse> listGroups($pb.ClientContext? ctx, $5.ListGroupsRequest request) {
    var emptyResponse = $5.ListGroupsResponse();
    return _client.invoke<$5.ListGroupsResponse>(ctx, 'OpenAuth', 'ListGroups', request, emptyResponse);
  }
  $async.Future<$5.UpdateGroupResponse> updateGroup($pb.ClientContext? ctx, $5.UpdateGroupRequest request) {
    var emptyResponse = $5.UpdateGroupResponse();
    return _client.invoke<$5.UpdateGroupResponse>(ctx, 'OpenAuth', 'UpdateGroup', request, emptyResponse);
  }
  $async.Future<$5.DeleteGroupResponse> deleteGroup($pb.ClientContext? ctx, $5.DeleteGroupRequest request) {
    var emptyResponse = $5.DeleteGroupResponse();
    return _client.invoke<$5.DeleteGroupResponse>(ctx, 'OpenAuth', 'DeleteGroup', request, emptyResponse);
  }
  $async.Future<$5.AssignUserToGroupResponse> assignUserToGroup($pb.ClientContext? ctx, $5.AssignUserToGroupRequest request) {
    var emptyResponse = $5.AssignUserToGroupResponse();
    return _client.invoke<$5.AssignUserToGroupResponse>(ctx, 'OpenAuth', 'AssignUserToGroup', request, emptyResponse);
  }
  $async.Future<$5.RemoveUserFromGroupResponse> removeUserFromGroup($pb.ClientContext? ctx, $5.RemoveUserFromGroupRequest request) {
    var emptyResponse = $5.RemoveUserFromGroupResponse();
    return _client.invoke<$5.RemoveUserFromGroupResponse>(ctx, 'OpenAuth', 'RemoveUserFromGroup', request, emptyResponse);
  }
  $async.Future<$5.ListGroupUsersResponse> listGroupUsers($pb.ClientContext? ctx, $5.ListGroupUsersRequest request) {
    var emptyResponse = $5.ListGroupUsersResponse();
    return _client.invoke<$5.ListGroupUsersResponse>(ctx, 'OpenAuth', 'ListGroupUsers', request, emptyResponse);
  }
  $async.Future<$5.ListUserGroupsResponse> listUserGroups($pb.ClientContext? ctx, $5.ListUserGroupsRequest request) {
    var emptyResponse = $5.ListUserGroupsResponse();
    return _client.invoke<$5.ListUserGroupsResponse>(ctx, 'OpenAuth', 'ListUserGroups', request, emptyResponse);
  }
  $async.Future<$6.AssignPermissionToGroupResponse> assignPermissionToGroup($pb.ClientContext? ctx, $6.AssignPermissionToGroupRequest request) {
    var emptyResponse = $6.AssignPermissionToGroupResponse();
    return _client.invoke<$6.AssignPermissionToGroupResponse>(ctx, 'OpenAuth', 'AssignPermissionToGroup', request, emptyResponse);
  }
  $async.Future<$6.RemovePermissionFromGroupResponse> removePermissionFromGroup($pb.ClientContext? ctx, $6.RemovePermissionFromGroupRequest request) {
    var emptyResponse = $6.RemovePermissionFromGroupResponse();
    return _client.invoke<$6.RemovePermissionFromGroupResponse>(ctx, 'OpenAuth', 'RemovePermissionFromGroup', request, emptyResponse);
  }
  $async.Future<$6.ListGroupPermissionsResponse> listGroupPermissions($pb.ClientContext? ctx, $6.ListGroupPermissionsRequest request) {
    var emptyResponse = $6.ListGroupPermissionsResponse();
    return _client.invoke<$6.ListGroupPermissionsResponse>(ctx, 'OpenAuth', 'ListGroupPermissions', request, emptyResponse);
  }
  $async.Future<$6.AssignPermissionToUserResponse> assignPermissionToUser($pb.ClientContext? ctx, $6.AssignPermissionToUserRequest request) {
    var emptyResponse = $6.AssignPermissionToUserResponse();
    return _client.invoke<$6.AssignPermissionToUserResponse>(ctx, 'OpenAuth', 'AssignPermissionToUser', request, emptyResponse);
  }
  $async.Future<$6.RemovePermissionFromUserResponse> removePermissionFromUser($pb.ClientContext? ctx, $6.RemovePermissionFromUserRequest request) {
    var emptyResponse = $6.RemovePermissionFromUserResponse();
    return _client.invoke<$6.RemovePermissionFromUserResponse>(ctx, 'OpenAuth', 'RemovePermissionFromUser', request, emptyResponse);
  }
  $async.Future<$6.ListUserPermissionsResponse> listUserPermissions($pb.ClientContext? ctx, $6.ListUserPermissionsRequest request) {
    var emptyResponse = $6.ListUserPermissionsResponse();
    return _client.invoke<$6.ListUserPermissionsResponse>(ctx, 'OpenAuth', 'ListUserPermissions', request, emptyResponse);
  }
  $async.Future<$6.GetUserEffectivePermissionsResponse> getUserEffectivePermissions($pb.ClientContext? ctx, $6.GetUserEffectivePermissionsRequest request) {
    var emptyResponse = $6.GetUserEffectivePermissionsResponse();
    return _client.invoke<$6.GetUserEffectivePermissionsResponse>(ctx, 'OpenAuth', 'GetUserEffectivePermissions', request, emptyResponse);
  }
  $async.Future<$1.SignUpResponse> signUp($pb.ClientContext? ctx, $1.SignUpRequest request) {
    var emptyResponse = $1.SignUpResponse();
    return _client.invoke<$1.SignUpResponse>(ctx, 'OpenAuth', 'SignUp', request, emptyResponse);
  }
  $async.Future<$1.VerificationResponse> verifyEmail($pb.ClientContext? ctx, $1.VerifyEmailRequest request) {
    var emptyResponse = $1.VerificationResponse();
    return _client.invoke<$1.VerificationResponse>(ctx, 'OpenAuth', 'VerifyEmail', request, emptyResponse);
  }
  $async.Future<$1.VerificationResponse> verifyPhone($pb.ClientContext? ctx, $1.VerifyPhoneRequest request) {
    var emptyResponse = $1.VerificationResponse();
    return _client.invoke<$1.VerificationResponse>(ctx, 'OpenAuth', 'VerifyPhone', request, emptyResponse);
  }
  $async.Future<$1.SendVerificationCodeResponse> resendVerification($pb.ClientContext? ctx, $1.SendVerificationCodeRequest request) {
    var emptyResponse = $1.SendVerificationCodeResponse();
    return _client.invoke<$1.SendVerificationCodeResponse>(ctx, 'OpenAuth', 'ResendVerification', request, emptyResponse);
  }
  $async.Future<$1.CheckUsernameResponse> checkUsername($pb.ClientContext? ctx, $1.CheckUsernameRequest request) {
    var emptyResponse = $1.CheckUsernameResponse();
    return _client.invoke<$1.CheckUsernameResponse>(ctx, 'OpenAuth', 'CheckUsername', request, emptyResponse);
  }
  $async.Future<$1.CheckEmailResponse> checkEmail($pb.ClientContext? ctx, $1.CheckEmailRequest request) {
    var emptyResponse = $1.CheckEmailResponse();
    return _client.invoke<$1.CheckEmailResponse>(ctx, 'OpenAuth', 'CheckEmail', request, emptyResponse);
  }
  $async.Future<$1.GetUserResponse> getUser($pb.ClientContext? ctx, $1.GetUserRequest request) {
    var emptyResponse = $1.GetUserResponse();
    return _client.invoke<$1.GetUserResponse>(ctx, 'OpenAuth', 'GetUser', request, emptyResponse);
  }
  $async.Future<$1.UpdateUserResponse> updateUser($pb.ClientContext? ctx, $1.UpdateUserRequest request) {
    var emptyResponse = $1.UpdateUserResponse();
    return _client.invoke<$1.UpdateUserResponse>(ctx, 'OpenAuth', 'UpdateUser', request, emptyResponse);
  }
  $async.Future<$1.ChangePasswordResponse> changePassword($pb.ClientContext? ctx, $1.ChangePasswordRequest request) {
    var emptyResponse = $1.ChangePasswordResponse();
    return _client.invoke<$1.ChangePasswordResponse>(ctx, 'OpenAuth', 'ChangePassword', request, emptyResponse);
  }
  $async.Future<$1.ListUsersResponse> listUsers($pb.ClientContext? ctx, $1.ListUsersRequest request) {
    var emptyResponse = $1.ListUsersResponse();
    return _client.invoke<$1.ListUsersResponse>(ctx, 'OpenAuth', 'ListUsers', request, emptyResponse);
  }
  $async.Future<$1.DeleteUserResponse> deleteUser($pb.ClientContext? ctx, $1.DeleteUserRequest request) {
    var emptyResponse = $1.DeleteUserResponse();
    return _client.invoke<$1.DeleteUserResponse>(ctx, 'OpenAuth', 'DeleteUser', request, emptyResponse);
  }
  $async.Future<$1.CreateProfileResponse> createProfile($pb.ClientContext? ctx, $1.CreateProfileRequest request) {
    var emptyResponse = $1.CreateProfileResponse();
    return _client.invoke<$1.CreateProfileResponse>(ctx, 'OpenAuth', 'CreateProfile', request, emptyResponse);
  }
  $async.Future<$1.ListUserProfilesResponse> listUserProfiles($pb.ClientContext? ctx, $1.ListUserProfilesRequest request) {
    var emptyResponse = $1.ListUserProfilesResponse();
    return _client.invoke<$1.ListUserProfilesResponse>(ctx, 'OpenAuth', 'ListUserProfiles', request, emptyResponse);
  }
  $async.Future<$1.UpdateProfileResponse> updateProfile($pb.ClientContext? ctx, $1.UpdateProfileRequest request) {
    var emptyResponse = $1.UpdateProfileResponse();
    return _client.invoke<$1.UpdateProfileResponse>(ctx, 'OpenAuth', 'UpdateProfile', request, emptyResponse);
  }
  $async.Future<$1.DeleteProfileResponse> deleteProfile($pb.ClientContext? ctx, $1.DeleteProfileRequest request) {
    var emptyResponse = $1.DeleteProfileResponse();
    return _client.invoke<$1.DeleteProfileResponse>(ctx, 'OpenAuth', 'DeleteProfile', request, emptyResponse);
  }
  $async.Future<$7.SignInResponse> signIn($pb.ClientContext? ctx, $7.SignInRequest request) {
    var emptyResponse = $7.SignInResponse();
    return _client.invoke<$7.SignInResponse>(ctx, 'OpenAuth', 'SignIn', request, emptyResponse);
  }
  $async.Future<$7.RefreshTokenResponse> refreshToken($pb.ClientContext? ctx, $7.RefreshTokenRequest request) {
    var emptyResponse = $7.RefreshTokenResponse();
    return _client.invoke<$7.RefreshTokenResponse>(ctx, 'OpenAuth', 'RefreshToken', request, emptyResponse);
  }
  $async.Future<$7.LogoutResponse> logout($pb.ClientContext? ctx, $7.LogoutRequest request) {
    var emptyResponse = $7.LogoutResponse();
    return _client.invoke<$7.LogoutResponse>(ctx, 'OpenAuth', 'Logout', request, emptyResponse);
  }
  $async.Future<$7.ValidateTokenResponse> validateToken($pb.ClientContext? ctx, $7.ValidateTokenRequest request) {
    var emptyResponse = $7.ValidateTokenResponse();
    return _client.invoke<$7.ValidateTokenResponse>(ctx, 'OpenAuth', 'ValidateToken', request, emptyResponse);
  }
  $async.Future<$7.ListUserSessionsResponse> listUserSessions($pb.ClientContext? ctx, $7.ListUserSessionsRequest request) {
    var emptyResponse = $7.ListUserSessionsResponse();
    return _client.invoke<$7.ListUserSessionsResponse>(ctx, 'OpenAuth', 'ListUserSessions', request, emptyResponse);
  }
  $async.Future<$7.TerminateSessionResponse> terminateSession($pb.ClientContext? ctx, $7.TerminateSessionRequest request) {
    var emptyResponse = $7.TerminateSessionResponse();
    return _client.invoke<$7.TerminateSessionResponse>(ctx, 'OpenAuth', 'TerminateSession', request, emptyResponse);
  }
}

