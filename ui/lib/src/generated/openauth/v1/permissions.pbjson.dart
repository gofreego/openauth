// This is a generated file - do not edit.
//
// Generated from openauth/v1/permissions.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use permissionDescriptor instead')
const Permission$json = {
  '1': 'Permission',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'description',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'description',
      '17': true
    },
    {'1': 'resource', '3': 5, '4': 1, '5': 9, '10': 'resource'},
    {'1': 'action', '3': 6, '4': 1, '5': 9, '10': 'action'},
    {'1': 'is_system', '3': 7, '4': 1, '5': 8, '10': 'isSystem'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 9, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '8': [
    {'1': '_description'},
  ],
};

/// Descriptor for `Permission`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionDescriptor = $convert.base64Decode(
    'CgpQZXJtaXNzaW9uEg4KAmlkGAEgASgDUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEiEKDGRpc3'
    'BsYXlfbmFtZRgDIAEoCVILZGlzcGxheU5hbWUSJQoLZGVzY3JpcHRpb24YBCABKAlIAFILZGVz'
    'Y3JpcHRpb26IAQESGgoIcmVzb3VyY2UYBSABKAlSCHJlc291cmNlEhYKBmFjdGlvbhgGIAEoCV'
    'IGYWN0aW9uEhsKCWlzX3N5c3RlbRgHIAEoCFIIaXNTeXN0ZW0SHQoKY3JlYXRlZF9hdBgIIAEo'
    'A1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYCSABKANSCXVwZGF0ZWRBdEIOCgxfZGVzY3JpcH'
    'Rpb24=');

@$core.Deprecated('Use createPermissionRequestDescriptor instead')
const CreatePermissionRequest$json = {
  '1': 'CreatePermissionRequest',
  '2': [
    {
      '1': 'headers',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.v1.RequestHeaders',
      '10': 'headers'
    },
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'description',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'description',
      '17': true
    },
    {'1': 'resource', '3': 5, '4': 1, '5': 9, '10': 'resource'},
    {'1': 'action', '3': 6, '4': 1, '5': 9, '10': 'action'},
  ],
  '8': [
    {'1': '_description'},
  ],
};

/// Descriptor for `CreatePermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPermissionRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVQZXJtaXNzaW9uUmVxdWVzdBIsCgdoZWFkZXJzGAEgASgLMhIudjEuUmVxdWVzdE'
    'hlYWRlcnNSB2hlYWRlcnMSEgoEbmFtZRgCIAEoCVIEbmFtZRIhCgxkaXNwbGF5X25hbWUYAyAB'
    'KAlSC2Rpc3BsYXlOYW1lEiUKC2Rlc2NyaXB0aW9uGAQgASgJSABSC2Rlc2NyaXB0aW9uiAEBEh'
    'oKCHJlc291cmNlGAUgASgJUghyZXNvdXJjZRIWCgZhY3Rpb24YBiABKAlSBmFjdGlvbkIOCgxf'
    'ZGVzY3JpcHRpb24=');

