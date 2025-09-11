///
//  Generated code. Do not modify.
//  source: openauth/v1/permission_assignments.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use assignPermissionsToGroupRequestDescriptor instead')
const AssignPermissionsToGroupRequest$json = const {
  '1': 'AssignPermissionsToGroupRequest',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'groupId'},
    const {'1': 'permissions_ids', '3': 2, '4': 3, '5': 3, '8': const {}, '10': 'permissionsIds'},
  ],
};

/// Descriptor for `AssignPermissionsToGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignPermissionsToGroupRequestDescriptor = $convert.base64Decode('Ch9Bc3NpZ25QZXJtaXNzaW9uc1RvR3JvdXBSZXF1ZXN0EiIKCGdyb3VwX2lkGAEgASgDQgf6QgQiAiAAUgdncm91cElkEjkKD3Blcm1pc3Npb25zX2lkcxgCIAMoA0IQ+kINkgEKCAEQZCIEIgIgAFIOcGVybWlzc2lvbnNJZHM=');
@$core.Deprecated('Use assignPermissionsToGroupResponseDescriptor instead')
const AssignPermissionsToGroupResponse$json = const {
  '1': 'AssignPermissionsToGroupResponse',
  '2': const [
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `AssignPermissionsToGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignPermissionsToGroupResponseDescriptor = $convert.base64Decode('CiBBc3NpZ25QZXJtaXNzaW9uc1RvR3JvdXBSZXNwb25zZRIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use removePermissionsFromGroupRequestDescriptor instead')
const RemovePermissionsFromGroupRequest$json = const {
  '1': 'RemovePermissionsFromGroupRequest',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'groupId'},
    const {'1': 'permissions_ids', '3': 2, '4': 3, '5': 3, '8': const {}, '10': 'permissionsIds'},
  ],
};

/// Descriptor for `RemovePermissionsFromGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePermissionsFromGroupRequestDescriptor = $convert.base64Decode('CiFSZW1vdmVQZXJtaXNzaW9uc0Zyb21Hcm91cFJlcXVlc3QSIgoIZ3JvdXBfaWQYASABKANCB/pCBCICIABSB2dyb3VwSWQSOQoPcGVybWlzc2lvbnNfaWRzGAIgAygDQhD6Qg2SAQoIARBkIgQiAiAAUg5wZXJtaXNzaW9uc0lkcw==');
@$core.Deprecated('Use removePermissionsFromGroupResponseDescriptor instead')
const RemovePermissionsFromGroupResponse$json = const {
  '1': 'RemovePermissionsFromGroupResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RemovePermissionsFromGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePermissionsFromGroupResponseDescriptor = $convert.base64Decode('CiJSZW1vdmVQZXJtaXNzaW9uc0Zyb21Hcm91cFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use listGroupPermissionsRequestDescriptor instead')
const ListGroupPermissionsRequest$json = const {
  '1': 'ListGroupPermissionsRequest',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'groupId'},
  ],
};

/// Descriptor for `ListGroupPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGroupPermissionsRequestDescriptor = $convert.base64Decode('ChtMaXN0R3JvdXBQZXJtaXNzaW9uc1JlcXVlc3QSIgoIZ3JvdXBfaWQYASABKANCB/pCBCICIABSB2dyb3VwSWQ=');
@$core.Deprecated('Use listGroupPermissionsResponseDescriptor instead')
const ListGroupPermissionsResponse$json = const {
  '1': 'ListGroupPermissionsResponse',
  '2': const [
    const {'1': 'permissions', '3': 1, '4': 3, '5': 11, '6': '.v1.EffectivePermission', '10': 'permissions'},
  ],
};

/// Descriptor for `ListGroupPermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGroupPermissionsResponseDescriptor = $convert.base64Decode('ChxMaXN0R3JvdXBQZXJtaXNzaW9uc1Jlc3BvbnNlEjkKC3Blcm1pc3Npb25zGAEgAygLMhcudjEuRWZmZWN0aXZlUGVybWlzc2lvblILcGVybWlzc2lvbnM=');
@$core.Deprecated('Use assignPermissionsToUserRequestDescriptor instead')
const AssignPermissionsToUserRequest$json = const {
  '1': 'AssignPermissionsToUserRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'userId'},
    const {'1': 'permissions_ids', '3': 2, '4': 3, '5': 3, '8': const {}, '10': 'permissionsIds'},
    const {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '8': const {}, '9': 0, '10': 'expiresAt', '17': true},
  ],
  '8': const [
    const {'1': '_expires_at'},
  ],
};

