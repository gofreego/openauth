// This is a generated file - do not edit.
//
// Generated from openauth/v1/openauth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/ping.pb.dart' as $0;
import 'openauth.pbjson.dart';
import 'permissions.pb.dart' as $1;
import 'users.pb.dart' as $2;

export 'openauth.pb.dart';

abstract class OpenAuthServiceBase extends $pb.GeneratedService {
  $async.Future<$0.PingResponse> ping(
      $pb.ServerContext ctx, $0.PingRequest request);
  $async.Future<$1.Permission> createPermission(
      $pb.ServerContext ctx, $1.CreatePermissionRequest request);
  $async.Future<$1.Permission> getPermission(
      $pb.ServerContext ctx, $1.GetPermissionRequest request);
  $async.Future<$1.ListPermissionsResponse> listPermissions(
      $pb.ServerContext ctx, $1.ListPermissionsRequest request);
  $async.Future<$1.Permission> updatePermission(
      $pb.ServerContext ctx, $1.UpdatePermissionRequest request);
  $async.Future<$1.DeletePermissionResponse> deletePermission(
      $pb.ServerContext ctx, $1.DeletePermissionRequest request);
  $async.Future<$2.SignUpResponse> signUp(
      $pb.ServerContext ctx, $2.SignUpRequest request);
  $async.Future<$2.VerificationResponse> verifyEmail(
      $pb.ServerContext ctx, $2.VerifyEmailRequest request);
  $async.Future<$2.VerificationResponse> verifyPhone(
      $pb.ServerContext ctx, $2.VerifyPhoneRequest request);
  $async.Future<$2.ResendVerificationResponse> resendVerification(
      $pb.ServerContext ctx, $2.ResendVerificationRequest request);
  $async.Future<$2.CheckUsernameResponse> checkUsername(
      $pb.ServerContext ctx, $2.CheckUsernameRequest request);
  $async.Future<$2.CheckEmailResponse> checkEmail(
      $pb.ServerContext ctx, $2.CheckEmailRequest request);
  $async.Future<$2.GetUserResponse> getUser(
      $pb.ServerContext ctx, $2.GetUserRequest request);
  $async.Future<$2.UpdateUserResponse> updateUser(
      $pb.ServerContext ctx, $2.UpdateUserRequest request);
  $async.Future<$2.ChangePasswordResponse> changePassword(
      $pb.ServerContext ctx, $2.ChangePasswordRequest request);
  $async.Future<$2.ListUsersResponse> listUsers(
      $pb.ServerContext ctx, $2.ListUsersRequest request);
  $async.Future<$2.DeleteUserResponse> deleteUser(
      $pb.ServerContext ctx, $2.DeleteUserRequest request);
  $async.Future<$2.CreateProfileResponse> createProfile(
      $pb.ServerContext ctx, $2.CreateProfileRequest request);
  $async.Future<$2.ListUserProfilesResponse> listUserProfiles(
      $pb.ServerContext ctx, $2.ListUserProfilesRequest request);
  $async.Future<$2.UpdateProfileResponse> updateProfile(
      $pb.ServerContext ctx, $2.UpdateProfileRequest request);
  $async.Future<$2.DeleteProfileResponse> deleteProfile(
      $pb.ServerContext ctx, $2.DeleteProfileRequest request);
  $async.Future<$2.SignInResponse> signIn(
      $pb.ServerContext ctx, $2.SignInRequest request);
  $async.Future<$2.RefreshTokenResponse> refreshToken(
      $pb.ServerContext ctx, $2.RefreshTokenRequest request);
  $async.Future<$2.LogoutResponse> logout(
      $pb.ServerContext ctx, $2.LogoutRequest request);
  $async.Future<$2.ValidateTokenResponse> validateToken(
      $pb.ServerContext ctx, $2.ValidateTokenRequest request);
  $async.Future<$2.ListUserSessionsResponse> listUserSessions(
      $pb.ServerContext ctx, $2.ListUserSessionsRequest request);
  $async.Future<$2.TerminateSessionResponse> terminateSession(
      $pb.ServerContext ctx, $2.TerminateSessionRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Ping':
        return $0.PingRequest();
      case 'CreatePermission':
        return $1.CreatePermissionRequest();
      case 'GetPermission':
        return $1.GetPermissionRequest();
      case 'ListPermissions':
        return $1.ListPermissionsRequest();
      case 'UpdatePermission':
        return $1.UpdatePermissionRequest();
      case 'DeletePermission':
        return $1.DeletePermissionRequest();
      case 'SignUp':
        return $2.SignUpRequest();
      case 'VerifyEmail':
        return $2.VerifyEmailRequest();
      case 'VerifyPhone':
        return $2.VerifyPhoneRequest();
      case 'ResendVerification':
        return $2.ResendVerificationRequest();
      case 'CheckUsername':
        return $2.CheckUsernameRequest();
      case 'CheckEmail':
        return $2.CheckEmailRequest();
      case 'GetUser':
        return $2.GetUserRequest();
      case 'UpdateUser':
        return $2.UpdateUserRequest();
      case 'ChangePassword':
        return $2.ChangePasswordRequest();
      case 'ListUsers':
        return $2.ListUsersRequest();
      case 'DeleteUser':
        return $2.DeleteUserRequest();
      case 'CreateProfile':
        return $2.CreateProfileRequest();
      case 'ListUserProfiles':
        return $2.ListUserProfilesRequest();
      case 'UpdateProfile':
        return $2.UpdateProfileRequest();
      case 'DeleteProfile':
        return $2.DeleteProfileRequest();
      case 'SignIn':
        return $2.SignInRequest();
      case 'RefreshToken':
        return $2.RefreshTokenRequest();
      case 'Logout':
        return $2.LogoutRequest();
      case 'ValidateToken':
        return $2.ValidateTokenRequest();
      case 'ListUserSessions':
        return $2.ListUserSessionsRequest();
      case 'TerminateSession':
        return $2.TerminateSessionRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Ping':
        return ping(ctx, request as $0.PingRequest);
      case 'CreatePermission':
        return createPermission(ctx, request as $1.CreatePermissionRequest);
      case 'GetPermission':
        return getPermission(ctx, request as $1.GetPermissionRequest);
      case 'ListPermissions':
        return listPermissions(ctx, request as $1.ListPermissionsRequest);
      case 'UpdatePermission':
        return updatePermission(ctx, request as $1.UpdatePermissionRequest);
      case 'DeletePermission':
        return deletePermission(ctx, request as $1.DeletePermissionRequest);
      case 'SignUp':
        return signUp(ctx, request as $2.SignUpRequest);
      case 'VerifyEmail':
        return verifyEmail(ctx, request as $2.VerifyEmailRequest);
      case 'VerifyPhone':
        return verifyPhone(ctx, request as $2.VerifyPhoneRequest);
      case 'ResendVerification':
        return resendVerification(ctx, request as $2.ResendVerificationRequest);
      case 'CheckUsername':
        return checkUsername(ctx, request as $2.CheckUsernameRequest);
      case 'CheckEmail':
        return checkEmail(ctx, request as $2.CheckEmailRequest);
      case 'GetUser':
        return getUser(ctx, request as $2.GetUserRequest);
      case 'UpdateUser':
        return updateUser(ctx, request as $2.UpdateUserRequest);
      case 'ChangePassword':
        return changePassword(ctx, request as $2.ChangePasswordRequest);
      case 'ListUsers':
        return listUsers(ctx, request as $2.ListUsersRequest);
      case 'DeleteUser':
        return deleteUser(ctx, request as $2.DeleteUserRequest);
      case 'CreateProfile':
        return createProfile(ctx, request as $2.CreateProfileRequest);
      case 'ListUserProfiles':
        return listUserProfiles(ctx, request as $2.ListUserProfilesRequest);
      case 'UpdateProfile':
        return updateProfile(ctx, request as $2.UpdateProfileRequest);
      case 'DeleteProfile':
        return deleteProfile(ctx, request as $2.DeleteProfileRequest);
      case 'SignIn':
        return signIn(ctx, request as $2.SignInRequest);
      case 'RefreshToken':
        return refreshToken(ctx, request as $2.RefreshTokenRequest);
      case 'Logout':
        return logout(ctx, request as $2.LogoutRequest);
      case 'ValidateToken':
        return validateToken(ctx, request as $2.ValidateTokenRequest);
      case 'ListUserSessions':
        return listUserSessions(ctx, request as $2.ListUserSessionsRequest);
      case 'TerminateSession':
        return terminateSession(ctx, request as $2.TerminateSessionRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => OpenAuthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => OpenAuthServiceBase$messageJson;
}
