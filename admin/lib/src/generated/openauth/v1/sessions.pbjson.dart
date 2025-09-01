///
//  Generated code. Do not modify.
//  source: openauth/v1/sessions.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use signInMetadataDescriptor instead')
const SignInMetadata$json = const {
  '1': 'SignInMetadata',
  '2': const [
    const {'1': 'device_id', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'deviceId', '17': true},
    const {'1': 'device_name', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'deviceName', '17': true},
    const {'1': 'device_type', '3': 3, '4': 1, '5': 9, '9': 2, '10': 'deviceType', '17': true},
    const {'1': 'lat', '3': 4, '4': 1, '5': 1, '9': 3, '10': 'lat', '17': true},
    const {'1': 'long', '3': 5, '4': 1, '5': 1, '9': 4, '10': 'long', '17': true},
  ],
  '8': const [
    const {'1': '_device_id'},
    const {'1': '_device_name'},
    const {'1': '_device_type'},
    const {'1': '_lat'},
    const {'1': '_long'},
  ],
};

/// Descriptor for `SignInMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signInMetadataDescriptor = $convert.base64Decode('Cg5TaWduSW5NZXRhZGF0YRIgCglkZXZpY2VfaWQYASABKAlIAFIIZGV2aWNlSWSIAQESJAoLZGV2aWNlX25hbWUYAiABKAlIAVIKZGV2aWNlTmFtZYgBARIkCgtkZXZpY2VfdHlwZRgDIAEoCUgCUgpkZXZpY2VUeXBliAEBEhUKA2xhdBgEIAEoAUgDUgNsYXSIAQESFwoEbG9uZxgFIAEoAUgEUgRsb25niAEBQgwKCl9kZXZpY2VfaWRCDgoMX2RldmljZV9uYW1lQg4KDF9kZXZpY2VfdHlwZUIGCgRfbGF0QgcKBV9sb25n');
@$core.Deprecated('Use signInRequestDescriptor instead')
const SignInRequest$json = const {
  '1': 'SignInRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'password', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'password', '17': true},
    const {'1': 'otp', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'otp', '17': true},
    const {'1': 'remember_me', '3': 4, '4': 1, '5': 8, '9': 2, '10': 'rememberMe', '17': true},
    const {'1': 'metadata', '3': 5, '4': 1, '5': 11, '6': '.v1.SignInMetadata', '9': 3, '10': 'metadata', '17': true},
    const {'1': 'profiles', '3': 6, '4': 1, '5': 8, '9': 4, '10': 'profiles', '17': true},
    const {'1': 'include_permissions', '3': 7, '4': 1, '5': 8, '9': 5, '10': 'includePermissions', '17': true},
  ],
  '8': const [
    const {'1': '_password'},
    const {'1': '_otp'},
    const {'1': '_remember_me'},
    const {'1': '_metadata'},
    const {'1': '_profiles'},
    const {'1': '_include_permissions'},
  ],
};

