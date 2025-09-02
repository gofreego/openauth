///
//  Generated code. Do not modify.
//  source: openauth/v1/permission_assignments.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use assignPermissionToGroupRequestDescriptor instead')
const AssignPermissionToGroupRequest$json = const {
  '1': 'AssignPermissionToGroupRequest',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 3, '10': 'groupId'},
    const {'1': 'permission_id', '3': 2, '4': 1, '5': 3, '10': 'permissionId'},
  ],
};

/// Descriptor for `AssignPermissionToGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignPermissionToGroupRequestDescriptor = $convert.base64Decode('Ch5Bc3NpZ25QZXJtaXNzaW9uVG9Hcm91cFJlcXVlc3QSGQoIZ3JvdXBfaWQYASABKANSB2dyb3VwSWQSIwoNcGVybWlzc2lvbl9pZBgCIAEoA1IMcGVybWlzc2lvbklk');
@$core.Deprecated('Use assignPermissionToGroupResponseDescriptor instead')
const AssignPermissionToGroupResponse$json = const {
  '1': 'AssignPermissionToGroupResponse',
  '2': const [
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `AssignPermissionToGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignPermissionToGroupResponseDescriptor = $convert.base64Decode('Ch9Bc3NpZ25QZXJtaXNzaW9uVG9Hcm91cFJlc3BvbnNlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use removePermissionFromGroupRequestDescriptor instead')
const RemovePermissionFromGroupRequest$json = const {
  '1': 'RemovePermissionFromGroupRequest',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 3, '10': 'groupId'},
    const {'1': 'permission_id', '3': 2, '4': 1, '5': 3, '10': 'permissionId'},
  ],
};

/// Descriptor for `RemovePermissionFromGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePermissionFromGroupRequestDescriptor = $convert.base64Decode('CiBSZW1vdmVQZXJtaXNzaW9uRnJvbUdyb3VwUmVxdWVzdBIZCghncm91cF9pZBgBIAEoA1IHZ3JvdXBJZBIjCg1wZXJtaXNzaW9uX2lkGAIgASgDUgxwZXJtaXNzaW9uSWQ=');
@$core.Deprecated('Use removePermissionFromGroupResponseDescriptor instead')
const RemovePermissionFromGroupResponse$json = const {
  '1': 'RemovePermissionFromGroupResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RemovePermissionFromGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePermissionFromGroupResponseDescriptor = $convert.base64Decode('CiFSZW1vdmVQZXJtaXNzaW9uRnJvbUdyb3VwUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use listGroupPermissionsRequestDescriptor instead')
const ListGroupPermissionsRequest$json = const {
  '1': 'ListGroupPermissionsRequest',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 3, '10': 'groupId'},
  ],
};

/// Descriptor for `ListGroupPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGroupPermissionsRequestDescriptor = $convert.base64Decode('ChtMaXN0R3JvdXBQZXJtaXNzaW9uc1JlcXVlc3QSGQoIZ3JvdXBfaWQYASABKANSB2dyb3VwSWQ=');
@$core.Deprecated('Use listGroupPermissionsResponseDescriptor instead')
const ListGroupPermissionsResponse$json = const {
  '1': 'ListGroupPermissionsResponse',
  '2': const [
    const {'1': 'permissions', '3': 1, '4': 3, '5': 11, '6': '.v1.EffectivePermission', '10': 'permissions'},
  ],
};

/// Descriptor for `ListGroupPermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGroupPermissionsResponseDescriptor = $convert.base64Decode('ChxMaXN0R3JvdXBQZXJtaXNzaW9uc1Jlc3BvbnNlEjkKC3Blcm1pc3Npb25zGAEgAygLMhcudjEuRWZmZWN0aXZlUGVybWlzc2lvblILcGVybWlzc2lvbnM=');
@$core.Deprecated('Use assignPermissionToUserRequestDescriptor instead')
const AssignPermissionToUserRequest$json = const {
  '1': 'AssignPermissionToUserRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'permission_id', '3': 2, '4': 1, '5': 3, '10': 'permissionId'},
    const {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '9': 0, '10': 'expiresAt', '17': true},
  ],
  '8': const [
    const {'1': '_expires_at'},
  ],
};

