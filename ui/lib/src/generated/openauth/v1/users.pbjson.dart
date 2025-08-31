// This is a generated file - do not edit.
//
// Generated from openauth/v1/users.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'email', '17': true},
    {'1': 'phone', '3': 5, '4': 1, '5': 9, '9': 1, '10': 'phone', '17': true},
    {'1': 'email_verified', '3': 6, '4': 1, '5': 8, '10': 'emailVerified'},
    {'1': 'phone_verified', '3': 7, '4': 1, '5': 8, '10': 'phoneVerified'},
    {'1': 'is_active', '3': 8, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'is_locked', '3': 9, '4': 1, '5': 8, '10': 'isLocked'},
    {
      '1': 'failed_login_attempts',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'failedLoginAttempts'
    },
    {
      '1': 'last_login_at',
      '3': 11,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'lastLoginAt',
      '17': true
    },
    {
      '1': 'password_changed_at',
      '3': 12,
      '4': 1,
      '5': 3,
      '10': 'passwordChangedAt'
    },
    {'1': 'created_at', '3': 13, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 14, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '8': [
    {'1': '_email'},
    {'1': '_phone'},
    {'1': '_last_login_at'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgDUgJpZBISCgR1dWlkGAIgASgJUgR1dWlkEhoKCHVzZXJuYW1lGA'
    'MgASgJUgh1c2VybmFtZRIZCgVlbWFpbBgEIAEoCUgAUgVlbWFpbIgBARIZCgVwaG9uZRgFIAEo'
    'CUgBUgVwaG9uZYgBARIlCg5lbWFpbF92ZXJpZmllZBgGIAEoCFINZW1haWxWZXJpZmllZBIlCg'
    '5waG9uZV92ZXJpZmllZBgHIAEoCFINcGhvbmVWZXJpZmllZBIbCglpc19hY3RpdmUYCCABKAhS'
    'CGlzQWN0aXZlEhsKCWlzX2xvY2tlZBgJIAEoCFIIaXNMb2NrZWQSMgoVZmFpbGVkX2xvZ2luX2'
    'F0dGVtcHRzGAogASgFUhNmYWlsZWRMb2dpbkF0dGVtcHRzEicKDWxhc3RfbG9naW5fYXQYCyAB'
    'KANIAlILbGFzdExvZ2luQXSIAQESLgoTcGFzc3dvcmRfY2hhbmdlZF9hdBgMIAEoA1IRcGFzc3'
    'dvcmRDaGFuZ2VkQXQSHQoKY3JlYXRlZF9hdBgNIAEoA1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRf'
    'YXQYDiABKANSCXVwZGF0ZWRBdEIICgZfZW1haWxCCAoGX3Bob25lQhAKDl9sYXN0X2xvZ2luX2'
    'F0');

@$core.Deprecated('Use userProfileDescriptor instead')
const UserProfile$json = {
  '1': 'UserProfile',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 3, '10': 'userId'},
    {
      '1': 'first_name',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'firstName',
      '17': true
    },
    {
      '1': 'last_name',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'lastName',
      '17': true
    },
    {
      '1': 'display_name',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'displayName',
      '17': true
    },
    {'1': 'bio', '3': 7, '4': 1, '5': 9, '9': 3, '10': 'bio', '17': true},
    {
      '1': 'avatar_url',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'avatarUrl',
      '17': true
    },
    {
      '1': 'date_of_birth',
      '3': 9,
      '4': 1,
      '5': 3,
      '9': 5,
      '10': 'dateOfBirth',
      '17': true
    },
    {
      '1': 'gender',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'gender',
      '17': true
    },
    {
      '1': 'timezone',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 7,
      '10': 'timezone',
      '17': true
    },
    {
      '1': 'locale',
      '3': 12,
      '4': 1,
      '5': 9,
      '9': 8,
      '10': 'locale',
      '17': true
    },
    {
      '1': 'country',
      '3': 13,
      '4': 1,
      '5': 9,
      '9': 9,
      '10': 'country',
      '17': true
    },
    {'1': 'city', '3': 14, '4': 1, '5': 9, '9': 10, '10': 'city', '17': true},
    {
      '1': 'address',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 11,
      '10': 'address',
      '17': true
    },
    {
      '1': 'postal_code',
      '3': 16,
      '4': 1,
      '5': 9,
      '9': 12,
      '10': 'postalCode',
      '17': true
    },
    {
      '1': 'website_url',
      '3': 17,
      '4': 1,
      '5': 9,
      '9': 13,
      '10': 'websiteUrl',
      '17': true
    },
    {'1': 'metadata', '3': 18, '4': 1, '5': 12, '10': 'metadata'},
    {'1': 'created_at', '3': 19, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 20, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '8': [
    {'1': '_first_name'},
    {'1': '_last_name'},
    {'1': '_display_name'},
    {'1': '_bio'},
    {'1': '_avatar_url'},
    {'1': '_date_of_birth'},
    {'1': '_gender'},
    {'1': '_timezone'},
    {'1': '_locale'},
    {'1': '_country'},
    {'1': '_city'},
    {'1': '_address'},
    {'1': '_postal_code'},
    {'1': '_website_url'},
  ],
};

/// Descriptor for `UserProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userProfileDescriptor = $convert.base64Decode(
    'CgtVc2VyUHJvZmlsZRIOCgJpZBgBIAEoA1ICaWQSEgoEdXVpZBgCIAEoCVIEdXVpZBIXCgd1c2'
    'VyX2lkGAMgASgDUgZ1c2VySWQSIgoKZmlyc3RfbmFtZRgEIAEoCUgAUglmaXJzdE5hbWWIAQES'
    'IAoJbGFzdF9uYW1lGAUgASgJSAFSCGxhc3ROYW1liAEBEiYKDGRpc3BsYXlfbmFtZRgGIAEoCU'
    'gCUgtkaXNwbGF5TmFtZYgBARIVCgNiaW8YByABKAlIA1IDYmlviAEBEiIKCmF2YXRhcl91cmwY'
    'CCABKAlIBFIJYXZhdGFyVXJsiAEBEicKDWRhdGVfb2ZfYmlydGgYCSABKANIBVILZGF0ZU9mQm'
    'lydGiIAQESGwoGZ2VuZGVyGAogASgJSAZSBmdlbmRlcogBARIfCgh0aW1lem9uZRgLIAEoCUgH'
    'Ugh0aW1lem9uZYgBARIbCgZsb2NhbGUYDCABKAlICFIGbG9jYWxliAEBEh0KB2NvdW50cnkYDS'
    'ABKAlICVIHY291bnRyeYgBARIXCgRjaXR5GA4gASgJSApSBGNpdHmIAQESHQoHYWRkcmVzcxgP'
    'IAEoCUgLUgdhZGRyZXNziAEBEiQKC3Bvc3RhbF9jb2RlGBAgASgJSAxSCnBvc3RhbENvZGWIAQ'
    'ESJAoLd2Vic2l0ZV91cmwYESABKAlIDVIKd2Vic2l0ZVVybIgBARIaCghtZXRhZGF0YRgSIAEo'
    'DFIIbWV0YWRhdGESHQoKY3JlYXRlZF9hdBgTIAEoA1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYX'
    'QYFCABKANSCXVwZGF0ZWRBdEINCgtfZmlyc3RfbmFtZUIMCgpfbGFzdF9uYW1lQg8KDV9kaXNw'
    'bGF5X25hbWVCBgoEX2Jpb0INCgtfYXZhdGFyX3VybEIQCg5fZGF0ZV9vZl9iaXJ0aEIJCgdfZ2'
    'VuZGVyQgsKCV90aW1lem9uZUIJCgdfbG9jYWxlQgoKCF9jb3VudHJ5QgcKBV9jaXR5QgoKCF9h'
    'ZGRyZXNzQg4KDF9wb3N0YWxfY29kZUIOCgxfd2Vic2l0ZV91cmw=');

@$core.Deprecated('Use signUpRequestDescriptor instead')
const SignUpRequest$json = {
  '1': 'SignUpRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'email', '17': true},
    {'1': 'phone', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'phone', '17': true},
    {'1': 'password', '3': 4, '4': 1, '5': 9, '10': 'password'},
    {
      '1': 'first_name',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'firstName',
      '17': true
    },
    {
      '1': 'last_name',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'lastName',
      '17': true
    },
    {
      '1': 'display_name',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'displayName',
      '17': true
    },
    {
      '1': 'timezone',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'timezone',
      '17': true
    },
    {'1': 'locale', '3': 9, '4': 1, '5': 9, '9': 6, '10': 'locale', '17': true},
    {
      '1': 'country',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 7,
      '10': 'country',
      '17': true
    },
  ],
  '8': [
    {'1': '_email'},
    {'1': '_phone'},
    {'1': '_first_name'},
    {'1': '_last_name'},
    {'1': '_display_name'},
    {'1': '_timezone'},
    {'1': '_locale'},
    {'1': '_country'},
  ],
};