/// Descriptor for `SignInRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signInRequestDescriptor = $convert.base64Decode('Cg1TaWduSW5SZXF1ZXN0EhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIfCghwYXNzd29yZBgCIAEoCUgAUghwYXNzd29yZIgBARIVCgNvdHAYAyABKAlIAVIDb3RwiAEBEiQKC3JlbWVtYmVyX21lGAQgASgISAJSCnJlbWVtYmVyTWWIAQESMwoIbWV0YWRhdGEYBSABKAsyEi52MS5TaWduSW5NZXRhZGF0YUgDUghtZXRhZGF0YYgBARIfCghwcm9maWxlcxgGIAEoCEgEUghwcm9maWxlc4gBARI0ChNpbmNsdWRlX3Blcm1pc3Npb25zGAcgASgISAVSEmluY2x1ZGVQZXJtaXNzaW9uc4gBAUILCglfcGFzc3dvcmRCBgoEX290cEIOCgxfcmVtZW1iZXJfbWVCCwoJX21ldGFkYXRhQgsKCV9wcm9maWxlc0IWChRfaW5jbHVkZV9wZXJtaXNzaW9ucw==');
@$core.Deprecated('Use signInResponseDescriptor instead')
const SignInResponse$json = const {
  '1': 'SignInResponse',
  '2': const [
    const {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    const {'1': 'refresh_token', '3': 2, '4': 1, '5': 9, '10': 'refreshToken'},
    const {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '10': 'expiresAt'},
    const {'1': 'refresh_expires_at', '3': 4, '4': 1, '5': 3, '10': 'refreshExpiresAt'},
    const {'1': 'user', '3': 5, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
    const {'1': 'session_id', '3': 6, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'message', '3': 7, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SignInResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signInResponseDescriptor = $convert.base64Decode('Cg5TaWduSW5SZXNwb25zZRIhCgxhY2Nlc3NfdG9rZW4YASABKAlSC2FjY2Vzc1Rva2VuEiMKDXJlZnJlc2hfdG9rZW4YAiABKAlSDHJlZnJlc2hUb2tlbhIdCgpleHBpcmVzX2F0GAMgASgDUglleHBpcmVzQXQSLAoScmVmcmVzaF9leHBpcmVzX2F0GAQgASgDUhByZWZyZXNoRXhwaXJlc0F0EhwKBHVzZXIYBSABKAsyCC52MS5Vc2VyUgR1c2VyEh0KCnNlc3Npb25faWQYBiABKAlSCXNlc3Npb25JZBIYCgdtZXNzYWdlGAcgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use refreshTokenRequestDescriptor instead')
const RefreshTokenRequest$json = const {
  '1': 'RefreshTokenRequest',
  '2': const [
    const {'1': 'refresh_token', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
    const {'1': 'device_id', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'deviceId', '17': true},
    const {'1': 'profiles', '3': 3, '4': 1, '5': 8, '9': 1, '10': 'profiles', '17': true},
    const {'1': 'include_permissions', '3': 4, '4': 1, '5': 8, '9': 2, '10': 'includePermissions', '17': true},
  ],
  '8': const [
    const {'1': '_device_id'},
    const {'1': '_profiles'},
    const {'1': '_include_permissions'},
  ],
};

/// Descriptor for `RefreshTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshTokenRequestDescriptor = $convert.base64Decode('ChNSZWZyZXNoVG9rZW5SZXF1ZXN0EiMKDXJlZnJlc2hfdG9rZW4YASABKAlSDHJlZnJlc2hUb2tlbhIgCglkZXZpY2VfaWQYAiABKAlIAFIIZGV2aWNlSWSIAQESHwoIcHJvZmlsZXMYAyABKAhIAVIIcHJvZmlsZXOIAQESNAoTaW5jbHVkZV9wZXJtaXNzaW9ucxgEIAEoCEgCUhJpbmNsdWRlUGVybWlzc2lvbnOIAQFCDAoKX2RldmljZV9pZEILCglfcHJvZmlsZXNCFgoUX2luY2x1ZGVfcGVybWlzc2lvbnM=');
@$core.Deprecated('Use refreshTokenResponseDescriptor instead')
const RefreshTokenResponse$json = const {
  '1': 'RefreshTokenResponse',
  '2': const [
    const {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    const {'1': 'refresh_token', '3': 2, '4': 1, '5': 9, '10': 'refreshToken'},
    const {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '10': 'expiresAt'},
    const {'1': 'refresh_expires_at', '3': 4, '4': 1, '5': 3, '10': 'refreshExpiresAt'},
    const {'1': 'message', '3': 5, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RefreshTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshTokenResponseDescriptor = $convert.base64Decode('ChRSZWZyZXNoVG9rZW5SZXNwb25zZRIhCgxhY2Nlc3NfdG9rZW4YASABKAlSC2FjY2Vzc1Rva2VuEiMKDXJlZnJlc2hfdG9rZW4YAiABKAlSDHJlZnJlc2hUb2tlbhIdCgpleHBpcmVzX2F0GAMgASgDUglleHBpcmVzQXQSLAoScmVmcmVzaF9leHBpcmVzX2F0GAQgASgDUhByZWZyZXNoRXhwaXJlc0F0EhgKB21lc3NhZ2UYBSABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = const {
  '1': 'LogoutRequest',
  '2': const [
    const {'1': 'session_id', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'sessionId', '17': true},
    const {'1': 'all_sessions', '3': 2, '4': 1, '5': 8, '9': 1, '10': 'allSessions', '17': true},
  ],
  '8': const [
    const {'1': '_session_id'},
    const {'1': '_all_sessions'},
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode('Cg1Mb2dvdXRSZXF1ZXN0EiIKCnNlc3Npb25faWQYASABKAlIAFIJc2Vzc2lvbklkiAEBEiYKDGFsbF9zZXNzaW9ucxgCIAEoCEgBUgthbGxTZXNzaW9uc4gBAUINCgtfc2Vzc2lvbl9pZEIPCg1fYWxsX3Nlc3Npb25z');
@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = const {
  '1': 'LogoutResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'sessions_terminated', '3': 3, '4': 1, '5': 5, '10': 'sessionsTerminated'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert.base64Decode('Cg5Mb2dvdXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USLwoTc2Vzc2lvbnNfdGVybWluYXRlZBgDIAEoBVISc2Vzc2lvbnNUZXJtaW5hdGVk');
@$core.Deprecated('Use validateTokenRequestDescriptor instead')
const ValidateTokenRequest$json = const {
  '1': 'ValidateTokenRequest',
  '2': const [
    const {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `ValidateTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateTokenRequestDescriptor = $convert.base64Decode('ChRWYWxpZGF0ZVRva2VuUmVxdWVzdBIhCgxhY2Nlc3NfdG9rZW4YASABKAlSC2FjY2Vzc1Rva2Vu');
@$core.Deprecated('Use validateTokenResponseDescriptor instead')
const ValidateTokenResponse$json = const {
  '1': 'ValidateTokenResponse',
  '2': const [
    const {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'user', '3': 3, '4': 1, '5': 11, '6': '.v1.User', '9': 0, '10': 'user', '17': true},
    const {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '9': 1, '10': 'expiresAt', '17': true},
  ],
  '8': const [
    const {'1': '_user'},
    const {'1': '_expires_at'},
  ],
};

/// Descriptor for `ValidateTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateTokenResponseDescriptor = $convert.base64Decode('ChVWYWxpZGF0ZVRva2VuUmVzcG9uc2USFAoFdmFsaWQYASABKAhSBXZhbGlkEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USIQoEdXNlchgDIAEoCzIILnYxLlVzZXJIAFIEdXNlcogBARIiCgpleHBpcmVzX2F0GAQgASgDSAFSCWV4cGlyZXNBdIgBAUIHCgVfdXNlckINCgtfZXhwaXJlc19hdA==');
@$core.Deprecated('Use sessionDescriptor instead')
const Session$json = const {
  '1': 'Session',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'device_id', '3': 3, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'device_name', '3': 4, '4': 1, '5': 9, '10': 'deviceName'},
    const {'1': 'device_type', '3': 5, '4': 1, '5': 9, '10': 'deviceType'},
    const {'1': 'user_agent', '3': 6, '4': 1, '5': 9, '10': 'userAgent'},
    const {'1': 'ip_address', '3': 7, '4': 1, '5': 9, '10': 'ipAddress'},
    const {'1': 'location', '3': 8, '4': 1, '5': 9, '10': 'location'},
    const {'1': 'is_active', '3': 9, '4': 1, '5': 8, '10': 'isActive'},
    const {'1': 'expires_at', '3': 10, '4': 1, '5': 3, '10': 'expiresAt'},
    const {'1': 'last_activity_at', '3': 11, '4': 1, '5': 3, '10': 'lastActivityAt'},
    const {'1': 'created_at', '3': 12, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `Session`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionDescriptor = $convert.base64Decode('CgdTZXNzaW9uEg4KAmlkGAEgASgJUgJpZBIXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQSGwoJZGV2aWNlX2lkGAMgASgJUghkZXZpY2VJZBIfCgtkZXZpY2VfbmFtZRgEIAEoCVIKZGV2aWNlTmFtZRIfCgtkZXZpY2VfdHlwZRgFIAEoCVIKZGV2aWNlVHlwZRIdCgp1c2VyX2FnZW50GAYgASgJUgl1c2VyQWdlbnQSHQoKaXBfYWRkcmVzcxgHIAEoCVIJaXBBZGRyZXNzEhoKCGxvY2F0aW9uGAggASgJUghsb2NhdGlvbhIbCglpc19hY3RpdmUYCSABKAhSCGlzQWN0aXZlEh0KCmV4cGlyZXNfYXQYCiABKANSCWV4cGlyZXNBdBIoChBsYXN0X2FjdGl2aXR5X2F0GAsgASgDUg5sYXN0QWN0aXZpdHlBdBIdCgpjcmVhdGVkX2F0GAwgASgDUgljcmVhdGVkQXQ=');
@$core.Deprecated('Use listUserSessionsRequestDescriptor instead')
const ListUserSessionsRequest$json = const {
  '1': 'ListUserSessionsRequest',
  '2': const [
    const {'1': 'user_uuid', '3': 1, '4': 1, '5': 9, '10': 'userUuid'},
    const {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
    const {'1': 'active_only', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'activeOnly', '17': true},
  ],
  '8': const [
    const {'1': '_active_only'},
  ],
};

/// Descriptor for `ListUserSessionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserSessionsRequestDescriptor = $convert.base64Decode('ChdMaXN0VXNlclNlc3Npb25zUmVxdWVzdBIbCgl1c2VyX3V1aWQYASABKAlSCHVzZXJVdWlkEhQKBWxpbWl0GAIgASgFUgVsaW1pdBIWCgZvZmZzZXQYAyABKAVSBm9mZnNldBIkCgthY3RpdmVfb25seRgEIAEoCEgAUgphY3RpdmVPbmx5iAEBQg4KDF9hY3RpdmVfb25seQ==');
@$core.Deprecated('Use listUserSessionsResponseDescriptor instead')
const ListUserSessionsResponse$json = const {
  '1': 'ListUserSessionsResponse',
  '2': const [
    const {'1': 'sessions', '3': 1, '4': 3, '5': 11, '6': '.v1.Session', '10': 'sessions'},
  ],
};

/// Descriptor for `ListUserSessionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserSessionsResponseDescriptor = $convert.base64Decode('ChhMaXN0VXNlclNlc3Npb25zUmVzcG9uc2USJwoIc2Vzc2lvbnMYASADKAsyCy52MS5TZXNzaW9uUghzZXNzaW9ucw==');
@$core.Deprecated('Use terminateSessionRequestDescriptor instead')
const TerminateSessionRequest$json = const {
  '1': 'TerminateSessionRequest',
  '2': const [
    const {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `TerminateSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List terminateSessionRequestDescriptor = $convert.base64Decode('ChdUZXJtaW5hdGVTZXNzaW9uUmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQ=');
@$core.Deprecated('Use terminateSessionResponseDescriptor instead')
const TerminateSessionResponse$json = const {
  '1': 'TerminateSessionResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `TerminateSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List terminateSessionResponseDescriptor = $convert.base64Decode('ChhUZXJtaW5hdGVTZXNzaW9uUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
