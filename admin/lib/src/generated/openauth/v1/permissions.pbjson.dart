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
    const {'1': 'resource', '3': 5, '4': 1, '5': 9, '10': 'resource'},
    const {'1': 'action', '3': 6, '4': 1, '5': 9, '10': 'action'},
    const {'1': 'is_system', '3': 7, '4': 1, '5': 8, '10': 'isSystem'},
    const {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 9, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '8': const [
    const {'1': '_description'},
  ],
};

/// Descriptor for `Permission`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionDescriptor = $convert.base64Decode('CgpQZXJtaXNzaW9uEg4KAmlkGAEgASgDUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEiEKDGRpc3BsYXlfbmFtZRgDIAEoCVILZGlzcGxheU5hbWUSJQoLZGVzY3JpcHRpb24YBCABKAlIAFILZGVzY3JpcHRpb26IAQESGgoIcmVzb3VyY2UYBSABKAlSCHJlc291cmNlEhYKBmFjdGlvbhgGIAEoCVIGYWN0aW9uEhsKCWlzX3N5c3RlbRgHIAEoCFIIaXNTeXN0ZW0SHQoKY3JlYXRlZF9hdBgIIAEoA1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYCSABKANSCXVwZGF0ZWRBdEIOCgxfZGVzY3JpcHRpb24=');
@$core.Deprecated('Use createPermissionRequestDescriptor instead')
const CreatePermissionRequest$json = const {
  '1': 'CreatePermissionRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'description', '17': true},
    const {'1': 'resource', '3': 4, '4': 1, '5': 9, '10': 'resource'},
    const {'1': 'action', '3': 5, '4': 1, '5': 9, '10': 'action'},
  ],
  '8': const [
    const {'1': '_description'},
  ],
};

/// Descriptor for `CreatePermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPermissionRequestDescriptor = $convert.base64Decode('ChdDcmVhdGVQZXJtaXNzaW9uUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEiEKDGRpc3BsYXlfbmFtZRgCIAEoCVILZGlzcGxheU5hbWUSJQoLZGVzY3JpcHRpb24YAyABKAlIAFILZGVzY3JpcHRpb26IAQESGgoIcmVzb3VyY2UYBCABKAlSCHJlc291cmNlEhYKBmFjdGlvbhgFIAEoCVIGYWN0aW9uQg4KDF9kZXNjcmlwdGlvbg==');
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
    const {'1': 'limit', '3': 1, '4': 1, '5': 5, '9': 0, '10': 'limit', '17': true},
    const {'1': 'offset', '3': 2, '4': 1, '5': 5, '9': 1, '10': 'offset', '17': true},
    const {'1': 'search', '3': 3, '4': 1, '5': 9, '9': 2, '10': 'search', '17': true},
    const {'1': 'resource', '3': 4, '4': 1, '5': 9, '9': 3, '10': 'resource', '17': true},
    const {'1': 'action', '3': 5, '4': 1, '5': 9, '9': 4, '10': 'action', '17': true},
    const {'1': 'is_system', '3': 6, '4': 1, '5': 8, '9': 5, '10': 'isSystem', '17': true},
  ],
  '8': const [
    const {'1': '_limit'},
    const {'1': '_offset'},
    const {'1': '_search'},
    const {'1': '_resource'},
    const {'1': '_action'},
    const {'1': '_is_system'},
  ],
};

/// Descriptor for `ListPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPermissionsRequestDescriptor = $convert.base64Decode('ChZMaXN0UGVybWlzc2lvbnNSZXF1ZXN0EhkKBWxpbWl0GAEgASgFSABSBWxpbWl0iAEBEhsKBm9mZnNldBgCIAEoBUgBUgZvZmZzZXSIAQESGwoGc2VhcmNoGAMgASgJSAJSBnNlYXJjaIgBARIfCghyZXNvdXJjZRgEIAEoCUgDUghyZXNvdXJjZYgBARIbCgZhY3Rpb24YBSABKAlIBFIGYWN0aW9uiAEBEiAKCWlzX3N5c3RlbRgGIAEoCEgFUghpc1N5c3RlbYgBAUIICgZfbGltaXRCCQoHX29mZnNldEIJCgdfc2VhcmNoQgsKCV9yZXNvdXJjZUIJCgdfYWN0aW9uQgwKCl9pc19zeXN0ZW0=');
@$core.Deprecated('Use listPermissionsResponseDescriptor instead')
const ListPermissionsResponse$json = const {
  '1': 'ListPermissionsResponse',
  '2': const [
    const {'1': 'permissions', '3': 1, '4': 3, '5': 11, '6': '.v1.Permission', '10': 'permissions'},
    const {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
    const {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
    const {'1': 'has_more', '3': 5, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListPermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPermissionsResponseDescriptor = $convert.base64Decode('ChdMaXN0UGVybWlzc2lvbnNSZXNwb25zZRIwCgtwZXJtaXNzaW9ucxgBIAMoCzIOLnYxLlBlcm1pc3Npb25SC3Blcm1pc3Npb25zEh8KC3RvdGFsX2NvdW50GAIgASgFUgp0b3RhbENvdW50EhQKBWxpbWl0GAMgASgFUgVsaW1pdBIWCgZvZmZzZXQYBCABKAVSBm9mZnNldBIZCghoYXNfbW9yZRgFIAEoCFIHaGFzTW9yZQ==');
@$core.Deprecated('Use updatePermissionRequestDescriptor instead')
const UpdatePermissionRequest$json = const {
  '1': 'UpdatePermissionRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
    const {'1': 'display_name', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'description', '17': true},
    const {'1': 'resource', '3': 5, '4': 1, '5': 9, '9': 3, '10': 'resource', '17': true},
    const {'1': 'action', '3': 6, '4': 1, '5': 9, '9': 4, '10': 'action', '17': true},
  ],
  '8': const [
    const {'1': '_name'},
    const {'1': '_display_name'},
    const {'1': '_description'},
    const {'1': '_resource'},
    const {'1': '_action'},
  ],
};

/// Descriptor for `UpdatePermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePermissionRequestDescriptor = $convert.base64Decode('ChdVcGRhdGVQZXJtaXNzaW9uUmVxdWVzdBIOCgJpZBgBIAEoA1ICaWQSFwoEbmFtZRgCIAEoCUgAUgRuYW1liAEBEiYKDGRpc3BsYXlfbmFtZRgDIAEoCUgBUgtkaXNwbGF5TmFtZYgBARIlCgtkZXNjcmlwdGlvbhgEIAEoCUgCUgtkZXNjcmlwdGlvbogBARIfCghyZXNvdXJjZRgFIAEoCUgDUghyZXNvdXJjZYgBARIbCgZhY3Rpb24YBiABKAlIBFIGYWN0aW9uiAEBQgcKBV9uYW1lQg8KDV9kaXNwbGF5X25hbWVCDgoMX2Rlc2NyaXB0aW9uQgsKCV9yZXNvdXJjZUIJCgdfYWN0aW9u');
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
