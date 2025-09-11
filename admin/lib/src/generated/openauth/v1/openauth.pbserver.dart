///
//  Generated code. Do not modify.
//  source: openauth/v1/openauth.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import '../../common/ping.pb.dart' as $2;
import 'stats.pb.dart' as $3;
import 'permissions.pb.dart' as $4;
import 'groups.pb.dart' as $5;
import 'permission_assignments.pb.dart' as $6;
import 'users.pb.dart' as $1;
import 'sessions.pb.dart' as $7;
import 'configs.pb.dart' as $8;
import 'openauth.pbjson.dart';

export 'openauth.pb.dart';

abstract class OpenAuthServiceBase extends $pb.GeneratedService {
  $async.Future<$2.PingResponse> ping($pb.ServerContext ctx, $2.PingRequest request);
  $async.Future<$3.StatsResponse> stats($pb.ServerContext ctx, $3.StatsRequest request);
  $async.Future<$4.Permission> createPermission($pb.ServerContext ctx, $4.CreatePermissionRequest request);
  $async.Future<$4.Permission> getPermission($pb.ServerContext ctx, $4.GetPermissionRequest request);
  $async.Future<$4.ListPermissionsResponse> listPermissions($pb.ServerContext ctx, $4.ListPermissionsRequest request);
  $async.Future<$4.Permission> updatePermission($pb.ServerContext ctx, $4.UpdatePermissionRequest request);
  $async.Future<$4.DeletePermissionResponse> deletePermission($pb.ServerContext ctx, $4.DeletePermissionRequest request);
  $async.Future<$5.CreateGroupResponse> createGroup($pb.ServerContext ctx, $5.CreateGroupRequest request);
  $async.Future<$5.GetGroupResponse> getGroup($pb.ServerContext ctx, $5.GetGroupRequest request);
  $async.Future<$5.ListGroupsResponse> listGroups($pb.ServerContext ctx, $5.ListGroupsRequest request);
  $async.Future<$5.UpdateGroupResponse> updateGroup($pb.ServerContext ctx, $5.UpdateGroupRequest request);
  $async.Future<$5.DeleteGroupResponse> deleteGroup($pb.ServerContext ctx, $5.DeleteGroupRequest request);
  $async.Future<$5.AssignUsersToGroupResponse> assignUsersToGroup($pb.ServerContext ctx, $5.AssignUsersToGroupRequest request);
  $async.Future<$5.RemoveUsersFromGroupResponse> removeUsersFromGroup($pb.ServerContext ctx, $5.RemoveUsersFromGroupRequest request);
  $async.Future<$5.ListGroupUsersResponse> listGroupUsers($pb.ServerContext ctx, $5.ListGroupUsersRequest request);
  $async.Future<$5.ListUserGroupsResponse> listUserGroups($pb.ServerContext ctx, $5.ListUserGroupsRequest request);
  $async.Future<$6.AssignPermissionsToGroupResponse> assignPermissionsToGroup($pb.ServerContext ctx, $6.AssignPermissionsToGroupRequest request);
  $async.Future<$6.RemovePermissionsFromGroupResponse> removePermissionsFromGroup($pb.ServerContext ctx, $6.RemovePermissionsFromGroupRequest request);
  $async.Future<$6.ListGroupPermissionsResponse> listGroupPermissions($pb.ServerContext ctx, $6.ListGroupPermissionsRequest request);
  $async.Future<$6.AssignPermissionsToUserResponse> assignPermissionsToUser($pb.ServerContext ctx, $6.AssignPermissionsToUserRequest request);
  $async.Future<$6.RemovePermissionsFromUserResponse> removePermissionsFromUser($pb.ServerContext ctx, $6.RemovePermissionsFromUserRequest request);
  $async.Future<$6.ListUserPermissionsResponse> listUserPermissions($pb.ServerContext ctx, $6.ListUserPermissionsRequest request);
  $async.Future<$6.GetUserEffectivePermissionsResponse> getUserEffectivePermissions($pb.ServerContext ctx, $6.GetUserEffectivePermissionsRequest request);
  $async.Future<$1.SignUpResponse> signUp($pb.ServerContext ctx, $1.SignUpRequest request);
  $async.Future<$1.VerificationResponse> verifyEmail($pb.ServerContext ctx, $1.VerifyEmailRequest request);
  $async.Future<$1.VerificationResponse> verifyPhone($pb.ServerContext ctx, $1.VerifyPhoneRequest request);
  $async.Future<$1.SendVerificationCodeResponse> sendVerificationCode($pb.ServerContext ctx, $1.SendVerificationCodeRequest request);
  $async.Future<$1.CheckUsernameResponse> checkUsername($pb.ServerContext ctx, $1.CheckUsernameRequest request);
  $async.Future<$1.CheckEmailResponse> checkEmail($pb.ServerContext ctx, $1.CheckEmailRequest request);
  $async.Future<$1.GetUserResponse> getUser($pb.ServerContext ctx, $1.GetUserRequest request);
  $async.Future<$1.UpdateUserResponse> updateUser($pb.ServerContext ctx, $1.UpdateUserRequest request);
  $async.Future<$1.ChangePasswordResponse> changePassword($pb.ServerContext ctx, $1.ChangePasswordRequest request);
  $async.Future<$1.ListUsersResponse> listUsers($pb.ServerContext ctx, $1.ListUsersRequest request);
  $async.Future<$1.DeleteUserResponse> deleteUser($pb.ServerContext ctx, $1.DeleteUserRequest request);
  $async.Future<$1.CreateProfileResponse> createProfile($pb.ServerContext ctx, $1.CreateProfileRequest request);
  $async.Future<$1.ListUserProfilesResponse> listUserProfiles($pb.ServerContext ctx, $1.ListUserProfilesRequest request);
  $async.Future<$1.UpdateProfileResponse> updateProfile($pb.ServerContext ctx, $1.UpdateProfileRequest request);
  $async.Future<$1.DeleteProfileResponse> deleteProfile($pb.ServerContext ctx, $1.DeleteProfileRequest request);
  $async.Future<$7.SignInResponse> signIn($pb.ServerContext ctx, $7.SignInRequest request);
  $async.Future<$7.RefreshTokenResponse> refreshToken($pb.ServerContext ctx, $7.RefreshTokenRequest request);
  $async.Future<$7.LogoutResponse> logout($pb.ServerContext ctx, $7.LogoutRequest request);
  $async.Future<$7.ValidateTokenResponse> validateToken($pb.ServerContext ctx, $7.ValidateTokenRequest request);
  $async.Future<$7.ListUserSessionsResponse> listUserSessions($pb.ServerContext ctx, $7.ListUserSessionsRequest request);
  $async.Future<$7.TerminateSessionResponse> terminateSession($pb.ServerContext ctx, $7.TerminateSessionRequest request);
  $async.Future<$8.ConfigEntity> createConfigEntity($pb.ServerContext ctx, $8.CreateConfigEntityRequest request);
  $async.Future<$8.ConfigEntity> updateConfigEntity($pb.ServerContext ctx, $8.UpdateConfigEntityRequest request);
  $async.Future<$8.ConfigEntity> getConfigEntity($pb.ServerContext ctx, $8.GetConfigEntityRequest request);
  $async.Future<$8.ListConfigEntitiesResponse> listConfigEntities($pb.ServerContext ctx, $8.ListConfigEntitiesRequest request);
  $async.Future<$8.DeleteResponse> deleteConfigEntity($pb.ServerContext ctx, $8.DeleteConfigEntityRequest request);
  $async.Future<$8.Config> createConfig($pb.ServerContext ctx, $8.CreateConfigRequest request);
  $async.Future<$8.Config> getConfig($pb.ServerContext ctx, $8.GetConfigRequest request);
  $async.Future<$8.Config> getConfigByKey($pb.ServerContext ctx, $8.GetConfigByKeyRequest request);
  $async.Future<$8.GetConfigsByKeysResponse> getConfigsByKeys($pb.ServerContext ctx, $8.GetConfigsByKeysRequest request);
  $async.Future<$8.ListConfigsResponse> listConfigs($pb.ServerContext ctx, $8.ListConfigsRequest request);
  $async.Future<$8.Config> updateConfig($pb.ServerContext ctx, $8.UpdateConfigRequest request);
  $async.Future<$8.DeleteResponse> deleteConfig($pb.ServerContext ctx, $8.DeleteConfigRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'Ping': return $2.PingRequest();
      case 'Stats': return $3.StatsRequest();
      case 'CreatePermission': return $4.CreatePermissionRequest();
      case 'GetPermission': return $4.GetPermissionRequest();
      case 'ListPermissions': return $4.ListPermissionsRequest();
      case 'UpdatePermission': return $4.UpdatePermissionRequest();
      case 'DeletePermission': return $4.DeletePermissionRequest();
      case 'CreateGroup': return $5.CreateGroupRequest();
      case 'GetGroup': return $5.GetGroupRequest();
      case 'ListGroups': return $5.ListGroupsRequest();
      case 'UpdateGroup': return $5.UpdateGroupRequest();
      case 'DeleteGroup': return $5.DeleteGroupRequest();
      case 'AssignUsersToGroup': return $5.AssignUsersToGroupRequest();
      case 'RemoveUsersFromGroup': return $5.RemoveUsersFromGroupRequest();
      case 'ListGroupUsers': return $5.ListGroupUsersRequest();
      case 'ListUserGroups': return $5.ListUserGroupsRequest();
      case 'AssignPermissionsToGroup': return $6.AssignPermissionsToGroupRequest();
      case 'RemovePermissionsFromGroup': return $6.RemovePermissionsFromGroupRequest();
      case 'ListGroupPermissions': return $6.ListGroupPermissionsRequest();
      case 'AssignPermissionsToUser': return $6.AssignPermissionsToUserRequest();
      case 'RemovePermissionsFromUser': return $6.RemovePermissionsFromUserRequest();
      case 'ListUserPermissions': return $6.ListUserPermissionsRequest();
      case 'GetUserEffectivePermissions': return $6.GetUserEffectivePermissionsRequest();
      case 'SignUp': return $1.SignUpRequest();
      case 'VerifyEmail': return $1.VerifyEmailRequest();
      case 'VerifyPhone': return $1.VerifyPhoneRequest();
      case 'SendVerificationCode': return $1.SendVerificationCodeRequest();
      case 'CheckUsername': return $1.CheckUsernameRequest();
      case 'CheckEmail': return $1.CheckEmailRequest();
      case 'GetUser': return $1.GetUserRequest();
      case 'UpdateUser': return $1.UpdateUserRequest();
      case 'ChangePassword': return $1.ChangePasswordRequest();
      case 'ListUsers': return $1.ListUsersRequest();
      case 'DeleteUser': return $1.DeleteUserRequest();
      case 'CreateProfile': return $1.CreateProfileRequest();
      case 'ListUserProfiles': return $1.ListUserProfilesRequest();
      case 'UpdateProfile': return $1.UpdateProfileRequest();
      case 'DeleteProfile': return $1.DeleteProfileRequest();
      case 'SignIn': return $7.SignInRequest();
      case 'RefreshToken': return $7.RefreshTokenRequest();
      case 'Logout': return $7.LogoutRequest();
      case 'ValidateToken': return $7.ValidateTokenRequest();
      case 'ListUserSessions': return $7.ListUserSessionsRequest();
      case 'TerminateSession': return $7.TerminateSessionRequest();
      case 'CreateConfigEntity': return $8.CreateConfigEntityRequest();
      case 'UpdateConfigEntity': return $8.UpdateConfigEntityRequest();
      case 'GetConfigEntity': return $8.GetConfigEntityRequest();
      case 'ListConfigEntities': return $8.ListConfigEntitiesRequest();
      case 'DeleteConfigEntity': return $8.DeleteConfigEntityRequest();
      case 'CreateConfig': return $8.CreateConfigRequest();
      case 'GetConfig': return $8.GetConfigRequest();
      case 'GetConfigByKey': return $8.GetConfigByKeyRequest();
      case 'GetConfigsByKeys': return $8.GetConfigsByKeysRequest();
      case 'ListConfigs': return $8.ListConfigsRequest();
      case 'UpdateConfig': return $8.UpdateConfigRequest();
      case 'DeleteConfig': return $8.DeleteConfigRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'Ping': return this.ping(ctx, request as $2.PingRequest);
      case 'Stats': return this.stats(ctx, request as $3.StatsRequest);
      case 'CreatePermission': return this.createPermission(ctx, request as $4.CreatePermissionRequest);
      case 'GetPermission': return this.getPermission(ctx, request as $4.GetPermissionRequest);
      case 'ListPermissions': return this.listPermissions(ctx, request as $4.ListPermissionsRequest);
      case 'UpdatePermission': return this.updatePermission(ctx, request as $4.UpdatePermissionRequest);
      case 'DeletePermission': return this.deletePermission(ctx, request as $4.DeletePermissionRequest);
      case 'CreateGroup': return this.createGroup(ctx, request as $5.CreateGroupRequest);
      case 'GetGroup': return this.getGroup(ctx, request as $5.GetGroupRequest);
      case 'ListGroups': return this.listGroups(ctx, request as $5.ListGroupsRequest);
      case 'UpdateGroup': return this.updateGroup(ctx, request as $5.UpdateGroupRequest);
      case 'DeleteGroup': return this.deleteGroup(ctx, request as $5.DeleteGroupRequest);
      case 'AssignUsersToGroup': return this.assignUsersToGroup(ctx, request as $5.AssignUsersToGroupRequest);
      case 'RemoveUsersFromGroup': return this.removeUsersFromGroup(ctx, request as $5.RemoveUsersFromGroupRequest);
      case 'ListGroupUsers': return this.listGroupUsers(ctx, request as $5.ListGroupUsersRequest);
      case 'ListUserGroups': return this.listUserGroups(ctx, request as $5.ListUserGroupsRequest);
      case 'AssignPermissionsToGroup': return this.assignPermissionsToGroup(ctx, request as $6.AssignPermissionsToGroupRequest);
      case 'RemovePermissionsFromGroup': return this.removePermissionsFromGroup(ctx, request as $6.RemovePermissionsFromGroupRequest);
      case 'ListGroupPermissions': return this.listGroupPermissions(ctx, request as $6.ListGroupPermissionsRequest);
      case 'AssignPermissionsToUser': return this.assignPermissionsToUser(ctx, request as $6.AssignPermissionsToUserRequest);
      case 'RemovePermissionsFromUser': return this.removePermissionsFromUser(ctx, request as $6.RemovePermissionsFromUserRequest);
      case 'ListUserPermissions': return this.listUserPermissions(ctx, request as $6.ListUserPermissionsRequest);
      case 'GetUserEffectivePermissions': return this.getUserEffectivePermissions(ctx, request as $6.GetUserEffectivePermissionsRequest);
      case 'SignUp': return this.signUp(ctx, request as $1.SignUpRequest);
      case 'VerifyEmail': return this.verifyEmail(ctx, request as $1.VerifyEmailRequest);
      case 'VerifyPhone': return this.verifyPhone(ctx, request as $1.VerifyPhoneRequest);
      case 'SendVerificationCode': return this.sendVerificationCode(ctx, request as $1.SendVerificationCodeRequest);
      case 'CheckUsername': return this.checkUsername(ctx, request as $1.CheckUsernameRequest);
      case 'CheckEmail': return this.checkEmail(ctx, request as $1.CheckEmailRequest);
      case 'GetUser': return this.getUser(ctx, request as $1.GetUserRequest);
      case 'UpdateUser': return this.updateUser(ctx, request as $1.UpdateUserRequest);
      case 'ChangePassword': return this.changePassword(ctx, request as $1.ChangePasswordRequest);
      case 'ListUsers': return this.listUsers(ctx, request as $1.ListUsersRequest);
      case 'DeleteUser': return this.deleteUser(ctx, request as $1.DeleteUserRequest);
      case 'CreateProfile': return this.createProfile(ctx, request as $1.CreateProfileRequest);
      case 'ListUserProfiles': return this.listUserProfiles(ctx, request as $1.ListUserProfilesRequest);
      case 'UpdateProfile': return this.updateProfile(ctx, request as $1.UpdateProfileRequest);
      case 'DeleteProfile': return this.deleteProfile(ctx, request as $1.DeleteProfileRequest);
      case 'SignIn': return this.signIn(ctx, request as $7.SignInRequest);
      case 'RefreshToken': return this.refreshToken(ctx, request as $7.RefreshTokenRequest);
      case 'Logout': return this.logout(ctx, request as $7.LogoutRequest);
      case 'ValidateToken': return this.validateToken(ctx, request as $7.ValidateTokenRequest);
      case 'ListUserSessions': return this.listUserSessions(ctx, request as $7.ListUserSessionsRequest);
      case 'TerminateSession': return this.terminateSession(ctx, request as $7.TerminateSessionRequest);
      case 'CreateConfigEntity': return this.createConfigEntity(ctx, request as $8.CreateConfigEntityRequest);
      case 'UpdateConfigEntity': return this.updateConfigEntity(ctx, request as $8.UpdateConfigEntityRequest);
      case 'GetConfigEntity': return this.getConfigEntity(ctx, request as $8.GetConfigEntityRequest);
      case 'ListConfigEntities': return this.listConfigEntities(ctx, request as $8.ListConfigEntitiesRequest);
      case 'DeleteConfigEntity': return this.deleteConfigEntity(ctx, request as $8.DeleteConfigEntityRequest);
      case 'CreateConfig': return this.createConfig(ctx, request as $8.CreateConfigRequest);
      case 'GetConfig': return this.getConfig(ctx, request as $8.GetConfigRequest);
      case 'GetConfigByKey': return this.getConfigByKey(ctx, request as $8.GetConfigByKeyRequest);
      case 'GetConfigsByKeys': return this.getConfigsByKeys(ctx, request as $8.GetConfigsByKeysRequest);
      case 'ListConfigs': return this.listConfigs(ctx, request as $8.ListConfigsRequest);
      case 'UpdateConfig': return this.updateConfig(ctx, request as $8.UpdateConfigRequest);
      case 'DeleteConfig': return this.deleteConfig(ctx, request as $8.DeleteConfigRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => OpenAuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => OpenAuthServiceBase$messageJson;
}

