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
import 'permissions.pb.dart' as $3;
import 'groups.pb.dart' as $4;
import 'permission_assignments.pb.dart' as $5;
import 'users.pb.dart' as $1;
import 'sessions.pb.dart' as $6;
import 'openauth.pbjson.dart';

export 'openauth.pb.dart';

abstract class OpenAuthServiceBase extends $pb.GeneratedService {
  $async.Future<$2.PingResponse> ping($pb.ServerContext ctx, $2.PingRequest request);
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
  $async.Future<$4.AssignUserToGroupResponse> assignUserToGroup($pb.ServerContext ctx, $4.AssignUserToGroupRequest request);
  $async.Future<$4.RemoveUserFromGroupResponse> removeUserFromGroup($pb.ServerContext ctx, $4.RemoveUserFromGroupRequest request);
  $async.Future<$4.ListGroupUsersResponse> listGroupUsers($pb.ServerContext ctx, $4.ListGroupUsersRequest request);
  $async.Future<$4.ListUserGroupsResponse> listUserGroups($pb.ServerContext ctx, $4.ListUserGroupsRequest request);
  $async.Future<$5.AssignPermissionToGroupResponse> assignPermissionToGroup($pb.ServerContext ctx, $5.AssignPermissionToGroupRequest request);
  $async.Future<$5.RemovePermissionFromGroupResponse> removePermissionFromGroup($pb.ServerContext ctx, $5.RemovePermissionFromGroupRequest request);
  $async.Future<$5.ListGroupPermissionsResponse> listGroupPermissions($pb.ServerContext ctx, $5.ListGroupPermissionsRequest request);
  $async.Future<$5.AssignPermissionToUserResponse> assignPermissionToUser($pb.ServerContext ctx, $5.AssignPermissionToUserRequest request);
  $async.Future<$5.RemovePermissionFromUserResponse> removePermissionFromUser($pb.ServerContext ctx, $5.RemovePermissionFromUserRequest request);
  $async.Future<$5.ListUserPermissionsResponse> listUserPermissions($pb.ServerContext ctx, $5.ListUserPermissionsRequest request);
  $async.Future<$5.GetUserEffectivePermissionsResponse> getUserEffectivePermissions($pb.ServerContext ctx, $5.GetUserEffectivePermissionsRequest request);
  $async.Future<$1.SignUpResponse> signUp($pb.ServerContext ctx, $1.SignUpRequest request);
  $async.Future<$1.VerificationResponse> verifyEmail($pb.ServerContext ctx, $1.VerifyEmailRequest request);
  $async.Future<$1.VerificationResponse> verifyPhone($pb.ServerContext ctx, $1.VerifyPhoneRequest request);
  $async.Future<$1.SendVerificationCodeResponse> resendVerification($pb.ServerContext ctx, $1.SendVerificationCodeRequest request);
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
  $async.Future<$6.SignInResponse> signIn($pb.ServerContext ctx, $6.SignInRequest request);
  $async.Future<$6.RefreshTokenResponse> refreshToken($pb.ServerContext ctx, $6.RefreshTokenRequest request);
  $async.Future<$6.LogoutResponse> logout($pb.ServerContext ctx, $6.LogoutRequest request);
  $async.Future<$6.ValidateTokenResponse> validateToken($pb.ServerContext ctx, $6.ValidateTokenRequest request);
  $async.Future<$6.ListUserSessionsResponse> listUserSessions($pb.ServerContext ctx, $6.ListUserSessionsRequest request);
  $async.Future<$6.TerminateSessionResponse> terminateSession($pb.ServerContext ctx, $6.TerminateSessionRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'Ping': return $2.PingRequest();
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
      case 'AssignUserToGroup': return $4.AssignUserToGroupRequest();
      case 'RemoveUserFromGroup': return $4.RemoveUserFromGroupRequest();
      case 'ListGroupUsers': return $4.ListGroupUsersRequest();
      case 'ListUserGroups': return $4.ListUserGroupsRequest();
      case 'AssignPermissionToGroup': return $5.AssignPermissionToGroupRequest();
      case 'RemovePermissionFromGroup': return $5.RemovePermissionFromGroupRequest();
      case 'ListGroupPermissions': return $5.ListGroupPermissionsRequest();
      case 'AssignPermissionToUser': return $5.AssignPermissionToUserRequest();
      case 'RemovePermissionFromUser': return $5.RemovePermissionFromUserRequest();
      case 'ListUserPermissions': return $5.ListUserPermissionsRequest();
      case 'GetUserEffectivePermissions': return $5.GetUserEffectivePermissionsRequest();
      case 'SignUp': return $1.SignUpRequest();
      case 'VerifyEmail': return $1.VerifyEmailRequest();
      case 'VerifyPhone': return $1.VerifyPhoneRequest();
      case 'ResendVerification': return $1.SendVerificationCodeRequest();
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
      case 'SignIn': return $6.SignInRequest();
      case 'RefreshToken': return $6.RefreshTokenRequest();
      case 'Logout': return $6.LogoutRequest();
      case 'ValidateToken': return $6.ValidateTokenRequest();
      case 'ListUserSessions': return $6.ListUserSessionsRequest();
      case 'TerminateSession': return $6.TerminateSessionRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'Ping': return this.ping(ctx, request as $2.PingRequest);
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
      case 'AssignUserToGroup': return this.assignUserToGroup(ctx, request as $4.AssignUserToGroupRequest);
      case 'RemoveUserFromGroup': return this.removeUserFromGroup(ctx, request as $4.RemoveUserFromGroupRequest);
      case 'ListGroupUsers': return this.listGroupUsers(ctx, request as $4.ListGroupUsersRequest);
      case 'ListUserGroups': return this.listUserGroups(ctx, request as $4.ListUserGroupsRequest);
      case 'AssignPermissionToGroup': return this.assignPermissionToGroup(ctx, request as $5.AssignPermissionToGroupRequest);
      case 'RemovePermissionFromGroup': return this.removePermissionFromGroup(ctx, request as $5.RemovePermissionFromGroupRequest);
      case 'ListGroupPermissions': return this.listGroupPermissions(ctx, request as $5.ListGroupPermissionsRequest);
      case 'AssignPermissionToUser': return this.assignPermissionToUser(ctx, request as $5.AssignPermissionToUserRequest);
      case 'RemovePermissionFromUser': return this.removePermissionFromUser(ctx, request as $5.RemovePermissionFromUserRequest);
      case 'ListUserPermissions': return this.listUserPermissions(ctx, request as $5.ListUserPermissionsRequest);
      case 'GetUserEffectivePermissions': return this.getUserEffectivePermissions(ctx, request as $5.GetUserEffectivePermissionsRequest);
      case 'SignUp': return this.signUp(ctx, request as $1.SignUpRequest);
      case 'VerifyEmail': return this.verifyEmail(ctx, request as $1.VerifyEmailRequest);
      case 'VerifyPhone': return this.verifyPhone(ctx, request as $1.VerifyPhoneRequest);
      case 'ResendVerification': return this.resendVerification(ctx, request as $1.SendVerificationCodeRequest);
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
      case 'SignIn': return this.signIn(ctx, request as $6.SignInRequest);
      case 'RefreshToken': return this.refreshToken(ctx, request as $6.RefreshTokenRequest);
      case 'Logout': return this.logout(ctx, request as $6.LogoutRequest);
      case 'ValidateToken': return this.validateToken(ctx, request as $6.ValidateTokenRequest);
      case 'ListUserSessions': return this.listUserSessions(ctx, request as $6.ListUserSessionsRequest);
      case 'TerminateSession': return this.terminateSession(ctx, request as $6.TerminateSessionRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => OpenAuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => OpenAuthServiceBase$messageJson;
}