/// Descriptor for `AssignPermissionToUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignPermissionToUserRequestDescriptor = $convert.base64Decode('Ch1Bc3NpZ25QZXJtaXNzaW9uVG9Vc2VyUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgDUgZ1c2VySWQSIwoNcGVybWlzc2lvbl9pZBgCIAEoA1IMcGVybWlzc2lvbklkEiIKCmV4cGlyZXNfYXQYAyABKANIAFIJZXhwaXJlc0F0iAEBQg0KC19leHBpcmVzX2F0');
@$core.Deprecated('Use assignPermissionToUserResponseDescriptor instead')
const AssignPermissionToUserResponse$json = const {
  '1': 'AssignPermissionToUserResponse',
  '2': const [
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `AssignPermissionToUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignPermissionToUserResponseDescriptor = $convert.base64Decode('Ch5Bc3NpZ25QZXJtaXNzaW9uVG9Vc2VyUmVzcG9uc2USGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use removePermissionFromUserRequestDescriptor instead')
const RemovePermissionFromUserRequest$json = const {
  '1': 'RemovePermissionFromUserRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'permission_id', '3': 2, '4': 1, '5': 3, '10': 'permissionId'},
  ],
};

/// Descriptor for `RemovePermissionFromUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePermissionFromUserRequestDescriptor = $convert.base64Decode('Ch9SZW1vdmVQZXJtaXNzaW9uRnJvbVVzZXJSZXF1ZXN0EhcKB3VzZXJfaWQYASABKANSBnVzZXJJZBIjCg1wZXJtaXNzaW9uX2lkGAIgASgDUgxwZXJtaXNzaW9uSWQ=');
@$core.Deprecated('Use removePermissionFromUserResponseDescriptor instead')
const RemovePermissionFromUserResponse$json = const {
  '1': 'RemovePermissionFromUserResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RemovePermissionFromUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePermissionFromUserResponseDescriptor = $convert.base64Decode('CiBSZW1vdmVQZXJtaXNzaW9uRnJvbVVzZXJSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use listUserPermissionsRequestDescriptor instead')
const ListUserPermissionsRequest$json = const {
  '1': 'ListUserPermissionsRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
  ],
};

/// Descriptor for `ListUserPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserPermissionsRequestDescriptor = $convert.base64Decode('ChpMaXN0VXNlclBlcm1pc3Npb25zUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgDUgZ1c2VySWQ=');
@$core.Deprecated('Use listUserPermissionsResponseDescriptor instead')
const ListUserPermissionsResponse$json = const {
  '1': 'ListUserPermissionsResponse',
  '2': const [
    const {'1': 'permissions', '3': 1, '4': 3, '5': 11, '6': '.v1.EffectivePermission', '10': 'permissions'},
  ],
};

/// Descriptor for `ListUserPermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserPermissionsResponseDescriptor = $convert.base64Decode('ChtMaXN0VXNlclBlcm1pc3Npb25zUmVzcG9uc2USOQoLcGVybWlzc2lvbnMYASADKAsyFy52MS5FZmZlY3RpdmVQZXJtaXNzaW9uUgtwZXJtaXNzaW9ucw==');
@$core.Deprecated('Use getUserEffectivePermissionsRequestDescriptor instead')
const GetUserEffectivePermissionsRequest$json = const {
  '1': 'GetUserEffectivePermissionsRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
  ],
};

/// Descriptor for `GetUserEffectivePermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserEffectivePermissionsRequestDescriptor = $convert.base64Decode('CiJHZXRVc2VyRWZmZWN0aXZlUGVybWlzc2lvbnNSZXF1ZXN0EhcKB3VzZXJfaWQYASABKANSBnVzZXJJZA==');
@$core.Deprecated('Use effectivePermissionDescriptor instead')
const EffectivePermission$json = const {
  '1': 'EffectivePermission',
  '2': const [
    const {'1': 'permission_id', '3': 1, '4': 1, '5': 3, '10': 'permissionId'},
    const {'1': 'permission_name', '3': 2, '4': 1, '5': 9, '10': 'permissionName'},
    const {'1': 'permission_display_name', '3': 3, '4': 1, '5': 9, '10': 'permissionDisplayName'},
    const {'1': 'permission_description', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'permissionDescription', '17': true},
    const {'1': 'source', '3': 5, '4': 1, '5': 9, '10': 'source'},
    const {'1': 'group_id', '3': 6, '4': 1, '5': 3, '9': 1, '10': 'groupId', '17': true},
    const {'1': 'group_name', '3': 7, '4': 1, '5': 9, '9': 2, '10': 'groupName', '17': true},
    const {'1': 'group_display_name', '3': 8, '4': 1, '5': 9, '9': 3, '10': 'groupDisplayName', '17': true},
    const {'1': 'expires_at', '3': 9, '4': 1, '5': 3, '9': 4, '10': 'expiresAt', '17': true},
    const {'1': 'granted_at', '3': 10, '4': 1, '5': 3, '10': 'grantedAt'},
    const {'1': 'granted_by', '3': 11, '4': 1, '5': 3, '10': 'grantedBy'},
  ],
  '8': const [
    const {'1': '_permission_description'},
    const {'1': '_group_id'},
    const {'1': '_group_name'},
    const {'1': '_group_display_name'},
    const {'1': '_expires_at'},
  ],
};

/// Descriptor for `EffectivePermission`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List effectivePermissionDescriptor = $convert.base64Decode('ChNFZmZlY3RpdmVQZXJtaXNzaW9uEiMKDXBlcm1pc3Npb25faWQYASABKANSDHBlcm1pc3Npb25JZBInCg9wZXJtaXNzaW9uX25hbWUYAiABKAlSDnBlcm1pc3Npb25OYW1lEjYKF3Blcm1pc3Npb25fZGlzcGxheV9uYW1lGAMgASgJUhVwZXJtaXNzaW9uRGlzcGxheU5hbWUSOgoWcGVybWlzc2lvbl9kZXNjcmlwdGlvbhgEIAEoCUgAUhVwZXJtaXNzaW9uRGVzY3JpcHRpb26IAQESFgoGc291cmNlGAUgASgJUgZzb3VyY2USHgoIZ3JvdXBfaWQYBiABKANIAVIHZ3JvdXBJZIgBARIiCgpncm91cF9uYW1lGAcgASgJSAJSCWdyb3VwTmFtZYgBARIxChJncm91cF9kaXNwbGF5X25hbWUYCCABKAlIA1IQZ3JvdXBEaXNwbGF5TmFtZYgBARIiCgpleHBpcmVzX2F0GAkgASgDSARSCWV4cGlyZXNBdIgBARIdCgpncmFudGVkX2F0GAogASgDUglncmFudGVkQXQSHQoKZ3JhbnRlZF9ieRgLIAEoA1IJZ3JhbnRlZEJ5QhkKF19wZXJtaXNzaW9uX2Rlc2NyaXB0aW9uQgsKCV9ncm91cF9pZEINCgtfZ3JvdXBfbmFtZUIVChNfZ3JvdXBfZGlzcGxheV9uYW1lQg0KC19leHBpcmVzX2F0');
@$core.Deprecated('Use getUserEffectivePermissionsResponseDescriptor instead')
const GetUserEffectivePermissionsResponse$json = const {
  '1': 'GetUserEffectivePermissionsResponse',
  '2': const [
    const {'1': 'permissions', '3': 1, '4': 3, '5': 11, '6': '.v1.EffectivePermission', '10': 'permissions'},
  ],
};

/// Descriptor for `GetUserEffectivePermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserEffectivePermissionsResponseDescriptor = $convert.base64Decode('CiNHZXRVc2VyRWZmZWN0aXZlUGVybWlzc2lvbnNSZXNwb25zZRI5CgtwZXJtaXNzaW9ucxgBIAMoCzIXLnYxLkVmZmVjdGl2ZVBlcm1pc3Npb25SC3Blcm1pc3Npb25z');