/// Descriptor for `SignUpRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signUpRequestDescriptor = $convert.base64Decode(
    'Cg1TaWduVXBSZXF1ZXN0EhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIZCgVlbWFpbBgCIA'
    'EoCUgAUgVlbWFpbIgBARIZCgVwaG9uZRgDIAEoCUgBUgVwaG9uZYgBARIaCghwYXNzd29yZBgE'
    'IAEoCVIIcGFzc3dvcmQSIgoKZmlyc3RfbmFtZRgFIAEoCUgCUglmaXJzdE5hbWWIAQESIAoJbG'
    'FzdF9uYW1lGAYgASgJSANSCGxhc3ROYW1liAEBEiYKDGRpc3BsYXlfbmFtZRgHIAEoCUgEUgtk'
    'aXNwbGF5TmFtZYgBARIfCgh0aW1lem9uZRgIIAEoCUgFUgh0aW1lem9uZYgBARIbCgZsb2NhbG'
    'UYCSABKAlIBlIGbG9jYWxliAEBEh0KB2NvdW50cnkYCiABKAlIB1IHY291bnRyeYgBAUIICgZf'
    'ZW1haWxCCAoGX3Bob25lQg0KC19maXJzdF9uYW1lQgwKCl9sYXN0X25hbWVCDwoNX2Rpc3BsYX'
    'lfbmFtZUILCglfdGltZXpvbmVCCQoHX2xvY2FsZUIKCghfY291bnRyeQ==');

