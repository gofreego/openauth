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
import 'permissions.pb.dart' as $1;
import 'users.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// OpenAuth service provides authentication and authorization functionality
/// including user management, permissions, groups, and session management.
class OpenAuthApi {
  final $pb.RpcClient _client;

  OpenAuthApi(this._client);

  /// Ping is a simple health check endpoint to verify service availability
  $async.Future<$0.PingResponse> ping(
          $pb.ClientContext? ctx, $0.PingRequest request) =>
      _client.invoke<$0.PingResponse>(
          ctx, 'OpenAuth', 'Ping', request, $0.PingResponse());

  /// CreatePermission creates a new permission in the system.
  ///
  /// Permissions follow the pattern: resource.action (e.g., "users.create")
  /// - resource: The entity being accessed (users, groups, permissions, etc.)
  /// - action: The operation being performed (create, read, update, delete, etc.)
  ///
  /// Example: Creating a permission for user management would have:
  /// - name: "users.create"
  /// - resource: "users"
  /// - action: "create"
  /// - display_name: "Create Users"
  $async.Future<$1.Permission> createPermission(
          $pb.ClientContext? ctx, $1.CreatePermissionRequest request) =>
      _client.invoke<$1.Permission>(
          ctx, 'OpenAuth', 'CreatePermission', request, $1.Permission());

  /// GetPermission retrieves a specific permission by its unique ID.
  ///
  /// Returns the complete permission details including resource, action,
  /// system status, and metadata.
  $async.Future<$1.Permission> getPermission(
          $pb.ClientContext? ctx, $1.GetPermissionRequest request) =>
      _client.invoke<$1.Permission>(
          ctx, 'OpenAuth', 'GetPermission', request, $1.Permission());

  /// ListPermissions retrieves permissions with optional filtering and pagination.
  ///
  /// Supports filtering by:
  /// - search: Searches across name, display_name, and description fields
  /// - resource: Filter by specific resource type (e.g., "users", "groups")
  /// - action: Filter by specific action type (e.g., "create", "read")
  /// - is_system: Filter by system vs user-created permissions
  ///
  /// Pagination is handled via limit/offset parameters:
  /// - limit: Maximum number of results (default: 10, max: 100)
  /// - offset: Number of results to skip (default: 0)
  ///
  /// Example queries:
  /// - GET /openauth/v1/permissions?resource=users - All user-related permissions
  /// - GET /openauth/v1/permissions?action=create - All creation permissions
  /// - GET /openauth/v1/permissions?search=user&limit=20 - Search for "user" with 20 results
  $async.Future<$1.ListPermissionsResponse> listPermissions(
          $pb.ClientContext? ctx, $1.ListPermissionsRequest request) =>
      _client.invoke<$1.ListPermissionsResponse>(ctx, 'OpenAuth',
          'ListPermissions', request, $1.ListPermissionsResponse());

  /// UpdatePermission modifies an existing permission.
  ///
  /// All fields in the request are optional - only provided fields will be updated.
  /// System permissions (is_system=true) cannot be modified to prevent
  /// breaking core application functionality.
  ///
  /// Note: Changing the name requires ensuring uniqueness across all permissions.
  $async.Future<$1.Permission> updatePermission(
          $pb.ClientContext? ctx, $1.UpdatePermissionRequest request) =>
      _client.invoke<$1.Permission>(
          ctx, 'OpenAuth', 'UpdatePermission', request, $1.Permission());

  /// DeletePermission removes a permission from the system.
  ///
  /// System permissions (is_system=true) cannot be deleted as they are
  /// critical for application functionality. Attempting to delete a system
  /// permission will return a PermissionDenied error.
  ///
  /// Warning: Deleting a permission will affect all users and groups
  /// that currently have this permission assigned.
  $async.Future<$1.DeletePermissionResponse> deletePermission(
          $pb.ClientContext? ctx, $1.DeletePermissionRequest request) =>
      _client.invoke<$1.DeletePermissionResponse>(ctx, 'OpenAuth',
          'DeletePermission', request, $1.DeletePermissionResponse());

  /// SignUp creates a new user account in the system.
  ///
  /// Supports multiple registration methods:
  /// - Username + password (required)
  /// - Email + password (optional, triggers email verification)
  /// - Phone + password (optional, triggers SMS verification)
  ///
  /// Returns the created user and profile information along with
  /// verification requirements if email/phone was provided.
  $async.Future<$2.SignUpResponse> signUp(
          $pb.ClientContext? ctx, $2.SignUpRequest request) =>
      _client.invoke<$2.SignUpResponse>(
          ctx, 'OpenAuth', 'SignUp', request, $2.SignUpResponse());

