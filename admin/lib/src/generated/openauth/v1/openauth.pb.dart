///
//  Generated code. Do not modify.
//  source: openauth/v1/openauth.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/ping.pb.dart' as $1;
import 'stats.pb.dart' as $2;
import 'permissions.pb.dart' as $3;
import 'groups.pb.dart' as $4;
import 'permission_assignments.pb.dart' as $5;
import 'users.pb.dart' as $0;
import 'sessions.pb.dart' as $6;
import 'configs.pb.dart' as $7;

class OpenAuthApi {
  $pb.RpcClient _client;
  OpenAuthApi(this._client);

  $async.Future<$1.PingResponse> ping($pb.ClientContext? ctx, $1.PingRequest request) {
    var emptyResponse = $1.PingResponse();
    return _client.invoke<$1.PingResponse>(ctx, 'OpenAuth', 'Ping', request, emptyResponse);
  }
  $async.Future<$2.StatsResponse> stats($pb.ClientContext? ctx, $2.StatsRequest request) {
    var emptyResponse = $2.StatsResponse();
    return _client.invoke<$2.StatsResponse>(ctx, 'OpenAuth', 'Stats', request, emptyResponse);
  }
  $async.Future<$3.Permission> createPermission($pb.ClientContext? ctx, $3.CreatePermissionRequest request) {
    var emptyResponse = $3.Permission();
    return _client.invoke<$3.Permission>(ctx, 'OpenAuth', 'CreatePermission', request, emptyResponse);
  }
  $async.Future<$3.Permission> getPermission($pb.ClientContext? ctx, $3.GetPermissionRequest request) {
    var emptyResponse = $3.Permission();
    return _client.invoke<$3.Permission>(ctx, 'OpenAuth', 'GetPermission', request, emptyResponse);
  }
  $async.Future<$3.ListPermissionsResponse> listPermissions($pb.ClientContext? ctx, $3.ListPermissionsRequest request) {
    var emptyResponse = $3.ListPermissionsResponse();
    return _client.invoke<$3.ListPermissionsResponse>(ctx, 'OpenAuth', 'ListPermissions', request, emptyResponse);
  }
  $async.Future<$3.Permission> updatePermission($pb.ClientContext? ctx, $3.UpdatePermissionRequest request) {
    var emptyResponse = $3.Permission();
    return _client.invoke<$3.Permission>(ctx, 'OpenAuth', 'UpdatePermission', request, emptyResponse);
  }
  $async.Future<$3.DeletePermissionResponse> deletePermission($pb.ClientContext? ctx, $3.DeletePermissionRequest request) {
    var emptyResponse = $3.DeletePermissionResponse();
    return _client.invoke<$3.DeletePermissionResponse>(ctx, 'OpenAuth', 'DeletePermission', request, emptyResponse);
  }
  $async.Future<$4.CreateGroupResponse> createGroup($pb.ClientContext? ctx, $4.CreateGroupRequest request) {
    var emptyResponse = $4.CreateGroupResponse();
    return _client.invoke<$4.CreateGroupResponse>(ctx, 'OpenAuth', 'CreateGroup', request, emptyResponse);
  }
  $async.Future<$4.GetGroupResponse> getGroup($pb.ClientContext? ctx, $4.GetGroupRequest request) {
    var emptyResponse = $4.GetGroupResponse();
    return _client.invoke<$4.GetGroupResponse>(ctx, 'OpenAuth', 'GetGroup', request, emptyResponse);
  }
  $async.Future<$4.ListGroupsResponse> listGroups($pb.ClientContext? ctx, $4.ListGroupsRequest request) {
    var emptyResponse = $4.ListGroupsResponse();
    return _client.invoke<$4.ListGroupsResponse>(ctx, 'OpenAuth', 'ListGroups', request, emptyResponse);
  }
  $async.Future<$4.UpdateGroupResponse> updateGroup($pb.ClientContext? ctx, $4.UpdateGroupRequest request) {
    var emptyResponse = $4.UpdateGroupResponse();
    return _client.invoke<$4.UpdateGroupResponse>(ctx, 'OpenAuth', 'UpdateGroup', request, emptyResponse);
  }
  $async.Future<$4.DeleteGroupResponse> deleteGroup($pb.ClientContext? ctx, $4.DeleteGroupRequest request) {
    var emptyResponse = $4.DeleteGroupResponse();
    return _client.invoke<$4.DeleteGroupResponse>(ctx, 'OpenAuth', 'DeleteGroup', request, emptyResponse);
  }
  $async.Future<$4.AssignUsersToGroupResponse> assignUsersToGroup($pb.ClientContext? ctx, $4.AssignUsersToGroupRequest request) {
    var emptyResponse = $4.AssignUsersToGroupResponse();
    return _client.invoke<$4.AssignUsersToGroupResponse>(ctx, 'OpenAuth', 'AssignUsersToGroup', request, emptyResponse);
  }
  $async.Future<$4.RemoveUsersFromGroupResponse> removeUsersFromGroup($pb.ClientContext? ctx, $4.RemoveUsersFromGroupRequest request) {
    var emptyResponse = $4.RemoveUsersFromGroupResponse();
    return _client.invoke<$4.RemoveUsersFromGroupResponse>(ctx, 'OpenAuth', 'RemoveUsersFromGroup', request, emptyResponse);
  }
  $async.Future<$4.ListGroupUsersResponse> listGroupUsers($pb.ClientContext? ctx, $4.ListGroupUsersRequest request) {
    var emptyResponse = $4.ListGroupUsersResponse();
    return _client.invoke<$4.ListGroupUsersResponse>(ctx, 'OpenAuth', 'ListGroupUsers', request, emptyResponse);
  }
  $async.Future<$4.ListUserGroupsResponse> listUserGroups($pb.ClientContext? ctx, $4.ListUserGroupsRequest request) {
    var emptyResponse = $4.ListUserGroupsResponse();
    return _client.invoke<$4.ListUserGroupsResponse>(ctx, 'OpenAuth', 'ListUserGroups', request, emptyResponse);
  }
  $async.Future<$5.AssignPermissionsToGroupResponse> assignPermissionsToGroup($pb.ClientContext? ctx, $5.AssignPermissionsToGroupRequest request) {
    var emptyResponse = $5.AssignPermissionsToGroupResponse();
    return _client.invoke<$5.AssignPermissionsToGroupResponse>(ctx, 'OpenAuth', 'AssignPermissionsToGroup', request, emptyResponse);
  }
  $async.Future<$5.RemovePermissionsFromGroupResponse> removePermissionsFromGroup($pb.ClientContext? ctx, $5.RemovePermissionsFromGroupRequest request) {
    var emptyResponse = $5.RemovePermissionsFromGroupResponse();
    return _client.invoke<$5.RemovePermissionsFromGroupResponse>(ctx, 'OpenAuth', 'RemovePermissionsFromGroup', request, emptyResponse);
  }
  $async.Future<$5.ListGroupPermissionsResponse> listGroupPermissions($pb.ClientContext? ctx, $5.ListGroupPermissionsRequest request) {
    var emptyResponse = $5.ListGroupPermissionsResponse();
    return _client.invoke<$5.ListGroupPermissionsResponse>(ctx, 'OpenAuth', 'ListGroupPermissions', request, emptyResponse);
  }
  $async.Future<$5.AssignPermissionsToUserResponse> assignPermissionsToUser($pb.ClientContext? ctx, $5.AssignPermissionsToUserRequest request) {
    var emptyResponse = $5.AssignPermissionsToUserResponse();
    return _client.invoke<$5.AssignPermissionsToUserResponse>(ctx, 'OpenAuth', 'AssignPermissionsToUser', request, emptyResponse);
  }
  $async.Future<$5.RemovePermissionsFromUserResponse> removePermissionsFromUser($pb.ClientContext? ctx, $5.RemovePermissionsFromUserRequest request) {
    var emptyResponse = $5.RemovePermissionsFromUserResponse();
    return _client.invoke<$5.RemovePermissionsFromUserResponse>(ctx, 'OpenAuth', 'RemovePermissionsFromUser', request, emptyResponse);
  }
  $async.Future<$5.ListUserPermissionsResponse> listUserPermissions($pb.ClientContext? ctx, $5.ListUserPermissionsRequest request) {
    var emptyResponse = $5.ListUserPermissionsResponse();
    return _client.invoke<$5.ListUserPermissionsResponse>(ctx, 'OpenAuth', 'ListUserPermissions', request, emptyResponse);
  }
  $async.Future<$5.GetUserEffectivePermissionsResponse> getUserEffectivePermissions($pb.ClientContext? ctx, $5.GetUserEffectivePermissionsRequest request) {
    var emptyResponse = $5.GetUserEffectivePermissionsResponse();
    return _client.invoke<$5.GetUserEffectivePermissionsResponse>(ctx, 'OpenAuth', 'GetUserEffectivePermissions', request, emptyResponse);
  }
  $async.Future<$0.SignUpResponse> signUp($pb.ClientContext? ctx, $0.SignUpRequest request) {
    var emptyResponse = $0.SignUpResponse();
    return _client.invoke<$0.SignUpResponse>(ctx, 'OpenAuth', 'SignUp', request, emptyResponse);
  }
  $async.Future<$0.VerificationResponse> verifyEmail($pb.ClientContext? ctx, $0.VerifyEmailRequest request) {
    var emptyResponse = $0.VerificationResponse();
    return _client.invoke<$0.VerificationResponse>(ctx, 'OpenAuth', 'VerifyEmail', request, emptyResponse);
  }
  $async.Future<$0.VerificationResponse> verifyPhone($pb.ClientContext? ctx, $0.VerifyPhoneRequest request) {
    var emptyResponse = $0.VerificationResponse();
    return _client.invoke<$0.VerificationResponse>(ctx, 'OpenAuth', 'VerifyPhone', request, emptyResponse);
  }
  $async.Future<$0.SendVerificationCodeResponse> sendVerificationCode($pb.ClientContext? ctx, $0.SendVerificationCodeRequest request) {
    var emptyResponse = $0.SendVerificationCodeResponse();
    return _client.invoke<$0.SendVerificationCodeResponse>(ctx, 'OpenAuth', 'SendVerificationCode', request, emptyResponse);
  }
  $async.Future<$0.CheckUsernameResponse> checkUsername($pb.ClientContext? ctx, $0.CheckUsernameRequest request) {
    var emptyResponse = $0.CheckUsernameResponse();
    return _client.invoke<$0.CheckUsernameResponse>(ctx, 'OpenAuth', 'CheckUsername', request, emptyResponse);
  }
  $async.Future<$0.CheckEmailResponse> checkEmail($pb.ClientContext? ctx, $0.CheckEmailRequest request) {
    var emptyResponse = $0.CheckEmailResponse();
    return _client.invoke<$0.CheckEmailResponse>(ctx, 'OpenAuth', 'CheckEmail', request, emptyResponse);
  }
  $async.Future<$0.GetUserResponse> getUser($pb.ClientContext? ctx, $0.GetUserRequest request) {
    var emptyResponse = $0.GetUserResponse();
    return _client.invoke<$0.GetUserResponse>(ctx, 'OpenAuth', 'GetUser', request, emptyResponse);
  }
  $async.Future<$0.UpdateUserResponse> updateUser($pb.ClientContext? ctx, $0.UpdateUserRequest request) {
    var emptyResponse = $0.UpdateUserResponse();
    return _client.invoke<$0.UpdateUserResponse>(ctx, 'OpenAuth', 'UpdateUser', request, emptyResponse);
  }
  $async.Future<$0.ChangePasswordResponse> changePassword($pb.ClientContext? ctx, $0.ChangePasswordRequest request) {
    var emptyResponse = $0.ChangePasswordResponse();
    return _client.invoke<$0.ChangePasswordResponse>(ctx, 'OpenAuth', 'ChangePassword', request, emptyResponse);
  }
  $async.Future<$0.ListUsersResponse> listUsers($pb.ClientContext? ctx, $0.ListUsersRequest request) {
    var emptyResponse = $0.ListUsersResponse();
    return _client.invoke<$0.ListUsersResponse>(ctx, 'OpenAuth', 'ListUsers', request, emptyResponse);
  }
  $async.Future<$0.DeleteUserResponse> deleteUser($pb.ClientContext? ctx, $0.DeleteUserRequest request) {
    var emptyResponse = $0.DeleteUserResponse();
    return _client.invoke<$0.DeleteUserResponse>(ctx, 'OpenAuth', 'DeleteUser', request, emptyResponse);
  }
  $async.Future<$0.CreateProfileResponse> createProfile($pb.ClientContext? ctx, $0.CreateProfileRequest request) {
    var emptyResponse = $0.CreateProfileResponse();
    return _client.invoke<$0.CreateProfileResponse>(ctx, 'OpenAuth', 'CreateProfile', request, emptyResponse);
  }
  $async.Future<$0.ListUserProfilesResponse> listUserProfiles($pb.ClientContext? ctx, $0.ListUserProfilesRequest request) {
    var emptyResponse = $0.ListUserProfilesResponse();
    return _client.invoke<$0.ListUserProfilesResponse>(ctx, 'OpenAuth', 'ListUserProfiles', request, emptyResponse);
  }
  $async.Future<$0.UpdateProfileResponse> updateProfile($pb.ClientContext? ctx, $0.UpdateProfileRequest request) {
    var emptyResponse = $0.UpdateProfileResponse();
    return _client.invoke<$0.UpdateProfileResponse>(ctx, 'OpenAuth', 'UpdateProfile', request, emptyResponse);
  }
  $async.Future<$0.DeleteProfileResponse> deleteProfile($pb.ClientContext? ctx, $0.DeleteProfileRequest request) {
    var emptyResponse = $0.DeleteProfileResponse();
    return _client.invoke<$0.DeleteProfileResponse>(ctx, 'OpenAuth', 'DeleteProfile', request, emptyResponse);
  }
  $async.Future<$6.SignInResponse> signIn($pb.ClientContext? ctx, $6.SignInRequest request) {
    var emptyResponse = $6.SignInResponse();
    return _client.invoke<$6.SignInResponse>(ctx, 'OpenAuth', 'SignIn', request, emptyResponse);
  }
  $async.Future<$6.RefreshTokenResponse> refreshToken($pb.ClientContext? ctx, $6.RefreshTokenRequest request) {
    var emptyResponse = $6.RefreshTokenResponse();
    return _client.invoke<$6.RefreshTokenResponse>(ctx, 'OpenAuth', 'RefreshToken', request, emptyResponse);
  }
  $async.Future<$6.LogoutResponse> logout($pb.ClientContext? ctx, $6.LogoutRequest request) {
    var emptyResponse = $6.LogoutResponse();
    return _client.invoke<$6.LogoutResponse>(ctx, 'OpenAuth', 'Logout', request, emptyResponse);
  }
  $async.Future<$6.ValidateTokenResponse> validateToken($pb.ClientContext? ctx, $6.ValidateTokenRequest request) {
    var emptyResponse = $6.ValidateTokenResponse();
    return _client.invoke<$6.ValidateTokenResponse>(ctx, 'OpenAuth', 'ValidateToken', request, emptyResponse);
  }
  $async.Future<$6.ListUserSessionsResponse> listUserSessions($pb.ClientContext? ctx, $6.ListUserSessionsRequest request) {
    var emptyResponse = $6.ListUserSessionsResponse();
    return _client.invoke<$6.ListUserSessionsResponse>(ctx, 'OpenAuth', 'ListUserSessions', request, emptyResponse);
  }
  $async.Future<$6.TerminateSessionResponse> terminateSession($pb.ClientContext? ctx, $6.TerminateSessionRequest request) {
    var emptyResponse = $6.TerminateSessionResponse();
    return _client.invoke<$6.TerminateSessionResponse>(ctx, 'OpenAuth', 'TerminateSession', request, emptyResponse);
  }
  $async.Future<$7.ConfigEntity> createConfigEntity($pb.ClientContext? ctx, $7.CreateConfigEntityRequest request) {
    var emptyResponse = $7.ConfigEntity();
    return _client.invoke<$7.ConfigEntity>(ctx, 'OpenAuth', 'CreateConfigEntity', request, emptyResponse);
  }
  $async.Future<$7.UpdateResponse> updateConfigEntity($pb.ClientContext? ctx, $7.UpdateConfigEntityRequest request) {
    var emptyResponse = $7.UpdateResponse();
    return _client.invoke<$7.UpdateResponse>(ctx, 'OpenAuth', 'UpdateConfigEntity', request, emptyResponse);
  }
  $async.Future<$7.ConfigEntity> getConfigEntity($pb.ClientContext? ctx, $7.GetConfigEntityRequest request) {
    var emptyResponse = $7.ConfigEntity();
    return _client.invoke<$7.ConfigEntity>(ctx, 'OpenAuth', 'GetConfigEntity', request, emptyResponse);
  }
  $async.Future<$7.ListConfigEntitiesResponse> listConfigEntities($pb.ClientContext? ctx, $7.ListConfigEntitiesRequest request) {
    var emptyResponse = $7.ListConfigEntitiesResponse();
    return _client.invoke<$7.ListConfigEntitiesResponse>(ctx, 'OpenAuth', 'ListConfigEntities', request, emptyResponse);
  }
  $async.Future<$7.DeleteResponse> deleteConfigEntity($pb.ClientContext? ctx, $7.DeleteConfigEntityRequest request) {
    var emptyResponse = $7.DeleteResponse();
    return _client.invoke<$7.DeleteResponse>(ctx, 'OpenAuth', 'DeleteConfigEntity', request, emptyResponse);
  }
  $async.Future<$7.Config> createConfig($pb.ClientContext? ctx, $7.CreateConfigRequest request) {
    var emptyResponse = $7.Config();
    return _client.invoke<$7.Config>(ctx, 'OpenAuth', 'CreateConfig', request, emptyResponse);
  }
  $async.Future<$7.UpdateResponse> updateConfig($pb.ClientContext? ctx, $7.UpdateConfigRequest request) {
    var emptyResponse = $7.UpdateResponse();
    return _client.invoke<$7.UpdateResponse>(ctx, 'OpenAuth', 'UpdateConfig', request, emptyResponse);
  }
  $async.Future<$7.DeleteResponse> deleteConfig($pb.ClientContext? ctx, $7.DeleteConfigRequest request) {
    var emptyResponse = $7.DeleteResponse();
    return _client.invoke<$7.DeleteResponse>(ctx, 'OpenAuth', 'DeleteConfig', request, emptyResponse);
  }
  $async.Future<$7.Config> getConfig($pb.ClientContext? ctx, $7.GetConfigRequest request) {
    var emptyResponse = $7.Config();
    return _client.invoke<$7.Config>(ctx, 'OpenAuth', 'GetConfig', request, emptyResponse);
  }
  $async.Future<$7.GetConfigsByKeysResponse> getConfigsByKeys($pb.ClientContext? ctx, $7.GetConfigsByKeysRequest request) {
    var emptyResponse = $7.GetConfigsByKeysResponse();
    return _client.invoke<$7.GetConfigsByKeysResponse>(ctx, 'OpenAuth', 'GetConfigsByKeys', request, emptyResponse);
  }
  $async.Future<$7.ListConfigsResponse> listConfigs($pb.ClientContext? ctx, $7.ListConfigsRequest request) {
    var emptyResponse = $7.ListConfigsResponse();
    return _client.invoke<$7.ListConfigsResponse>(ctx, 'OpenAuth', 'ListConfigs', request, emptyResponse);
  }
}