@$core.Deprecated('Use signUpResponseDescriptor instead')
const SignUpResponse$json = {
  '1': 'SignUpResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
    {
      '1': 'profile',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.v1.UserProfile',
      '10': 'profile'
    },
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'email_verification_required',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'emailVerificationRequired'
    },
    {
      '1': 'phone_verification_required',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'phoneVerificationRequired'
    },
  ],
};

/// Descriptor for `SignUpResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signUpResponseDescriptor = $convert.base64Decode(
    'Cg5TaWduVXBSZXNwb25zZRIcCgR1c2VyGAEgASgLMggudjEuVXNlclIEdXNlchIpCgdwcm9maW'
    'xlGAIgASgLMg8udjEuVXNlclByb2ZpbGVSB3Byb2ZpbGUSGAoHbWVzc2FnZRgDIAEoCVIHbWVz'
    'c2FnZRI+ChtlbWFpbF92ZXJpZmljYXRpb25fcmVxdWlyZWQYBCABKAhSGWVtYWlsVmVyaWZpY2'
    'F0aW9uUmVxdWlyZWQSPgobcGhvbmVfdmVyaWZpY2F0aW9uX3JlcXVpcmVkGAUgASgIUhlwaG9u'
    'ZVZlcmlmaWNhdGlvblJlcXVpcmVk');

@$core.Deprecated('Use verifyEmailRequestDescriptor instead')
const VerifyEmailRequest$json = {
  '1': 'VerifyEmailRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {
      '1': 'verification_code',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'verificationCode'
    },
  ],
};

/// Descriptor for `VerifyEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyEmailRequestDescriptor = $convert.base64Decode(
    'ChJWZXJpZnlFbWFpbFJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEisKEXZlcmlmaWNhdG'
    'lvbl9jb2RlGAIgASgJUhB2ZXJpZmljYXRpb25Db2Rl');

