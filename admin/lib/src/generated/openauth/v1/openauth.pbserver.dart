///
//  Generated code. Do not modify.
//  source: openauth/v1/openauth.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import '../../common/ping.pb.dart' as $0;
import 'permissions.pb.dart' as $1;
import 'users.pb.dart' as $2;
import 'openauth.pbjson.dart';

export 'openauth.pb.dart';

abstract class OpenAuthServiceBase extends $pb.GeneratedService {
  $async.Future<$0.PingResponse> ping($pb.ServerContext ctx, $0.PingRequest request);
  $async.Future<$1.Permission> createPermission($pb.ServerContext ctx, $1.CreatePermissionRequest request);
  $async.Future<$1.Permission> getPermission($pb.ServerContext ctx, $1.GetPermissionRequest request);
  $async.Future<$1.ListPermissionsResponse> listPermissions($pb.ServerContext ctx, $1.ListPermissionsRequest request);
  $async.Future<$1.Permission> updatePermission($pb.ServerContext ctx, $1.UpdatePermissionRequest request);
  $async.Future<$1.DeletePermissionResponse> deletePermission($pb.ServerContext ctx, $1.DeletePermissionRequest request);
  $async.Future<$2.SignUpResponse> signUp($pb.ServerContext ctx, $2.SignUpRequest request);
  $async.Future<$2.VerificationResponse> verifyEmail($pb.ServerContext ctx, $2.VerifyEmailRequest request);
  $async.Future<$2.VerificationResponse> verifyPhone($pb.ServerContext ctx, $2.VerifyPhoneRequest request);
  $async.Future<$2.ResendVerificationResponse> resendVerification($pb.ServerContext ctx, $2.ResendVerificationRequest request);
  $async.Future<$2.CheckUsernameResponse> checkUsername($pb.ServerContext ctx, $2.CheckUsernameRequest request);
  $async.Future<$2.CheckEmailResponse> checkEmail($pb.ServerContext ctx, $2.CheckEmailRequest request);
  $async.Future<$2.GetUserResponse> getUser($pb.ServerContext ctx, $2.GetUserRequest request);
  $async.Future<$2.UpdateUserResponse> updateUser($pb.ServerContext ctx, $2.UpdateUserRequest request);
  $async.Future<$2.ChangePasswordResponse> changePassword($pb.ServerContext ctx, $2.ChangePasswordRequest request);
  $async.Future<$2.ListUsersResponse> listUsers($pb.ServerContext ctx, $2.ListUsersRequest request);
  $async.Future<$2.DeleteUserResponse> deleteUser($pb.ServerContext ctx, $2.DeleteUserRequest request);
  $async.Future<$2.CreateProfileResponse> createProfile($pb.ServerContext ctx, $2.CreateProfileRequest request);
  $async.Future<$2.ListUserProfilesResponse> listUserProfiles($pb.ServerContext ctx, $2.ListUserProfilesRequest request);
  $async.Future<$2.UpdateProfileResponse> updateProfile($pb.ServerContext ctx, $2.UpdateProfileRequest request);
  $async.Future<$2.DeleteProfileResponse> deleteProfile($pb.ServerContext ctx, $2.DeleteProfileRequest request);
  $async.Future<$2.SignInResponse> signIn($pb.ServerContext ctx, $2.SignInRequest request);
  $async.Future<$2.RefreshTokenResponse> refreshToken($pb.ServerContext ctx, $2.RefreshTokenRequest request);
  $async.Future<$2.LogoutResponse> logout($pb.ServerContext ctx, $2.LogoutRequest request);
  $async.Future<$2.ValidateTokenResponse> validateToken($pb.ServerContext ctx, $2.ValidateTokenRequest request);
  $async.Future<$2.ListUserSessionsResponse> listUserSessions($pb.ServerContext ctx, $2.ListUserSessionsRequest request);
  $async.Future<$2.TerminateSessionResponse> terminateSession($pb.ServerContext ctx, $2.TerminateSessionRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'Ping': return $0.PingRequest();
      case 'CreatePermission': return $1.CreatePermissionRequest();
      case 'GetPermission': return $1.GetPermissionRequest();
      case 'ListPermissions': return $1.ListPermissionsRequest();
      case 'UpdatePermission': return $1.UpdatePermissionRequest();
      case 'DeletePermission': return $1.DeletePermissionRequest();
      case 'SignUp': return $2.SignUpRequest();
      case 'VerifyEmail': return $2.VerifyEmailRequest();
      case 'VerifyPhone': return $2.VerifyPhoneRequest();
      case 'ResendVerification': return $2.ResendVerificationRequest();
      case 'CheckUsername': return $2.CheckUsernameRequest();
      case 'CheckEmail': return $2.CheckEmailRequest();
      case 'GetUser': return $2.GetUserRequest();
      case 'UpdateUser': return $2.UpdateUserRequest();
      case 'ChangePassword': return $2.ChangePasswordRequest();
      case 'ListUsers': return $2.ListUsersRequest();
      case 'DeleteUser': return $2.DeleteUserRequest();
      case 'CreateProfile': return $2.CreateProfileRequest();
      case 'ListUserProfiles': return $2.ListUserProfilesRequest();
      case 'UpdateProfile': return $2.UpdateProfileRequest();
      case 'DeleteProfile': return $2.DeleteProfileRequest();
      case 'SignIn': return $2.SignInRequest();
      case 'RefreshToken': return $2.RefreshTokenRequest();
      case 'Logout': return $2.LogoutRequest();
      case 'ValidateToken': return $2.ValidateTokenRequest();
      case 'ListUserSessions': return $2.ListUserSessionsRequest();
      case 'TerminateSession': return $2.TerminateSessionRequest();
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'Ping': return this.ping(ctx, request as $0.PingRequest);
      case 'CreatePermission': return this.createPermission(ctx, request as $1.CreatePermissionRequest);
      case 'GetPermission': return this.getPermission(ctx, request as $1.GetPermissionRequest);
      case 'ListPermissions': return this.listPermissions(ctx, request as $1.ListPermissionsRequest);
      case 'UpdatePermission': return this.updatePermission(ctx, request as $1.UpdatePermissionRequest);
      case 'DeletePermission': return this.deletePermission(ctx, request as $1.DeletePermissionRequest);
      case 'SignUp': return this.signUp(ctx, request as $2.SignUpRequest);
      case 'VerifyEmail': return this.verifyEmail(ctx, request as $2.VerifyEmailRequest);
      case 'VerifyPhone': return this.verifyPhone(ctx, request as $2.VerifyPhoneRequest);
      case 'ResendVerification': return this.resendVerification(ctx, request as $2.ResendVerificationRequest);
      case 'CheckUsername': return this.checkUsername(ctx, request as $2.CheckUsernameRequest);
      case 'CheckEmail': return this.checkEmail(ctx, request as $2.CheckEmailRequest);
      case 'GetUser': return this.getUser(ctx, request as $2.GetUserRequest);
      case 'UpdateUser': return this.updateUser(ctx, request as $2.UpdateUserRequest);
      case 'ChangePassword': return this.changePassword(ctx, request as $2.ChangePasswordRequest);
      case 'ListUsers': return this.listUsers(ctx, request as $2.ListUsersRequest);
      case 'DeleteUser': return this.deleteUser(ctx, request as $2.DeleteUserRequest);
      case 'CreateProfile': return this.createProfile(ctx, request as $2.CreateProfileRequest);
      case 'ListUserProfiles': return this.listUserProfiles(ctx, request as $2.ListUserProfilesRequest);
      case 'UpdateProfile': return this.updateProfile(ctx, request as $2.UpdateProfileRequest);
      case 'DeleteProfile': return this.deleteProfile(ctx, request as $2.DeleteProfileRequest);
      case 'SignIn': return this.signIn(ctx, request as $2.SignInRequest);
      case 'RefreshToken': return this.refreshToken(ctx, request as $2.RefreshTokenRequest);
      case 'Logout': return this.logout(ctx, request as $2.LogoutRequest);
      case 'ValidateToken': return this.validateToken(ctx, request as $2.ValidateTokenRequest);
      case 'ListUserSessions': return this.listUserSessions(ctx, request as $2.ListUserSessionsRequest);
      case 'TerminateSession': return this.terminateSession(ctx, request as $2.TerminateSessionRequest);
      default: throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => OpenAuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => OpenAuthServiceBase$messageJson;
}

