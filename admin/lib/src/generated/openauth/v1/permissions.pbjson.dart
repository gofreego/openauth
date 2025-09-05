///
//  Generated code. Do not modify.
//  source: openauth/v1/permissions.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use permissionDescriptor instead')
const Permission$json = const {
  '1': 'Permission',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'description', '17': true},
    const {'1': 'created_by', '3': 5, '4': 1, '5': 3, '10': 'createdBy'},
    const {'1': 'created_at', '3': 6, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 7, '4': 1, '5': 3, '10': 'updatedAt'},
    const {'1': 'is_system', '3': 8, '4': 1, '5': 8, '10': 'isSystem'},
  ],
  '8': const [
    const {'1': '_description'},
  ],
};

/// Descriptor for `Permission`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionDescriptor = $convert.base64Decode('CgpQZXJtaXNzaW9uEg4KAmlkGAEgASgDUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEiEKDGRpc3BsYXlfbmFtZRgDIAEoCVILZGlzcGxheU5hbWUSJQoLZGVzY3JpcHRpb24YBCABKAlIAFILZGVzY3JpcHRpb26IAQESHQoKY3JlYXRlZF9ieRgFIAEoA1IJY3JlYXRlZEJ5Eh0KCmNyZWF0ZWRfYXQYBiABKANSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAcgASgDUgl1cGRhdGVkQXQSGwoJaXNfc3lzdGVtGAggASgIUghpc1N5c3RlbUIOCgxfZGVzY3JpcHRpb24=');
@$core.Deprecated('Use createPermissionRequestDescriptor instead')
const CreatePermissionRequest$json = const {
  '1': 'CreatePermissionRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'description', '17': true},
  ],
  '8': const [
    const {'1': '_description'},
  ],
};

/// Descriptor for `CreatePermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPermissionRequestDescriptor = $convert.base64Decode('ChdDcmVhdGVQZXJtaXNzaW9uUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEiEKDGRpc3BsYXlfbmFtZRgCIAEoCVILZGlzcGxheU5hbWUSJQoLZGVzY3JpcHRpb24YAyABKAlIAFILZGVzY3JpcHRpb26IAQFCDgoMX2Rlc2NyaXB0aW9u');
@$core.Deprecated('Use getPermissionRequestDescriptor instead')
const GetPermissionRequest$json = const {
  '1': 'GetPermissionRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `GetPermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPermissionRequestDescriptor = $convert.base64Decode('ChRHZXRQZXJtaXNzaW9uUmVxdWVzdBIOCgJpZBgBIAEoA1ICaWQ=');
@$core.Deprecated('Use listPermissionsRequestDescriptor instead')
const ListPermissionsRequest$json = const {
  '1': 'ListPermissionsRequest',
  '2': const [
    const {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
    const {'1': 'id', '3': 3, '4': 1, '5': 3, '9': 0, '10': 'id', '17': true},
    const {'1': 'search', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'search', '17': true},
    const {'1': 'all', '3': 5, '4': 1, '5': 8, '10': 'all'},
  ],
  '8': const [
    const {'1': '_id'},
    const {'1': '_search'},
  ],
};

/// Descriptor for `ListPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPermissionsRequestDescriptor = $convert.base64Decode('ChZMaXN0UGVybWlzc2lvbnNSZXF1ZXN0EhQKBWxpbWl0GAEgASgFUgVsaW1pdBIWCgZvZmZzZXQYAiABKAVSBm9mZnNldBITCgJpZBgDIAEoA0gAUgJpZIgBARIbCgZzZWFyY2gYBCABKAlIAVIGc2VhcmNoiAEBEhAKA2FsbBgFIAEoCFIDYWxsQgUKA19pZEIJCgdfc2VhcmNo');
@$core.Deprecated('Use listPermissionsResponseDescriptor instead')
const ListPermissionsResponse$json = const {
  '1': 'ListPermissionsResponse',
  '2': const [
    const {'1': 'permissions', '3': 1, '4': 3, '5': 11, '6': '.v1.Permission', '10': 'permissions'},
  ],
};

/// Descriptor for `ListPermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPermissionsResponseDescriptor = $convert.base64Decode('ChdMaXN0UGVybWlzc2lvbnNSZXNwb25zZRIwCgtwZXJtaXNzaW9ucxgBIAMoCzIOLnYxLlBlcm1pc3Npb25SC3Blcm1pc3Npb25z');
@$core.Deprecated('Use updatePermissionRequestDescriptor instead')
const UpdatePermissionRequest$json = const {
  '1': 'UpdatePermissionRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
    const {'1': 'display_name', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'description', '17': true},
  ],
  '8': const [
    const {'1': '_name'},
    const {'1': '_display_name'},
    const {'1': '_description'},
  ],
};

/// Descriptor for `UpdatePermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePermissionRequestDescriptor = $convert.base64Decode('ChdVcGRhdGVQZXJtaXNzaW9uUmVxdWVzdBIOCgJpZBgBIAEoA1ICaWQSFwoEbmFtZRgCIAEoCUgAUgRuYW1liAEBEiYKDGRpc3BsYXlfbmFtZRgDIAEoCUgBUgtkaXNwbGF5TmFtZYgBARIlCgtkZXNjcmlwdGlvbhgEIAEoCUgCUgtkZXNjcmlwdGlvbogBAUIHCgVfbmFtZUIPCg1fZGlzcGxheV9uYW1lQg4KDF9kZXNjcmlwdGlvbg==');
@$core.Deprecated('Use deletePermissionRequestDescriptor instead')
const DeletePermissionRequest$json = const {
  '1': 'DeletePermissionRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `DeletePermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePermissionRequestDescriptor = $convert.base64Decode('ChdEZWxldGVQZXJtaXNzaW9uUmVxdWVzdBIOCgJpZBgBIAEoA1ICaWQ=');
@$core.Deprecated('Use deletePermissionResponseDescriptor instead')
const DeletePermissionResponse$json = const {
  '1': 'DeletePermissionResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeletePermissionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePermissionResponseDescriptor = $convert.base64Decode('ChhEZWxldGVQZXJtaXNzaW9uUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