@$core.Deprecated('Use getPermissionRequestDescriptor instead')
const GetPermissionRequest$json = {
  '1': 'GetPermissionRequest',
  '2': [
    {
      '1': 'headers',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.v1.RequestHeaders',
      '10': 'headers'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `GetPermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPermissionRequestDescriptor = $convert.base64Decode(
    'ChRHZXRQZXJtaXNzaW9uUmVxdWVzdBIsCgdoZWFkZXJzGAEgASgLMhIudjEuUmVxdWVzdEhlYW'
    'RlcnNSB2hlYWRlcnMSDgoCaWQYAiABKANSAmlk');

@$core.Deprecated('Use listPermissionsRequestDescriptor instead')
const ListPermissionsRequest$json = {
  '1': 'ListPermissionsRequest',
  '2': [
    {
      '1': 'headers',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.v1.RequestHeaders',
      '10': 'headers'
    },
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '9': 0, '10': 'limit', '17': true},
    {'1': 'offset', '3': 3, '4': 1, '5': 5, '9': 1, '10': 'offset', '17': true},
    {'1': 'search', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'search', '17': true},
    {
      '1': 'resource',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'resource',
      '17': true
    },
    {'1': 'action', '3': 6, '4': 1, '5': 9, '9': 4, '10': 'action', '17': true},
    {
      '1': 'is_system',
      '3': 7,
      '4': 1,
      '5': 8,
      '9': 5,
      '10': 'isSystem',
      '17': true
    },
  ],
  '8': [
    {'1': '_limit'},
    {'1': '_offset'},
    {'1': '_search'},
    {'1': '_resource'},
    {'1': '_action'},
    {'1': '_is_system'},
  ],
};

/// Descriptor for `ListPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPermissionsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0UGVybWlzc2lvbnNSZXF1ZXN0EiwKB2hlYWRlcnMYASABKAsyEi52MS5SZXF1ZXN0SG'
    'VhZGVyc1IHaGVhZGVycxIZCgVsaW1pdBgCIAEoBUgAUgVsaW1pdIgBARIbCgZvZmZzZXQYAyAB'
    'KAVIAVIGb2Zmc2V0iAEBEhsKBnNlYXJjaBgEIAEoCUgCUgZzZWFyY2iIAQESHwoIcmVzb3VyY2'
    'UYBSABKAlIA1IIcmVzb3VyY2WIAQESGwoGYWN0aW9uGAYgASgJSARSBmFjdGlvbogBARIgCglp'
    'c19zeXN0ZW0YByABKAhIBVIIaXNTeXN0ZW2IAQFCCAoGX2xpbWl0QgkKB19vZmZzZXRCCQoHX3'
    'NlYXJjaEILCglfcmVzb3VyY2VCCQoHX2FjdGlvbkIMCgpfaXNfc3lzdGVt');

@$core.Deprecated('Use listPermissionsResponseDescriptor instead')
const ListPermissionsResponse$json = {
  '1': 'ListPermissionsResponse',
  '2': [
    {
      '1': 'permissions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.v1.Permission',
      '10': 'permissions'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
    {'1': 'has_more', '3': 5, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListPermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPermissionsResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0UGVybWlzc2lvbnNSZXNwb25zZRIwCgtwZXJtaXNzaW9ucxgBIAMoCzIOLnYxLlBlcm'
    '1pc3Npb25SC3Blcm1pc3Npb25zEh8KC3RvdGFsX2NvdW50GAIgASgFUgp0b3RhbENvdW50EhQK'
    'BWxpbWl0GAMgASgFUgVsaW1pdBIWCgZvZmZzZXQYBCABKAVSBm9mZnNldBIZCghoYXNfbW9yZR'
    'gFIAEoCFIHaGFzTW9yZQ==');

@$core.Deprecated('Use updatePermissionRequestDescriptor instead')
const UpdatePermissionRequest$json = {
  '1': 'UpdatePermissionRequest',
  '2': [
    {
      '1': 'headers',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.v1.RequestHeaders',
      '10': 'headers'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 3, '10': 'id'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
    {
      '1': 'display_name',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'displayName',
      '17': true
    },
    {
      '1': 'description',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'description',
      '17': true
    },
    {
      '1': 'resource',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'resource',
      '17': true
    },
    {'1': 'action', '3': 7, '4': 1, '5': 9, '9': 4, '10': 'action', '17': true},
  ],
  '8': [
    {'1': '_name'},
    {'1': '_display_name'},
    {'1': '_description'},
    {'1': '_resource'},
    {'1': '_action'},
  ],
};

/// Descriptor for `UpdatePermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePermissionRequestDescriptor = $convert.base64Decode(
    'ChdVcGRhdGVQZXJtaXNzaW9uUmVxdWVzdBIsCgdoZWFkZXJzGAEgASgLMhIudjEuUmVxdWVzdE'
    'hlYWRlcnNSB2hlYWRlcnMSDgoCaWQYAiABKANSAmlkEhcKBG5hbWUYAyABKAlIAFIEbmFtZYgB'
    'ARImCgxkaXNwbGF5X25hbWUYBCABKAlIAVILZGlzcGxheU5hbWWIAQESJQoLZGVzY3JpcHRpb2'
    '4YBSABKAlIAlILZGVzY3JpcHRpb26IAQESHwoIcmVzb3VyY2UYBiABKAlIA1IIcmVzb3VyY2WI'
    'AQESGwoGYWN0aW9uGAcgASgJSARSBmFjdGlvbogBAUIHCgVfbmFtZUIPCg1fZGlzcGxheV9uYW'
    '1lQg4KDF9kZXNjcmlwdGlvbkILCglfcmVzb3VyY2VCCQoHX2FjdGlvbg==');

@$core.Deprecated('Use deletePermissionRequestDescriptor instead')
const DeletePermissionRequest$json = {
  '1': 'DeletePermissionRequest',
  '2': [
    {
      '1': 'headers',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.v1.RequestHeaders',
      '10': 'headers'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `DeletePermissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePermissionRequestDescriptor =
    $convert.base64Decode(
        'ChdEZWxldGVQZXJtaXNzaW9uUmVxdWVzdBIsCgdoZWFkZXJzGAEgASgLMhIudjEuUmVxdWVzdE'
        'hlYWRlcnNSB2hlYWRlcnMSDgoCaWQYAiABKANSAmlk');

@$core.Deprecated('Use deletePermissionResponseDescriptor instead')
const DeletePermissionResponse$json = {
  '1': 'DeletePermissionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeletePermissionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePermissionResponseDescriptor =
    $convert.base64Decode(
        'ChhEZWxldGVQZXJtaXNzaW9uUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCg'
        'dtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