/// Descriptor for `AssignPermissionsToUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignPermissionsToUserRequestDescriptor = $convert.base64Decode('Ch5Bc3NpZ25QZXJtaXNzaW9uc1RvVXNlclJlcXVlc3QSIAoHdXNlcl9pZBgBIAEoA0IH+kIEIgIgAFIGdXNlcklkEjkKD3Blcm1pc3Npb25zX2lkcxgCIAMoA0IQ+kINkgEKCAEQZCIEIgIgAFIOcGVybWlzc2lvbnNJZHMSKwoKZXhwaXJlc19hdBgDIAEoA0IH+kIEIgIoAEgAUglleHBpcmVzQXSIAQFCDQoLX2V4cGlyZXNfYXQ=');
@$core.Deprecated('Use assignPermissionsToUserResponseDescriptor instead')
const AssignPermissionsToUserResponse$json = const {
  '1': 'AssignPermissionsToUserResponse',
  '2': const [
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `AssignPermissionsToUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignPermissionsToUserResponseDescriptor = $convert.base64Decode('Ch9Bc3NpZ25QZXJtaXNzaW9uc1RvVXNlclJlc3BvbnNlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use removePermissionsFromUserRequestDescriptor instead')
const RemovePermissionsFromUserRequest$json = const {
  '1': 'RemovePermissionsFromUserRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'userId'},
    const {'1': 'permissions_ids', '3': 2, '4': 3, '5': 3, '8': const {}, '10': 'permissionsIds'},
  ],
};

/// Descriptor for `RemovePermissionsFromUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePermissionsFromUserRequestDescriptor = $convert.base64Decode('CiBSZW1vdmVQZXJtaXNzaW9uc0Zyb21Vc2VyUmVxdWVzdBIgCgd1c2VyX2lkGAEgASgDQgf6QgQiAiAAUgZ1c2VySWQSOQoPcGVybWlzc2lvbnNfaWRzGAIgAygDQhD6Qg2SAQoIARBkIgQiAiAAUg5wZXJtaXNzaW9uc0lkcw==');
@$core.Deprecated('Use removePermissionsFromUserResponseDescriptor instead')
const RemovePermissionsFromUserResponse$json = const {
  '1': 'RemovePermissionsFromUserResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RemovePermissionsFromUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePermissionsFromUserResponseDescriptor = $convert.base64Decode('CiFSZW1vdmVQZXJtaXNzaW9uc0Zyb21Vc2VyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use listUserPermissionsRequestDescriptor instead')
const ListUserPermissionsRequest$json = const {
  '1': 'ListUserPermissionsRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'userId'},
  ],
};

/// Descriptor for `ListUserPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserPermissionsRequestDescriptor = $convert.base64Decode('ChpMaXN0VXNlclBlcm1pc3Npb25zUmVxdWVzdBIgCgd1c2VyX2lkGAEgASgDQgf6QgQiAiAAUgZ1c2VySWQ=');
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
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'userId'},
  ],
};

/// Descriptor for `GetUserEffectivePermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserEffectivePermissionsRequestDescriptor = $convert.base64Decode('CiJHZXRVc2VyRWZmZWN0aXZlUGVybWlzc2lvbnNSZXF1ZXN0EiAKB3VzZXJfaWQYASABKANCB/pCBCICIABSBnVzZXJJZA==');
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