  /// VerifyEmail verifies a user's email address using a verification code.
  ///
  /// The verification code is typically sent via email during registration
  /// or when requesting email verification. Successful verification
  /// enables email-based features and login.
  $async.Future<$2.VerificationResponse> verifyEmail(
          $pb.ClientContext? ctx, $2.VerifyEmailRequest request) =>
      _client.invoke<$2.VerificationResponse>(
          ctx, 'OpenAuth', 'VerifyEmail', request, $2.VerificationResponse());

  /// VerifyPhone verifies a user's phone number using a verification code.
  ///
  /// The verification code is typically sent via SMS during registration
  /// or when requesting phone verification. Successful verification
  /// enables SMS-based features and login.
  $async.Future<$2.VerificationResponse> verifyPhone(
          $pb.ClientContext? ctx, $2.VerifyPhoneRequest request) =>
      _client.invoke<$2.VerificationResponse>(
          ctx, 'OpenAuth', 'VerifyPhone', request, $2.VerificationResponse());

  /// ResendVerification resends verification codes for email or phone.
  ///
  /// Useful when users don't receive the initial verification code
  /// or when the code has expired. Includes rate limiting to prevent abuse.
  $async.Future<$2.ResendVerificationResponse> resendVerification(
          $pb.ClientContext? ctx, $2.ResendVerificationRequest request) =>
      _client.invoke<$2.ResendVerificationResponse>(ctx, 'OpenAuth',
          'ResendVerification', request, $2.ResendVerificationResponse());

  /// CheckUsername checks if a username is available for registration.
  ///
  /// Returns availability status and suggestions for alternative usernames
  /// if the requested username is already taken. Useful for real-time
  /// username validation during registration.
  $async.Future<$2.CheckUsernameResponse> checkUsername(
          $pb.ClientContext? ctx, $2.CheckUsernameRequest request) =>
      _client.invoke<$2.CheckUsernameResponse>(ctx, 'OpenAuth', 'CheckUsername',
          request, $2.CheckUsernameResponse());

  /// CheckEmail checks if an email address is available for registration.
  ///
  /// Returns availability status for the email address. Used to prevent
  /// duplicate registrations and provide user feedback during signup.
  $async.Future<$2.CheckEmailResponse> checkEmail(
          $pb.ClientContext? ctx, $2.CheckEmailRequest request) =>
      _client.invoke<$2.CheckEmailResponse>(
          ctx, 'OpenAuth', 'CheckEmail', request, $2.CheckEmailResponse());

  /// GetUser retrieves user information by ID, UUID, username, or email.
  ///
  /// Supports multiple identifier types and optional profile inclusion.
  /// Access control should be enforced based on the requesting user's
  /// permissions and relationship to the target user.
  $async.Future<$2.GetUserResponse> getUser(
          $pb.ClientContext? ctx, $2.GetUserRequest request) =>
      _client.invoke<$2.GetUserResponse>(
          ctx, 'OpenAuth', 'GetUser', request, $2.GetUserResponse());

  /// UpdateUser modifies user account and profile information.
  ///
  /// Supports partial updates - only provided fields are modified.
  /// Sensitive operations like email/phone changes may require
  /// additional verification steps.
  $async.Future<$2.UpdateUserResponse> updateUser(
          $pb.ClientContext? ctx, $2.UpdateUserRequest request) =>
      _client.invoke<$2.UpdateUserResponse>(
          ctx, 'OpenAuth', 'UpdateUser', request, $2.UpdateUserResponse());

  /// ChangePassword allows users to change their password.
  ///
  /// Requires the current password for verification and the new password.
  /// Triggers password change tracking and may invalidate existing sessions.
  $async.Future<$2.ChangePasswordResponse> changePassword(
          $pb.ClientContext? ctx, $2.ChangePasswordRequest request) =>
      _client.invoke<$2.ChangePasswordResponse>(ctx, 'OpenAuth',
          'ChangePassword', request, $2.ChangePasswordResponse());

  /// ListUsers retrieves users with filtering, sorting, and pagination.
  ///
  /// Supports filtering by:
  /// - search: Search across username, email, and name fields
  /// - is_active: Filter by account status
  /// - email_verified/phone_verified: Filter by verification status
  ///
  /// Requires appropriate permissions to access user listings.
  $async.Future<$2.ListUsersResponse> listUsers(
          $pb.ClientContext? ctx, $2.ListUsersRequest request) =>
      _client.invoke<$2.ListUsersResponse>(
          ctx, 'OpenAuth', 'ListUsers', request, $2.ListUsersResponse());

  /// DeleteUser removes or deactivates a user account.
  ///
  /// Supports both soft delete (deactivation) and hard delete.
  /// Soft delete preserves data while preventing access.
  /// Hard delete permanently removes the user and all associated data.
  $async.Future<$2.DeleteUserResponse> deleteUser(
          $pb.ClientContext? ctx, $2.DeleteUserRequest request) =>
      _client.invoke<$2.DeleteUserResponse>(
          ctx, 'OpenAuth', 'DeleteUser', request, $2.DeleteUserResponse());
}
