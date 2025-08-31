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
}
