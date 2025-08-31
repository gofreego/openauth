///
//  Generated code. Do not modify.
//  source: openauth/v1/openauth.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/ping.pb.dart' as $0;
import 'permissions.pb.dart' as $1;
import 'users.pb.dart' as $2;

class OpenAuthApi {
  $pb.RpcClient _client;
  OpenAuthApi(this._client);

  $async.Future<$0.PingResponse> ping($pb.ClientContext? ctx, $0.PingRequest request) {
    var emptyResponse = $0.PingResponse();
    return _client.invoke<$0.PingResponse>(ctx, 'OpenAuth', 'Ping', request, emptyResponse);
  }
  $async.Future<$1.Permission> createPermission($pb.ClientContext? ctx, $1.CreatePermissionRequest request) {
    var emptyResponse = $1.Permission();
    return _client.invoke<$1.Permission>(ctx, 'OpenAuth', 'CreatePermission', request, emptyResponse);
  }
  $async.Future<$1.Permission> getPermission($pb.ClientContext? ctx, $1.GetPermissionRequest request) {
    var emptyResponse = $1.Permission();
    return _client.invoke<$1.Permission>(ctx, 'OpenAuth', 'GetPermission', request, emptyResponse);
  }
  $async.Future<$1.ListPermissionsResponse> listPermissions($pb.ClientContext? ctx, $1.ListPermissionsRequest request) {
    var emptyResponse = $1.ListPermissionsResponse();
    return _client.invoke<$1.ListPermissionsResponse>(ctx, 'OpenAuth', 'ListPermissions', request, emptyResponse);
  }
  $async.Future<$1.Permission> updatePermission($pb.ClientContext? ctx, $1.UpdatePermissionRequest request) {
    var emptyResponse = $1.Permission();
    return _client.invoke<$1.Permission>(ctx, 'OpenAuth', 'UpdatePermission', request, emptyResponse);
  }
  $async.Future<$1.DeletePermissionResponse> deletePermission($pb.ClientContext? ctx, $1.DeletePermissionRequest request) {
    var emptyResponse = $1.DeletePermissionResponse();
    return _client.invoke<$1.DeletePermissionResponse>(ctx, 'OpenAuth', 'DeletePermission', request, emptyResponse);
  }
  $async.Future<$2.SignUpResponse> signUp($pb.ClientContext? ctx, $2.SignUpRequest request) {
    var emptyResponse = $2.SignUpResponse();
    return _client.invoke<$2.SignUpResponse>(ctx, 'OpenAuth', 'SignUp', request, emptyResponse);
  }
  $async.Future<$2.VerificationResponse> verifyEmail($pb.ClientContext? ctx, $2.VerifyEmailRequest request) {
    var emptyResponse = $2.VerificationResponse();
    return _client.invoke<$2.VerificationResponse>(ctx, 'OpenAuth', 'VerifyEmail', request, emptyResponse);
  }
  $async.Future<$2.VerificationResponse> verifyPhone($pb.ClientContext? ctx, $2.VerifyPhoneRequest request) {
    var emptyResponse = $2.VerificationResponse();
    return _client.invoke<$2.VerificationResponse>(ctx, 'OpenAuth', 'VerifyPhone', request, emptyResponse);
  }
  $async.Future<$2.ResendVerificationResponse> resendVerification($pb.ClientContext? ctx, $2.ResendVerificationRequest request) {
    var emptyResponse = $2.ResendVerificationResponse();
    return _client.invoke<$2.ResendVerificationResponse>(ctx, 'OpenAuth', 'ResendVerification', request, emptyResponse);
  }
  $async.Future<$2.CheckUsernameResponse> checkUsername($pb.ClientContext? ctx, $2.CheckUsernameRequest request) {
    var emptyResponse = $2.CheckUsernameResponse();
    return _client.invoke<$2.CheckUsernameResponse>(ctx, 'OpenAuth', 'CheckUsername', request, emptyResponse);
  }
  $async.Future<$2.CheckEmailResponse> checkEmail($pb.ClientContext? ctx, $2.CheckEmailRequest request) {
    var emptyResponse = $2.CheckEmailResponse();
    return _client.invoke<$2.CheckEmailResponse>(ctx, 'OpenAuth', 'CheckEmail', request, emptyResponse);
  }
  $async.Future<$2.GetUserResponse> getUser($pb.ClientContext? ctx, $2.GetUserRequest request) {
    var emptyResponse = $2.GetUserResponse();
    return _client.invoke<$2.GetUserResponse>(ctx, 'OpenAuth', 'GetUser', request, emptyResponse);
  }
  $async.Future<$2.UpdateUserResponse> updateUser($pb.ClientContext? ctx, $2.UpdateUserRequest request) {
    var emptyResponse = $2.UpdateUserResponse();
    return _client.invoke<$2.UpdateUserResponse>(ctx, 'OpenAuth', 'UpdateUser', request, emptyResponse);
  }
  $async.Future<$2.ChangePasswordResponse> changePassword($pb.ClientContext? ctx, $2.ChangePasswordRequest request) {
    var emptyResponse = $2.ChangePasswordResponse();
    return _client.invoke<$2.ChangePasswordResponse>(ctx, 'OpenAuth', 'ChangePassword', request, emptyResponse);
  }
  $async.Future<$2.ListUsersResponse> listUsers($pb.ClientContext? ctx, $2.ListUsersRequest request) {
    var emptyResponse = $2.ListUsersResponse();
    return _client.invoke<$2.ListUsersResponse>(ctx, 'OpenAuth', 'ListUsers', request, emptyResponse);
  }
  $async.Future<$2.DeleteUserResponse> deleteUser($pb.ClientContext? ctx, $2.DeleteUserRequest request) {
    var emptyResponse = $2.DeleteUserResponse();
    return _client.invoke<$2.DeleteUserResponse>(ctx, 'OpenAuth', 'DeleteUser', request, emptyResponse);
  }
  $async.Future<$2.CreateProfileResponse> createProfile($pb.ClientContext? ctx, $2.CreateProfileRequest request) {
    var emptyResponse = $2.CreateProfileResponse();
    return _client.invoke<$2.CreateProfileResponse>(ctx, 'OpenAuth', 'CreateProfile', request, emptyResponse);
  }
  $async.Future<$2.ListUserProfilesResponse> listUserProfiles($pb.ClientContext? ctx, $2.ListUserProfilesRequest request) {
    var emptyResponse = $2.ListUserProfilesResponse();
    return _client.invoke<$2.ListUserProfilesResponse>(ctx, 'OpenAuth', 'ListUserProfiles', request, emptyResponse);
  }
  $async.Future<$2.UpdateProfileResponse> updateProfile($pb.ClientContext? ctx, $2.UpdateProfileRequest request) {
    var emptyResponse = $2.UpdateProfileResponse();
    return _client.invoke<$2.UpdateProfileResponse>(ctx, 'OpenAuth', 'UpdateProfile', request, emptyResponse);
  }
  $async.Future<$2.DeleteProfileResponse> deleteProfile($pb.ClientContext? ctx, $2.DeleteProfileRequest request) {
    var emptyResponse = $2.DeleteProfileResponse();
    return _client.invoke<$2.DeleteProfileResponse>(ctx, 'OpenAuth', 'DeleteProfile', request, emptyResponse);
  }
  $async.Future<$2.SignInResponse> signIn($pb.ClientContext? ctx, $2.SignInRequest request) {
    var emptyResponse = $2.SignInResponse();
    return _client.invoke<$2.SignInResponse>(ctx, 'OpenAuth', 'SignIn', request, emptyResponse);
  }
  $async.Future<$2.RefreshTokenResponse> refreshToken($pb.ClientContext? ctx, $2.RefreshTokenRequest request) {
    var emptyResponse = $2.RefreshTokenResponse();
    return _client.invoke<$2.RefreshTokenResponse>(ctx, 'OpenAuth', 'RefreshToken', request, emptyResponse);
  }
  $async.Future<$2.LogoutResponse> logout($pb.ClientContext? ctx, $2.LogoutRequest request) {
    var emptyResponse = $2.LogoutResponse();
    return _client.invoke<$2.LogoutResponse>(ctx, 'OpenAuth', 'Logout', request, emptyResponse);
  }
  $async.Future<$2.ValidateTokenResponse> validateToken($pb.ClientContext? ctx, $2.ValidateTokenRequest request) {
    var emptyResponse = $2.ValidateTokenResponse();
    return _client.invoke<$2.ValidateTokenResponse>(ctx, 'OpenAuth', 'ValidateToken', request, emptyResponse);
  }
  $async.Future<$2.ListUserSessionsResponse> listUserSessions($pb.ClientContext? ctx, $2.ListUserSessionsRequest request) {
    var emptyResponse = $2.ListUserSessionsResponse();
    return _client.invoke<$2.ListUserSessionsResponse>(ctx, 'OpenAuth', 'ListUserSessions', request, emptyResponse);
  }
  $async.Future<$2.TerminateSessionResponse> terminateSession($pb.ClientContext? ctx, $2.TerminateSessionRequest request) {
    var emptyResponse = $2.TerminateSessionResponse();
    return _client.invoke<$2.TerminateSessionResponse>(ctx, 'OpenAuth', 'TerminateSession', request, emptyResponse);
  }
}