@$core.Deprecated('Use verifyPhoneRequestDescriptor instead')
const VerifyPhoneRequest$json = {
  '1': 'VerifyPhoneRequest',
  '2': [
    {'1': 'phone', '3': 1, '4': 1, '5': 9, '10': 'phone'},
    {
      '1': 'verification_code',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'verificationCode'
    },
  ],
};

/// Descriptor for `VerifyPhoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyPhoneRequestDescriptor = $convert.base64Decode(
    'ChJWZXJpZnlQaG9uZVJlcXVlc3QSFAoFcGhvbmUYASABKAlSBXBob25lEisKEXZlcmlmaWNhdG'
    'lvbl9jb2RlGAIgASgJUhB2ZXJpZmljYXRpb25Db2Rl');

@$core.Deprecated('Use verificationResponseDescriptor instead')
const VerificationResponse$json = {
  '1': 'VerificationResponse',
  '2': [
    {'1': 'verified', '3': 1, '4': 1, '5': 8, '10': 'verified'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `VerificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationResponseDescriptor = $convert.base64Decode(
    'ChRWZXJpZmljYXRpb25SZXNwb25zZRIaCgh2ZXJpZmllZBgBIAEoCFIIdmVyaWZpZWQSGAoHbW'
    'Vzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use resendVerificationRequestDescriptor instead')
const ResendVerificationRequest$json = {
  '1': 'ResendVerificationRequest',
  '2': [
    {'1': 'identifier', '3': 1, '4': 1, '5': 9, '10': 'identifier'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `ResendVerificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resendVerificationRequestDescriptor =
    $convert.base64Decode(
        'ChlSZXNlbmRWZXJpZmljYXRpb25SZXF1ZXN0Eh4KCmlkZW50aWZpZXIYASABKAlSCmlkZW50aW'
        'ZpZXISEgoEdHlwZRgCIAEoCVIEdHlwZQ==');

@$core.Deprecated('Use resendVerificationResponseDescriptor instead')
const ResendVerificationResponse$json = {
  '1': 'ResendVerificationResponse',
  '2': [
    {'1': 'sent', '3': 1, '4': 1, '5': 8, '10': 'sent'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `ResendVerificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resendVerificationResponseDescriptor =
    $convert.base64Decode(
        'ChpSZXNlbmRWZXJpZmljYXRpb25SZXNwb25zZRISCgRzZW50GAEgASgIUgRzZW50EhgKB21lc3'
        'NhZ2UYAiABKAlSB21lc3NhZ2USHQoKZXhwaXJlc19hdBgDIAEoA1IJZXhwaXJlc0F0');

@$core.Deprecated('Use checkUsernameRequestDescriptor instead')
const CheckUsernameRequest$json = {
  '1': 'CheckUsernameRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `CheckUsernameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkUsernameRequestDescriptor =
    $convert.base64Decode(
        'ChRDaGVja1VzZXJuYW1lUmVxdWVzdBIaCgh1c2VybmFtZRgBIAEoCVIIdXNlcm5hbWU=');

@$core.Deprecated('Use checkUsernameResponseDescriptor instead')
const CheckUsernameResponse$json = {
  '1': 'CheckUsernameResponse',
  '2': [
    {'1': 'available', '3': 1, '4': 1, '5': 8, '10': 'available'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'suggestions', '3': 3, '4': 3, '5': 9, '10': 'suggestions'},
  ],
};

/// Descriptor for `CheckUsernameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkUsernameResponseDescriptor = $convert.base64Decode(
    'ChVDaGVja1VzZXJuYW1lUmVzcG9uc2USHAoJYXZhaWxhYmxlGAEgASgIUglhdmFpbGFibGUSGA'
    'oHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRIgCgtzdWdnZXN0aW9ucxgDIAMoCVILc3VnZ2VzdGlv'
    'bnM=');

@$core.Deprecated('Use checkEmailRequestDescriptor instead')
const CheckEmailRequest$json = {
  '1': 'CheckEmailRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `CheckEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkEmailRequestDescriptor = $convert
    .base64Decode('ChFDaGVja0VtYWlsUmVxdWVzdBIUCgVlbWFpbBgBIAEoCVIFZW1haWw=');

@$core.Deprecated('Use checkEmailResponseDescriptor instead')
const CheckEmailResponse$json = {
  '1': 'CheckEmailResponse',
  '2': [
    {'1': 'available', '3': 1, '4': 1, '5': 8, '10': 'available'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CheckEmailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkEmailResponseDescriptor = $convert.base64Decode(
    'ChJDaGVja0VtYWlsUmVzcG9uc2USHAoJYXZhaWxhYmxlGAEgASgIUglhdmFpbGFibGUSGAoHbW'
    'Vzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use getUserRequestDescriptor instead')
const GetUserRequest$json = {
  '1': 'GetUserRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '9': 0, '10': 'id'},
    {'1': 'uuid', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'uuid'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'username'},
    {'1': 'email', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'email'},
    {'1': 'include_profile', '3': 5, '4': 1, '5': 8, '10': 'includeProfile'},
  ],
  '8': [
    {'1': 'identifier'},
  ],
};

/// Descriptor for `GetUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRVc2VyUmVxdWVzdBIQCgJpZBgBIAEoA0gAUgJpZBIUCgR1dWlkGAIgASgJSABSBHV1aW'
    'QSHAoIdXNlcm5hbWUYAyABKAlIAFIIdXNlcm5hbWUSFgoFZW1haWwYBCABKAlIAFIFZW1haWwS'
    'JwoPaW5jbHVkZV9wcm9maWxlGAUgASgIUg5pbmNsdWRlUHJvZmlsZUIMCgppZGVudGlmaWVy');

@$core.Deprecated('Use getUserResponseDescriptor instead')
const GetUserResponse$json = {
  '1': 'GetUserResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
    {
      '1': 'profile',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.v1.UserProfile',
      '9': 0,
      '10': 'profile',
      '17': true
    },
  ],
  '8': [
    {'1': '_profile'},
  ],
};

/// Descriptor for `GetUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRVc2VyUmVzcG9uc2USHAoEdXNlchgBIAEoCzIILnYxLlVzZXJSBHVzZXISLgoHcHJvZm'
    'lsZRgCIAEoCzIPLnYxLlVzZXJQcm9maWxlSABSB3Byb2ZpbGWIAQFCCgoIX3Byb2ZpbGU=');

@$core.Deprecated('Use updateUserRequestDescriptor instead')
const UpdateUserRequest$json = {
  '1': 'UpdateUserRequest',
  '2': [
    {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    {
      '1': 'username',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'username',
      '17': true
    },
    {'1': 'email', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'email', '17': true},
    {'1': 'phone', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'phone', '17': true},
    {
      '1': 'is_active',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'isActive',
      '17': true
    },
    {
      '1': 'first_name',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'firstName',
      '17': true
    },
    {
      '1': 'last_name',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'lastName',
      '17': true
    },
    {
      '1': 'display_name',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'displayName',
      '17': true
    },
    {'1': 'bio', '3': 9, '4': 1, '5': 9, '9': 7, '10': 'bio', '17': true},
    {
      '1': 'avatar_url',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 8,
      '10': 'avatarUrl',
      '17': true
    },
    {
      '1': 'timezone',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 9,
      '10': 'timezone',
      '17': true
    },
    {
      '1': 'locale',
      '3': 12,
      '4': 1,
      '5': 9,
      '9': 10,
      '10': 'locale',
      '17': true
    },
    {
      '1': 'country',
      '3': 13,
      '4': 1,
      '5': 9,
      '9': 11,
      '10': 'country',
      '17': true
    },
    {'1': 'city', '3': 14, '4': 1, '5': 9, '9': 12, '10': 'city', '17': true},
    {
      '1': 'address',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 13,
      '10': 'address',
      '17': true
    },
    {
      '1': 'postal_code',
      '3': 16,
      '4': 1,
      '5': 9,
      '9': 14,
      '10': 'postalCode',
      '17': true
    },
    {
      '1': 'website_url',
      '3': 17,
      '4': 1,
      '5': 9,
      '9': 15,
      '10': 'websiteUrl',
      '17': true
    },
  ],
  '8': [
    {'1': '_username'},
    {'1': '_email'},
    {'1': '_phone'},
    {'1': '_is_active'},
    {'1': '_first_name'},
    {'1': '_last_name'},
    {'1': '_display_name'},
    {'1': '_bio'},
    {'1': '_avatar_url'},
    {'1': '_timezone'},
    {'1': '_locale'},
    {'1': '_country'},
    {'1': '_city'},
    {'1': '_address'},
    {'1': '_postal_code'},
    {'1': '_website_url'},
  ],
};

/// Descriptor for `UpdateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVVc2VyUmVxdWVzdBISCgR1dWlkGAEgASgJUgR1dWlkEh8KCHVzZXJuYW1lGAIgAS'
    'gJSABSCHVzZXJuYW1liAEBEhkKBWVtYWlsGAMgASgJSAFSBWVtYWlsiAEBEhkKBXBob25lGAQg'
    'ASgJSAJSBXBob25liAEBEiAKCWlzX2FjdGl2ZRgFIAEoCEgDUghpc0FjdGl2ZYgBARIiCgpmaX'
    'JzdF9uYW1lGAYgASgJSARSCWZpcnN0TmFtZYgBARIgCglsYXN0X25hbWUYByABKAlIBVIIbGFz'
    'dE5hbWWIAQESJgoMZGlzcGxheV9uYW1lGAggASgJSAZSC2Rpc3BsYXlOYW1liAEBEhUKA2Jpbx'
    'gJIAEoCUgHUgNiaW+IAQESIgoKYXZhdGFyX3VybBgKIAEoCUgIUglhdmF0YXJVcmyIAQESHwoI'
    'dGltZXpvbmUYCyABKAlICVIIdGltZXpvbmWIAQESGwoGbG9jYWxlGAwgASgJSApSBmxvY2FsZY'
    'gBARIdCgdjb3VudHJ5GA0gASgJSAtSB2NvdW50cnmIAQESFwoEY2l0eRgOIAEoCUgMUgRjaXR5'
    'iAEBEh0KB2FkZHJlc3MYDyABKAlIDVIHYWRkcmVzc4gBARIkCgtwb3N0YWxfY29kZRgQIAEoCU'
    'gOUgpwb3N0YWxDb2RliAEBEiQKC3dlYnNpdGVfdXJsGBEgASgJSA9SCndlYnNpdGVVcmyIAQFC'
    'CwoJX3VzZXJuYW1lQggKBl9lbWFpbEIICgZfcGhvbmVCDAoKX2lzX2FjdGl2ZUINCgtfZmlyc3'
    'RfbmFtZUIMCgpfbGFzdF9uYW1lQg8KDV9kaXNwbGF5X25hbWVCBgoEX2Jpb0INCgtfYXZhdGFy'
    'X3VybEILCglfdGltZXpvbmVCCQoHX2xvY2FsZUIKCghfY291bnRyeUIHCgVfY2l0eUIKCghfYW'
    'RkcmVzc0IOCgxfcG9zdGFsX2NvZGVCDgoMX3dlYnNpdGVfdXJs');

@$core.Deprecated('Use updateUserResponseDescriptor instead')
const UpdateUserResponse$json = {
  '1': 'UpdateUserResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
    {
      '1': 'profile',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.v1.UserProfile',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `UpdateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVVc2VyUmVzcG9uc2USHAoEdXNlchgBIAEoCzIILnYxLlVzZXJSBHVzZXISKQoHcH'
    'JvZmlsZRgCIAEoCzIPLnYxLlVzZXJQcm9maWxlUgdwcm9maWxl');

@$core.Deprecated('Use changePasswordRequestDescriptor instead')
const ChangePasswordRequest$json = {
  '1': 'ChangePasswordRequest',
  '2': [
    {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    {'1': 'current_password', '3': 2, '4': 1, '5': 9, '10': 'currentPassword'},
    {'1': 'new_password', '3': 3, '4': 1, '5': 9, '10': 'newPassword'},
  ],
};

/// Descriptor for `ChangePasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordRequestDescriptor = $convert.base64Decode(
    'ChVDaGFuZ2VQYXNzd29yZFJlcXVlc3QSEgoEdXVpZBgBIAEoCVIEdXVpZBIpChBjdXJyZW50X3'
    'Bhc3N3b3JkGAIgASgJUg9jdXJyZW50UGFzc3dvcmQSIQoMbmV3X3Bhc3N3b3JkGAMgASgJUgtu'
    'ZXdQYXNzd29yZA==');

@$core.Deprecated('Use changePasswordResponseDescriptor instead')
const ChangePasswordResponse$json = {
  '1': 'ChangePasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ChangePasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordResponseDescriptor =
    $convert.base64Decode(
        'ChZDaGFuZ2VQYXNzd29yZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbW'
        'Vzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use listUsersRequestDescriptor instead')
const ListUsersRequest$json = {
  '1': 'ListUsersRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
    {'1': 'search', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    {
      '1': 'is_active',
      '3': 4,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'isActive',
      '17': true
    },
    {
      '1': 'email_verified',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'emailVerified',
      '17': true
    },
    {
      '1': 'phone_verified',
      '3': 6,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'phoneVerified',
      '17': true
    },
    {
      '1': 'sort_by',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'sortBy',
      '17': true
    },
    {
      '1': 'sort_order',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'sortOrder',
      '17': true
    },
  ],
  '8': [
    {'1': '_search'},
    {'1': '_is_active'},
    {'1': '_email_verified'},
    {'1': '_phone_verified'},
    {'1': '_sort_by'},
    {'1': '_sort_order'},
  ],
};

/// Descriptor for `ListUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VXNlcnNSZXF1ZXN0EhQKBWxpbWl0GAEgASgFUgVsaW1pdBIWCgZvZmZzZXQYAiABKA'
    'VSBm9mZnNldBIbCgZzZWFyY2gYAyABKAlIAFIGc2VhcmNoiAEBEiAKCWlzX2FjdGl2ZRgEIAEo'
    'CEgBUghpc0FjdGl2ZYgBARIqCg5lbWFpbF92ZXJpZmllZBgFIAEoCEgCUg1lbWFpbFZlcmlmaW'
    'VkiAEBEioKDnBob25lX3ZlcmlmaWVkGAYgASgISANSDXBob25lVmVyaWZpZWSIAQESHAoHc29y'
    'dF9ieRgHIAEoCUgEUgZzb3J0QnmIAQESIgoKc29ydF9vcmRlchgIIAEoCUgFUglzb3J0T3JkZX'
    'KIAQFCCQoHX3NlYXJjaEIMCgpfaXNfYWN0aXZlQhEKD19lbWFpbF92ZXJpZmllZEIRCg9fcGhv'
    'bmVfdmVyaWZpZWRCCgoIX3NvcnRfYnlCDQoLX3NvcnRfb3JkZXI=');

@$core.Deprecated('Use listUsersResponseDescriptor instead')
const ListUsersResponse$json = {
  '1': 'ListUsersResponse',
  '2': [
    {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.v1.User', '10': 'users'},
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
    {'1': 'has_more', '3': 5, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VXNlcnNSZXNwb25zZRIeCgV1c2VycxgBIAMoCzIILnYxLlVzZXJSBXVzZXJzEh8KC3'
    'RvdGFsX2NvdW50GAIgASgFUgp0b3RhbENvdW50EhQKBWxpbWl0GAMgASgFUgVsaW1pdBIWCgZv'
    'ZmZzZXQYBCABKAVSBm9mZnNldBIZCghoYXNfbW9yZRgFIAEoCFIHaGFzTW9yZQ==');

@$core.Deprecated('Use deleteUserRequestDescriptor instead')
const DeleteUserRequest$json = {
  '1': 'DeleteUserRequest',
  '2': [
    {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    {'1': 'soft_delete', '3': 2, '4': 1, '5': 8, '10': 'softDelete'},
  ],
};

/// Descriptor for `DeleteUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVVc2VyUmVxdWVzdBISCgR1dWlkGAEgASgJUgR1dWlkEh8KC3NvZnRfZGVsZXRlGA'
    'IgASgIUgpzb2Z0RGVsZXRl');

@$core.Deprecated('Use deleteUserResponseDescriptor instead')
const DeleteUserResponse$json = {
  '1': 'DeleteUserResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserResponseDescriptor = $convert.base64Decode(
    'ChJEZWxldGVVc2VyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYW'
    'dlGAIgASgJUgdtZXNzYWdl');
