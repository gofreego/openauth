///
//  Generated code. Do not modify.
//  source: openauth/v1/openauth.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import '../../common/ping.pb.dart' as $1;
import 'stats.pb.dart' as $2;
import 'permissions.pb.dart' as $3;
import 'groups.pb.dart' as $4;
import 'permission_assignments.pb.dart' as $5;
import 'users.pb.dart' as $0;
import 'sessions.pb.dart' as $6;
import 'configs.pb.dart' as $7;
import 'openauth.pbjson.dart';

export 'openauth.pb.dart';

abstract class OpenAuthServiceBase extends $pb.GeneratedService {
  $async.Future<$1.PingResponse> ping($pb.ServerContext ctx, $1.PingRequest request);
  $async.Future<$2.StatsResponse> stats($pb.ServerContext ctx, $2.StatsRequest request);
  $async.Future<$3.Permission> createPermission($pb.ServerContext ctx, $3.CreatePermissionRequest request);
  $async.Future<$3.Permission> getPermission($pb.ServerContext ctx, $3.GetPermissionRequest request);
  $async.Future<$3.ListPermissionsResponse> listPermissions($pb.ServerContext ctx, $3.ListPermissionsRequest request);
  $async.Future<$3.Permission> updatePermission($pb.ServerContext ctx, $3.UpdatePermissionRequest request);
  $async.Future<$3.DeletePermissionResponse> deletePermission($pb.ServerContext ctx, $3.DeletePermissionRequest request);
  $async.Future<$4.CreateGroupResponse> createGroup($pb.ServerContext ctx, $4.CreateGroupRequest request);
  $async.Future<$4.GetGroupResponse> getGroup($pb.ServerContext ctx, $4.GetGroupRequest request);
  $async.Future<$4.ListGroupsResponse> listGroups($pb.ServerContext ctx, $4.ListGroupsRequest request);
  $async.Future<$4.UpdateGroupResponse> updateGroup($pb.ServerContext ctx, $4.UpdateGroupRequest request);
  $async.Future<$4.DeleteGroupResponse> deleteGroup($pb.ServerContext ctx, $4.DeleteGroupRequest request);
  $async.Future<$4.AssignUsersToGroupResponse> assignUsersToGroup($pb.ServerContext ctx, $4.AssignUsersToGroupRequest request);
  $async.Future<$4.RemoveUsersFromGroupResponse> removeUsersFromGroup($pb.ServerContext ctx, $4.RemoveUsersFromGroupRequest request);
  $async.Future<$4.ListGroupUsersResponse> listGroupUsers($pb.ServerContext ctx, $4.ListGroupUsersRequest request);
  $async.Future<$4.ListUserGroupsResponse> listUserGroups($pb.ServerContext ctx, $4.ListUserGroupsRequest request);
  $async.Future<$5.AssignPermissionsToGroupResponse> assignPermissionsToGroup($pb.ServerContext ctx, $5.AssignPermissionsToGroupRequest request);
  $async.Future<$5.RemovePermissionsFromGroupResponse> removePermissionsFromGroup($pb.ServerContext ctx, $5.RemovePermissionsFromGroupRequest request);
  $async.Future<$5.ListGroupPermissionsResponse> listGroupPermissions($pb.ServerContext ctx, $5.ListGroupPermissionsRequest request);
  $async.Future<$5.AssignPermissionsToUserResponse> assignPermissionsToUser($pb.ServerContext ctx, $5.AssignPermissionsToUserRequest request);
  $async.Future<$5.RemovePermissionsFromUserResponse> removePermissionsFromUser($pb.ServerContext ctx, $5.RemovePermissionsFromUserRequest request);
  $async.Future<$5.ListUserPermissionsResponse> listUserPermissions($pb.ServerContext ctx, $5.ListUserPermissionsRequest request);
  $async.Future<$5.GetUserEffectivePermissionsResponse> getUserEffectivePermissions($pb.ServerContext ctx, $5.GetUserEffectivePermissionsRequest request);
  $async.Future<$0.SignUpResponse> signUp($pb.ServerContext ctx, $0.SignUpRequest request);
  $async.Future<$0.VerificationResponse> verifyEmail($pb.ServerContext ctx, $0.VerifyEmailRequest request);
  $async.Future<$0.VerificationResponse> verifyPhone($pb.ServerContext ctx, $0.VerifyPhoneRequest request);
  $async.Future<$0.SendVerificationCodeResponse> sendVerificationCode($pb.ServerContext ctx, $0.SendVerificationCodeRequest request);
  $async.Future<$0.CheckUsernameResponse> checkUsername($pb.ServerContext ctx, $0.CheckUsernameRequest request);
  $async.Future<$0.CheckEmailResponse> checkEmail($pb.ServerContext ctx, $0.CheckEmailRequest request);
  $async.Future<$0.GetUserResponse> getUser($pb.ServerContext ctx, $0.GetUserRequest request);
  $async.Future<$0.UpdateUserResponse> updateUser($pb.ServerContext ctx, $0.UpdateUserRequest request);
  $async.Future<$0.ChangePasswordResponse> changePassword($pb.ServerContext ctx, $0.ChangePasswordRequest request);
  $async.Future<$0.ListUsersResponse> listUsers($pb.ServerContext ctx, $0.ListUsersRequest request);
  $async.Future<$0.DeleteUserResponse> deleteUser($pb.ServerContext ctx, $0.DeleteUserRequest request);
  $async.Future<$0.CreateProfileResponse> createProfile($pb.ServerContext ctx, $0.CreateProfileRequest request);
  $async.Future<$0.ListUserProfilesResponse> listUserProfiles($pb.ServerContext ctx, $0.ListUserProfilesRequest request);
  $async.Future<$0.UpdateProfileResponse> updateProfile($pb.ServerContext ctx, $0.UpdateProfileRequest request);
  $async.Future<$0.DeleteProfileResponse> deleteProfile($pb.ServerContext ctx, $0.DeleteProfileRequest request);
  $async.Future<$6.SignInResponse> signIn($pb.ServerContext ctx, $6.SignInRequest request);
  $async.Future<$6.RefreshTokenResponse> refreshToken($pb.ServerContext ctx, $6.RefreshTokenRequest request);
  $async.Future<$6.LogoutResponse> logout($pb.ServerContext ctx, $6.LogoutRequest request);
  $async.Future<$6.ValidateTokenResponse> validateToken($pb.ServerContext ctx, $6.ValidateTokenRequest request);
  $async.Future<$6.ListUserSessionsResponse> listUserSessions($pb.ServerContext ctx, $6.ListUserSessionsRequest request);
  $async.Future<$6.TerminateSessionResponse> terminateSession($pb.ServerContext ctx, $6.TerminateSessionRequest request);
  $async.Future<$7.ConfigEntity> createConfigEntity($pb.ServerContext ctx, $7.CreateConfigEntityRequest request);
  $async.Future<$7.UpdateResponse> updateConfigEntity($pb.ServerContext ctx, $7.UpdateConfigEntityRequest request);
  $async.Future<$7.ConfigEntity> getConfigEntity($pb.ServerContext ctx, $7.GetConfigEntityRequest request);
  $async.Future<$7.ListConfigEntitiesResponse> listConfigEntities($pb.ServerContext ctx, $7.ListConfigEntitiesRequest request);
  $async.Future<$7.DeleteResponse> deleteConfigEntity($pb.ServerContext ctx, $7.DeleteConfigEntityRequest request);
  $async.Future<$7.Config> createConfig($pb.ServerContext ctx, $7.CreateConfigRequest request);
  $async.Future<$7.UpdateResponse> updateConfig($pb.ServerContext ctx, $7.UpdateConfigRequest request);
  $async.Future<$7.DeleteResponse> deleteConfig($pb.ServerContext ctx, $7.DeleteConfigRequest request);
  $async.Future<$7.Config> getConfig($pb.ServerContext ctx, $7.GetConfigRequest request);
  $async.Future<$7.Config> getConfigByKey($pb.ServerContext ctx, $7.GetConfigByKeyRequest request);
  $async.Future<$7.GetConfigsByKeysResponse> getConfigsByKeys($pb.ServerContext ctx, $7.GetConfigsByKeysRequest request);
  $async.Future<$7.ListConfigsResponse> listConfigs($pb.ServerContext ctx, $7.ListConfigsRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'Ping': return $1.PingRequest();
      case 'Stats': return $2.StatsRequest();
      case 'CreatePermission': return $3.CreatePermissionRequest();
      case 'GetPermission': return $3.GetPermissionRequest();
      case 'ListPermissions': return $3.ListPermissionsRequest();
      case 'UpdatePermission': return $3.UpdatePermissionRequest();
      case 'DeletePermission': return $3.DeletePermissionRequest();
      case 'CreateGroup': return $4.CreateGroupRequest();
      case 'GetGroup': return $4.GetGroupRequest();
      case 'ListGroups': return $4.ListGroupsRequest();
      case 'UpdateGroup': return $4.UpdateGroupRequest();
      case 'DeleteGroup': return $4.DeleteGroupRequest();
      case 'AssignUsersToGroup': return $4.AssignUsersToGroupRequest();
      case 'RemoveUsersFromGroup': return $4.RemoveUsersFromGroupRequest();
      case 'ListGroupUsers': return $4.ListGroupUsersRequest();
      case 'ListUserGroups': return $4.ListUserGroupsRequest();
      case 'AssignPermissionsToGroup': return $5.AssignPermissionsToGroupRequest();
      case 'RemovePermissionsFromGroup': return $5.RemovePermissionsFromGroupRequest();
      case 'ListGroupPermissions': return $5.ListGroupPermissionsRequest();
      case 'AssignPermissionsToUser': return $5.AssignPermissionsToUserRequest();
      case 'RemovePermissionsFromUser': return $5.RemovePermissionsFromUserRequest();
      case 'ListUserPermissions': return $5.ListUserPermissionsRequest();
      case 'GetUserEffectivePermissions': return $5.GetUserEffectivePermissionsRequest();
      case 'SignUp': return $0.SignUpRequest();
      case 'VerifyEmail': return $0.VerifyEmailRequest();
      case 'VerifyPhone': return $0.VerifyPhoneRequest();
      case 'SendVerificationCode': return $0.SendVerificationCodeRequest();
      case 'CheckUsername': return $0.CheckUsernameRequest();
      case 'CheckEmail': return $0.CheckEmailRequest();
      case 'GetUser': return $0.GetUserRequest();
      case 'UpdateUser': return $0.UpdateUserRequest();
      case 'ChangePassword': return $0.ChangePasswordRequest();
      case 'ListUsers': return $0.ListUsersRequest();
      case 'DeleteUser': return $0.DeleteUserRequest();
      case 'CreateProfile': return $0.CreateProfileRequest();
      case 'ListUserProfiles': return $0.ListUserProfilesRequest();
      case 'UpdateProfile': return $0.UpdateProfileRequest();
      case 'DeleteProfile': return $0.DeleteProfileRequest();
      case 'SignIn': return $6.SignInRequest();
      case 'RefreshToken': return $6.RefreshTokenRequest();
      case 'Logout': return $6.LogoutRequest();
      case 'ValidateToken': return $6.ValidateTokenRequest();
      case 'ListUserSessions': return $6.ListUserSessionsRequest();
      case 'TerminateSession': return $6.TerminateSessionRequest();
      case 'CreateConfigEntity': return $7.CreateConfigEntityRequest();
      case 'UpdateConfigEntity': return $7.UpdateConfigEntityRequest();
      case 'GetConfigEntity': return $7.GetConfigEntityRequest();
      case 'ListConfigEntities': return $7.ListConfigEntitiesRequest();
      case 'DeleteConfigEntity': return $7.DeleteConfigEntityRequest();
      case 'CreateConfig': return $7.CreateConfigRequest();
      case 'UpdateConfig': return $7.UpdateConfigRequest();
      case 'DeleteConfig': return $7.DeleteConfigRequest();
      case 'GetConfig': return $7.GetConfigRequest();
      case 'GetConfigByKey': return $7.GetConfigByKeyRequest();
      case 'GetConfigsByKeys': return $7.GetConfigsByKeysRequest();
      case 'ListConfigs': return $7.ListConfigsRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'Ping': return this.ping(ctx, request as $1.PingRequest);
      case 'Stats': return this.stats(ctx, request as $2.StatsRequest);
      case 'CreatePermission': return this.createPermission(ctx, request as $3.CreatePermissionRequest);
      case 'GetPermission': return this.getPermission(ctx, request as $3.GetPermissionRequest);
      case 'ListPermissions': return this.listPermissions(ctx, request as $3.ListPermissionsRequest);
      case 'UpdatePermission': return this.updatePermission(ctx, request as $3.UpdatePermissionRequest);
      case 'DeletePermission': return this.deletePermission(ctx, request as $3.DeletePermissionRequest);
      case 'CreateGroup': return this.createGroup(ctx, request as $4.CreateGroupRequest);
      case 'GetGroup': return this.getGroup(ctx, request as $4.GetGroupRequest);
      case 'ListGroups': return this.listGroups(ctx, request as $4.ListGroupsRequest);
      case 'UpdateGroup': return this.updateGroup(ctx, request as $4.UpdateGroupRequest);
      case 'DeleteGroup': return this.deleteGroup(ctx, request as $4.DeleteGroupRequest);
      case 'AssignUsersToGroup': return this.assignUsersToGroup(ctx, request as $4.AssignUsersToGroupRequest);
      case 'RemoveUsersFromGroup': return this.removeUsersFromGroup(ctx, request as $4.RemoveUsersFromGroupRequest);
      case 'ListGroupUsers': return this.listGroupUsers(ctx, request as $4.ListGroupUsersRequest);
      case 'ListUserGroups': return this.listUserGroups(ctx, request as $4.ListUserGroupsRequest);
      case 'AssignPermissionsToGroup': return this.assignPermissionsToGroup(ctx, request as $5.AssignPermissionsToGroupRequest);
      case 'RemovePermissionsFromGroup': return this.removePermissionsFromGroup(ctx, request as $5.RemovePermissionsFromGroupRequest);
      case 'ListGroupPermissions': return this.listGroupPermissions(ctx, request as $5.ListGroupPermissionsRequest);
      case 'AssignPermissionsToUser': return this.assignPermissionsToUser(ctx, request as $5.AssignPermissionsToUserRequest);
      case 'RemovePermissionsFromUser': return this.removePermissionsFromUser(ctx, request as $5.RemovePermissionsFromUserRequest);
      case 'ListUserPermissions': return this.listUserPermissions(ctx, request as $5.ListUserPermissionsRequest);
      case 'GetUserEffectivePermissions': return this.getUserEffectivePermissions(ctx, request as $5.GetUserEffectivePermissionsRequest);
      case 'SignUp': return this.signUp(ctx, request as $0.SignUpRequest);
      case 'VerifyEmail': return this.verifyEmail(ctx, request as $0.VerifyEmailRequest);
      case 'VerifyPhone': return this.verifyPhone(ctx, request as $0.VerifyPhoneRequest);
      case 'SendVerificationCode': return this.sendVerificationCode(ctx, request as $0.SendVerificationCodeRequest);
      case 'CheckUsername': return this.checkUsername(ctx, request as $0.CheckUsernameRequest);
      case 'CheckEmail': return this.checkEmail(ctx, request as $0.CheckEmailRequest);
      case 'GetUser': return this.getUser(ctx, request as $0.GetUserRequest);
      case 'UpdateUser': return this.updateUser(ctx, request as $0.UpdateUserRequest);
      case 'ChangePassword': return this.changePassword(ctx, request as $0.ChangePasswordRequest);
      case 'ListUsers': return this.listUsers(ctx, request as $0.ListUsersRequest);
      case 'DeleteUser': return this.deleteUser(ctx, request as $0.DeleteUserRequest);
      case 'CreateProfile': return this.createProfile(ctx, request as $0.CreateProfileRequest);
      case 'ListUserProfiles': return this.listUserProfiles(ctx, request as $0.ListUserProfilesRequest);
      case 'UpdateProfile': return this.updateProfile(ctx, request as $0.UpdateProfileRequest);
      case 'DeleteProfile': return this.deleteProfile(ctx, request as $0.DeleteProfileRequest);
      case 'SignIn': return this.signIn(ctx, request as $6.SignInRequest);
      case 'RefreshToken': return this.refreshToken(ctx, request as $6.RefreshTokenRequest);
      case 'Logout': return this.logout(ctx, request as $6.LogoutRequest);
      case 'ValidateToken': return this.validateToken(ctx, request as $6.ValidateTokenRequest);
      case 'ListUserSessions': return this.listUserSessions(ctx, request as $6.ListUserSessionsRequest);
      case 'TerminateSession': return this.terminateSession(ctx, request as $6.TerminateSessionRequest);
      case 'CreateConfigEntity': return this.createConfigEntity(ctx, request as $7.CreateConfigEntityRequest);
      case 'UpdateConfigEntity': return this.updateConfigEntity(ctx, request as $7.UpdateConfigEntityRequest);
      case 'GetConfigEntity': return this.getConfigEntity(ctx, request as $7.GetConfigEntityRequest);
      case 'ListConfigEntities': return this.listConfigEntities(ctx, request as $7.ListConfigEntitiesRequest);
      case 'DeleteConfigEntity': return this.deleteConfigEntity(ctx, request as $7.DeleteConfigEntityRequest);
      case 'CreateConfig': return this.createConfig(ctx, request as $7.CreateConfigRequest);
      case 'UpdateConfig': return this.updateConfig(ctx, request as $7.UpdateConfigRequest);
      case 'DeleteConfig': return this.deleteConfig(ctx, request as $7.DeleteConfigRequest);
      case 'GetConfig': return this.getConfig(ctx, request as $7.GetConfigRequest);
      case 'GetConfigByKey': return this.getConfigByKey(ctx, request as $7.GetConfigByKeyRequest);
      case 'GetConfigsByKeys': return this.getConfigsByKeys(ctx, request as $7.GetConfigsByKeysRequest);
      case 'ListConfigs': return this.listConfigs(ctx, request as $7.ListConfigsRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => OpenAuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => OpenAuthServiceBase$messageJson;
}

