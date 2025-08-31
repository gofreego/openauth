// This is a generated file - do not edit.
//
// Generated from openauth/v1/openauth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../common/ping.pbjson.dart' as $0;
import 'permissions.pbjson.dart' as $1;

const $core.Map<$core.String, $core.dynamic> OpenAuthServiceBase$json = {
  '1': 'OpenAuth',
  '2': [
    {'1': 'Ping', '2': '.v1.PingRequest', '3': '.v1.PingResponse', '4': {}},
    {
      '1': 'CreatePermission',
      '2': '.v1.CreatePermissionRequest',
      '3': '.v1.Permission',
      '4': {}
    },
    {
      '1': 'GetPermission',
      '2': '.v1.GetPermissionRequest',
      '3': '.v1.Permission',
      '4': {}
    },
    {
      '1': 'ListPermissions',
      '2': '.v1.ListPermissionsRequest',
      '3': '.v1.ListPermissionsResponse',
      '4': {}
    },
    {
      '1': 'UpdatePermission',
      '2': '.v1.UpdatePermissionRequest',
      '3': '.v1.Permission',
      '4': {}
    },
    {
      '1': 'DeletePermission',
      '2': '.v1.DeletePermissionRequest',
      '3': '.v1.DeletePermissionResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use openAuthServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    OpenAuthServiceBase$messageJson = {
  '.v1.PingRequest': $0.PingRequest$json,
  '.v1.RequestHeaders': $0.RequestHeaders$json,
  '.v1.PingResponse': $0.PingResponse$json,
  '.v1.CreatePermissionRequest': $1.CreatePermissionRequest$json,
  '.v1.Permission': $1.Permission$json,
  '.v1.GetPermissionRequest': $1.GetPermissionRequest$json,
  '.v1.ListPermissionsRequest': $1.ListPermissionsRequest$json,
  '.v1.ListPermissionsResponse': $1.ListPermissionsResponse$json,
  '.v1.UpdatePermissionRequest': $1.UpdatePermissionRequest$json,
  '.v1.DeletePermissionRequest': $1.DeletePermissionRequest$json,
  '.v1.DeletePermissionResponse': $1.DeletePermissionResponse$json,
};

/// Descriptor for `OpenAuth`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List openAuthServiceDescriptor = $convert.base64Decode(
    'CghPcGVuQXV0aBJECgRQaW5nEg8udjEuUGluZ1JlcXVlc3QaEC52MS5QaW5nUmVzcG9uc2UiGY'
    'LT5JMCExIRL29wZW5hdXRoL3YxL3BpbmcSZAoQQ3JlYXRlUGVybWlzc2lvbhIbLnYxLkNyZWF0'
    'ZVBlcm1pc3Npb25SZXF1ZXN0Gg4udjEuUGVybWlzc2lvbiIjgtPkkwIdOgEqIhgvb3BlbmF1dG'
    'gvdjEvcGVybWlzc2lvbnMSYAoNR2V0UGVybWlzc2lvbhIYLnYxLkdldFBlcm1pc3Npb25SZXF1'
    'ZXN0Gg4udjEuUGVybWlzc2lvbiIlgtPkkwIfEh0vb3BlbmF1dGgvdjEvcGVybWlzc2lvbnMve2'
    'lkfRJsCg9MaXN0UGVybWlzc2lvbnMSGi52MS5MaXN0UGVybWlzc2lvbnNSZXF1ZXN0GhsudjEu'
    'TGlzdFBlcm1pc3Npb25zUmVzcG9uc2UiIILT5JMCGhIYL29wZW5hdXRoL3YxL3Blcm1pc3Npb2'
    '5zEmkKEFVwZGF0ZVBlcm1pc3Npb24SGy52MS5VcGRhdGVQZXJtaXNzaW9uUmVxdWVzdBoOLnYx'
    'LlBlcm1pc3Npb24iKILT5JMCIjoBKhodL29wZW5hdXRoL3YxL3Blcm1pc3Npb25zL3tpZH0SdA'
    'oQRGVsZXRlUGVybWlzc2lvbhIbLnYxLkRlbGV0ZVBlcm1pc3Npb25SZXF1ZXN0GhwudjEuRGVs'
    'ZXRlUGVybWlzc2lvblJlc3BvbnNlIiWC0+STAh8qHS9vcGVuYXV0aC92MS9wZXJtaXNzaW9ucy'
    '97aWR9');
