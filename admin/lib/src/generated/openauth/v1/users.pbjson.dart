///
//  Generated code. Do not modify.
//  source: openauth/v1/users.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use userDescriptor instead')
const User$json = const {
  '1': 'User',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'email', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'email', '17': true},
    const {'1': 'phone', '3': 5, '4': 1, '5': 9, '9': 1, '10': 'phone', '17': true},
    const {'1': 'email_verified', '3': 6, '4': 1, '5': 8, '10': 'emailVerified'},
    const {'1': 'phone_verified', '3': 7, '4': 1, '5': 8, '10': 'phoneVerified'},
    const {'1': 'is_active', '3': 8, '4': 1, '5': 8, '10': 'isActive'},
    const {'1': 'is_locked', '3': 9, '4': 1, '5': 8, '10': 'isLocked'},
    const {'1': 'failed_login_attempts', '3': 10, '4': 1, '5': 5, '10': 'failedLoginAttempts'},
    const {'1': 'last_login_at', '3': 11, '4': 1, '5': 3, '9': 2, '10': 'lastLoginAt', '17': true},
    const {'1': 'password_changed_at', '3': 12, '4': 1, '5': 3, '10': 'passwordChangedAt'},
    const {'1': 'created_at', '3': 13, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 14, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '8': const [
    const {'1': '_email'},
    const {'1': '_phone'},
    const {'1': '_last_login_at'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode('CgRVc2VyEg4KAmlkGAEgASgDUgJpZBISCgR1dWlkGAIgASgJUgR1dWlkEhoKCHVzZXJuYW1lGAMgASgJUgh1c2VybmFtZRIZCgVlbWFpbBgEIAEoCUgAUgVlbWFpbIgBARIZCgVwaG9uZRgFIAEoCUgBUgVwaG9uZYgBARIlCg5lbWFpbF92ZXJpZmllZBgGIAEoCFINZW1haWxWZXJpZmllZBIlCg5waG9uZV92ZXJpZmllZBgHIAEoCFINcGhvbmVWZXJpZmllZBIbCglpc19hY3RpdmUYCCABKAhSCGlzQWN0aXZlEhsKCWlzX2xvY2tlZBgJIAEoCFIIaXNMb2NrZWQSMgoVZmFpbGVkX2xvZ2luX2F0dGVtcHRzGAogASgFUhNmYWlsZWRMb2dpbkF0dGVtcHRzEicKDWxhc3RfbG9naW5fYXQYCyABKANIAlILbGFzdExvZ2luQXSIAQESLgoTcGFzc3dvcmRfY2hhbmdlZF9hdBgMIAEoA1IRcGFzc3dvcmRDaGFuZ2VkQXQSHQoKY3JlYXRlZF9hdBgNIAEoA1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYDiABKANSCXVwZGF0ZWRBdEIICgZfZW1haWxCCAoGX3Bob25lQhAKDl9sYXN0X2xvZ2luX2F0');
@$core.Deprecated('Use userProfileDescriptor instead')
const UserProfile$json = const {
  '1': 'UserProfile',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'user_id', '3': 3, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'profile_name', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'profileName', '17': true},
    const {'1': 'first_name', '3': 5, '4': 1, '5': 9, '9': 1, '10': 'firstName', '17': true},
    const {'1': 'last_name', '3': 6, '4': 1, '5': 9, '9': 2, '10': 'lastName', '17': true},
    const {'1': 'display_name', '3': 7, '4': 1, '5': 9, '9': 3, '10': 'displayName', '17': true},
    const {'1': 'bio', '3': 8, '4': 1, '5': 9, '9': 4, '10': 'bio', '17': true},
    const {'1': 'avatar_url', '3': 9, '4': 1, '5': 9, '9': 5, '10': 'avatarUrl', '17': true},
    const {'1': 'date_of_birth', '3': 10, '4': 1, '5': 3, '9': 6, '10': 'dateOfBirth', '17': true},
    const {'1': 'gender', '3': 11, '4': 1, '5': 9, '9': 7, '10': 'gender', '17': true},
    const {'1': 'timezone', '3': 12, '4': 1, '5': 9, '9': 8, '10': 'timezone', '17': true},
    const {'1': 'locale', '3': 13, '4': 1, '5': 9, '9': 9, '10': 'locale', '17': true},
    const {'1': 'country', '3': 14, '4': 1, '5': 9, '9': 10, '10': 'country', '17': true},
    const {'1': 'city', '3': 15, '4': 1, '5': 9, '9': 11, '10': 'city', '17': true},
    const {'1': 'address', '3': 16, '4': 1, '5': 9, '9': 12, '10': 'address', '17': true},
    const {'1': 'postal_code', '3': 17, '4': 1, '5': 9, '9': 13, '10': 'postalCode', '17': true},
    const {'1': 'website_url', '3': 18, '4': 1, '5': 9, '9': 14, '10': 'websiteUrl', '17': true},
    const {'1': 'metadata', '3': 19, '4': 1, '5': 12, '10': 'metadata'},
    const {'1': 'created_at', '3': 20, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 21, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '8': const [
    const {'1': '_profile_name'},
    const {'1': '_first_name'},
    const {'1': '_last_name'},
    const {'1': '_display_name'},
    const {'1': '_bio'},
    const {'1': '_avatar_url'},
    const {'1': '_date_of_birth'},
    const {'1': '_gender'},
    const {'1': '_timezone'},
    const {'1': '_locale'},
    const {'1': '_country'},
    const {'1': '_city'},
    const {'1': '_address'},
    const {'1': '_postal_code'},
    const {'1': '_website_url'},
  ],
};

/// Descriptor for `UserProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userProfileDescriptor = $convert.base64Decode('CgtVc2VyUHJvZmlsZRIOCgJpZBgBIAEoA1ICaWQSEgoEdXVpZBgCIAEoCVIEdXVpZBIXCgd1c2VyX2lkGAMgASgDUgZ1c2VySWQSJgoMcHJvZmlsZV9uYW1lGAQgASgJSABSC3Byb2ZpbGVOYW1liAEBEiIKCmZpcnN0X25hbWUYBSABKAlIAVIJZmlyc3ROYW1liAEBEiAKCWxhc3RfbmFtZRgGIAEoCUgCUghsYXN0TmFtZYgBARImCgxkaXNwbGF5X25hbWUYByABKAlIA1ILZGlzcGxheU5hbWWIAQESFQoDYmlvGAggASgJSARSA2Jpb4gBARIiCgphdmF0YXJfdXJsGAkgASgJSAVSCWF2YXRhclVybIgBARInCg1kYXRlX29mX2JpcnRoGAogASgDSAZSC2RhdGVPZkJpcnRoiAEBEhsKBmdlbmRlchgLIAEoCUgHUgZnZW5kZXKIAQESHwoIdGltZXpvbmUYDCABKAlICFIIdGltZXpvbmWIAQESGwoGbG9jYWxlGA0gASgJSAlSBmxvY2FsZYgBARIdCgdjb3VudHJ5GA4gASgJSApSB2NvdW50cnmIAQESFwoEY2l0eRgPIAEoCUgLUgRjaXR5iAEBEh0KB2FkZHJlc3MYECABKAlIDFIHYWRkcmVzc4gBARIkCgtwb3N0YWxfY29kZRgRIAEoCUgNUgpwb3N0YWxDb2RliAEBEiQKC3dlYnNpdGVfdXJsGBIgASgJSA5SCndlYnNpdGVVcmyIAQESGgoIbWV0YWRhdGEYEyABKAxSCG1ldGFkYXRhEh0KCmNyZWF0ZWRfYXQYFCABKANSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GBUgASgDUgl1cGRhdGVkQXRCDwoNX3Byb2ZpbGVfbmFtZUINCgtfZmlyc3RfbmFtZUIMCgpfbGFzdF9uYW1lQg8KDV9kaXNwbGF5X25hbWVCBgoEX2Jpb0INCgtfYXZhdGFyX3VybEIQCg5fZGF0ZV9vZl9iaXJ0aEIJCgdfZ2VuZGVyQgsKCV90aW1lem9uZUIJCgdfbG9jYWxlQgoKCF9jb3VudHJ5QgcKBV9jaXR5QgoKCF9hZGRyZXNzQg4KDF9wb3N0YWxfY29kZUIOCgxfd2Vic2l0ZV91cmw=');
@$core.Deprecated('Use signUpRequestDescriptor instead')
const SignUpRequest$json = const {
  '1': 'SignUpRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'email', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'email', '17': true},
    const {'1': 'phone', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'phone', '17': true},
    const {'1': 'password', '3': 4, '4': 1, '5': 9, '10': 'password'},
  ],
  '8': const [
    const {'1': '_email'},
    const {'1': '_phone'},
  ],
};

/// Descriptor for `SignUpRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signUpRequestDescriptor = $convert.base64Decode('Cg1TaWduVXBSZXF1ZXN0EhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIZCgVlbWFpbBgCIAEoCUgAUgVlbWFpbIgBARIZCgVwaG9uZRgDIAEoCUgBUgVwaG9uZYgBARIaCghwYXNzd29yZBgEIAEoCVIIcGFzc3dvcmRCCAoGX2VtYWlsQggKBl9waG9uZQ==');
@$core.Deprecated('Use signUpResponseDescriptor instead')
const SignUpResponse$json = const {
  '1': 'SignUpResponse',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'email_verification_required', '3': 3, '4': 1, '5': 8, '10': 'emailVerificationRequired'},
    const {'1': 'phone_verification_required', '3': 4, '4': 1, '5': 8, '10': 'phoneVerificationRequired'},
  ],
};

/// Descriptor for `SignUpResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signUpResponseDescriptor = $convert.base64Decode('Cg5TaWduVXBSZXNwb25zZRIcCgR1c2VyGAEgASgLMggudjEuVXNlclIEdXNlchIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdlEj4KG2VtYWlsX3ZlcmlmaWNhdGlvbl9yZXF1aXJlZBgDIAEoCFIZZW1haWxWZXJpZmljYXRpb25SZXF1aXJlZBI+ChtwaG9uZV92ZXJpZmljYXRpb25fcmVxdWlyZWQYBCABKAhSGXBob25lVmVyaWZpY2F0aW9uUmVxdWlyZWQ=');
@$core.Deprecated('Use verifyEmailRequestDescriptor instead')
const VerifyEmailRequest$json = const {
  '1': 'VerifyEmailRequest',
  '2': const [
    const {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    const {'1': 'verification_code', '3': 2, '4': 1, '5': 9, '10': 'verificationCode'},
  ],
};

/// Descriptor for `VerifyEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyEmailRequestDescriptor = $convert.base64Decode('ChJWZXJpZnlFbWFpbFJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEisKEXZlcmlmaWNhdGlvbl9jb2RlGAIgASgJUhB2ZXJpZmljYXRpb25Db2Rl');
@$core.Deprecated('Use verifyPhoneRequestDescriptor instead')
const VerifyPhoneRequest$json = const {
  '1': 'VerifyPhoneRequest',
  '2': const [
    const {'1': 'phone', '3': 1, '4': 1, '5': 9, '10': 'phone'},
    const {'1': 'verification_code', '3': 2, '4': 1, '5': 9, '10': 'verificationCode'},
  ],
};

/// Descriptor for `VerifyPhoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyPhoneRequestDescriptor = $convert.base64Decode('ChJWZXJpZnlQaG9uZVJlcXVlc3QSFAoFcGhvbmUYASABKAlSBXBob25lEisKEXZlcmlmaWNhdGlvbl9jb2RlGAIgASgJUhB2ZXJpZmljYXRpb25Db2Rl');
@$core.Deprecated('Use verificationResponseDescriptor instead')
const VerificationResponse$json = const {
  '1': 'VerificationResponse',
  '2': const [
    const {'1': 'verified', '3': 1, '4': 1, '5': 8, '10': 'verified'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `VerificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationResponseDescriptor = $convert.base64Decode('ChRWZXJpZmljYXRpb25SZXNwb25zZRIaCgh2ZXJpZmllZBgBIAEoCFIIdmVyaWZpZWQSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use resendVerificationRequestDescriptor instead')
const ResendVerificationRequest$json = const {
  '1': 'ResendVerificationRequest',
  '2': const [
    const {'1': 'identifier', '3': 1, '4': 1, '5': 9, '10': 'identifier'},
  ],
};

/// Descriptor for `ResendVerificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resendVerificationRequestDescriptor = $convert.base64Decode('ChlSZXNlbmRWZXJpZmljYXRpb25SZXF1ZXN0Eh4KCmlkZW50aWZpZXIYASABKAlSCmlkZW50aWZpZXI=');
@$core.Deprecated('Use resendVerificationResponseDescriptor instead')
const ResendVerificationResponse$json = const {
  '1': 'ResendVerificationResponse',
  '2': const [
    const {'1': 'sent', '3': 1, '4': 1, '5': 8, '10': 'sent'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `ResendVerificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resendVerificationResponseDescriptor = $convert.base64Decode('ChpSZXNlbmRWZXJpZmljYXRpb25SZXNwb25zZRISCgRzZW50GAEgASgIUgRzZW50EhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USHQoKZXhwaXJlc19hdBgDIAEoA1IJZXhwaXJlc0F0');
@$core.Deprecated('Use checkUsernameRequestDescriptor instead')
const CheckUsernameRequest$json = const {
  '1': 'CheckUsernameRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `CheckUsernameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkUsernameRequestDescriptor = $convert.base64Decode('ChRDaGVja1VzZXJuYW1lUmVxdWVzdBIaCgh1c2VybmFtZRgBIAEoCVIIdXNlcm5hbWU=');
@$core.Deprecated('Use checkUsernameResponseDescriptor instead')
const CheckUsernameResponse$json = const {
  '1': 'CheckUsernameResponse',
  '2': const [
    const {'1': 'available', '3': 1, '4': 1, '5': 8, '10': 'available'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'suggestions', '3': 3, '4': 3, '5': 9, '10': 'suggestions'},
  ],
};

/// Descriptor for `CheckUsernameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkUsernameResponseDescriptor = $convert.base64Decode('ChVDaGVja1VzZXJuYW1lUmVzcG9uc2USHAoJYXZhaWxhYmxlGAEgASgIUglhdmFpbGFibGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRIgCgtzdWdnZXN0aW9ucxgDIAMoCVILc3VnZ2VzdGlvbnM=');
@$core.Deprecated('Use checkEmailRequestDescriptor instead')
const CheckEmailRequest$json = const {
  '1': 'CheckEmailRequest',
  '2': const [
    const {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `CheckEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkEmailRequestDescriptor = $convert.base64Decode('ChFDaGVja0VtYWlsUmVxdWVzdBIUCgVlbWFpbBgBIAEoCVIFZW1haWw=');
@$core.Deprecated('Use checkEmailResponseDescriptor instead')
const CheckEmailResponse$json = const {
  '1': 'CheckEmailResponse',
  '2': const [
    const {'1': 'available', '3': 1, '4': 1, '5': 8, '10': 'available'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CheckEmailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkEmailResponseDescriptor = $convert.base64Decode('ChJDaGVja0VtYWlsUmVzcG9uc2USHAoJYXZhaWxhYmxlGAEgASgIUglhdmFpbGFibGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use createProfileRequestDescriptor instead')
const CreateProfileRequest$json = const {
  '1': 'CreateProfileRequest',
  '2': const [
    const {'1': 'user_uuid', '3': 1, '4': 1, '5': 9, '10': 'userUuid'},
    const {'1': 'profile_name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'profileName', '17': true},
    const {'1': 'first_name', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'firstName', '17': true},
    const {'1': 'last_name', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'lastName', '17': true},
    const {'1': 'display_name', '3': 5, '4': 1, '5': 9, '9': 3, '10': 'displayName', '17': true},
    const {'1': 'bio', '3': 6, '4': 1, '5': 9, '9': 4, '10': 'bio', '17': true},
    const {'1': 'avatar_url', '3': 7, '4': 1, '5': 9, '9': 5, '10': 'avatarUrl', '17': true},
    const {'1': 'date_of_birth', '3': 8, '4': 1, '5': 3, '9': 6, '10': 'dateOfBirth', '17': true},
    const {'1': 'gender', '3': 9, '4': 1, '5': 9, '9': 7, '10': 'gender', '17': true},
    const {'1': 'timezone', '3': 10, '4': 1, '5': 9, '9': 8, '10': 'timezone', '17': true},
    const {'1': 'locale', '3': 11, '4': 1, '5': 9, '9': 9, '10': 'locale', '17': true},
    const {'1': 'country', '3': 12, '4': 1, '5': 9, '9': 10, '10': 'country', '17': true},
    const {'1': 'city', '3': 13, '4': 1, '5': 9, '9': 11, '10': 'city', '17': true},
    const {'1': 'address', '3': 14, '4': 1, '5': 9, '9': 12, '10': 'address', '17': true},
    const {'1': 'postal_code', '3': 15, '4': 1, '5': 9, '9': 13, '10': 'postalCode', '17': true},
    const {'1': 'website_url', '3': 16, '4': 1, '5': 9, '9': 14, '10': 'websiteUrl', '17': true},
    const {'1': 'metadata', '3': 17, '4': 1, '5': 12, '10': 'metadata'},
  ],
  '8': const [
    const {'1': '_profile_name'},
    const {'1': '_first_name'},
    const {'1': '_last_name'},
    const {'1': '_display_name'},
    const {'1': '_bio'},
    const {'1': '_avatar_url'},
    const {'1': '_date_of_birth'},
    const {'1': '_gender'},
    const {'1': '_timezone'},
    const {'1': '_locale'},
    const {'1': '_country'},
    const {'1': '_city'},
    const {'1': '_address'},
    const {'1': '_postal_code'},
    const {'1': '_website_url'},
  ],
};

/// Descriptor for `CreateProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProfileRequestDescriptor = $convert.base64Decode('ChRDcmVhdGVQcm9maWxlUmVxdWVzdBIbCgl1c2VyX3V1aWQYASABKAlSCHVzZXJVdWlkEiYKDHByb2ZpbGVfbmFtZRgCIAEoCUgAUgtwcm9maWxlTmFtZYgBARIiCgpmaXJzdF9uYW1lGAMgASgJSAFSCWZpcnN0TmFtZYgBARIgCglsYXN0X25hbWUYBCABKAlIAlIIbGFzdE5hbWWIAQESJgoMZGlzcGxheV9uYW1lGAUgASgJSANSC2Rpc3BsYXlOYW1liAEBEhUKA2JpbxgGIAEoCUgEUgNiaW+IAQESIgoKYXZhdGFyX3VybBgHIAEoCUgFUglhdmF0YXJVcmyIAQESJwoNZGF0ZV9vZl9iaXJ0aBgIIAEoA0gGUgtkYXRlT2ZCaXJ0aIgBARIbCgZnZW5kZXIYCSABKAlIB1IGZ2VuZGVyiAEBEh8KCHRpbWV6b25lGAogASgJSAhSCHRpbWV6b25liAEBEhsKBmxvY2FsZRgLIAEoCUgJUgZsb2NhbGWIAQESHQoHY291bnRyeRgMIAEoCUgKUgdjb3VudHJ5iAEBEhcKBGNpdHkYDSABKAlIC1IEY2l0eYgBARIdCgdhZGRyZXNzGA4gASgJSAxSB2FkZHJlc3OIAQESJAoLcG9zdGFsX2NvZGUYDyABKAlIDVIKcG9zdGFsQ29kZYgBARIkCgt3ZWJzaXRlX3VybBgQIAEoCUgOUgp3ZWJzaXRlVXJsiAEBEhoKCG1ldGFkYXRhGBEgASgMUghtZXRhZGF0YUIPCg1fcHJvZmlsZV9uYW1lQg0KC19maXJzdF9uYW1lQgwKCl9sYXN0X25hbWVCDwoNX2Rpc3BsYXlfbmFtZUIGCgRfYmlvQg0KC19hdmF0YXJfdXJsQhAKDl9kYXRlX29mX2JpcnRoQgkKB19nZW5kZXJCCwoJX3RpbWV6b25lQgkKB19sb2NhbGVCCgoIX2NvdW50cnlCBwoFX2NpdHlCCgoIX2FkZHJlc3NCDgoMX3Bvc3RhbF9jb2RlQg4KDF93ZWJzaXRlX3VybA==');
@$core.Deprecated('Use createProfileResponseDescriptor instead')
const CreateProfileResponse$json = const {
  '1': 'CreateProfileResponse',
  '2': const [
    const {'1': 'profile', '3': 1, '4': 1, '5': 11, '6': '.v1.UserProfile', '10': 'profile'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CreateProfileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProfileResponseDescriptor = $convert.base64Decode('ChVDcmVhdGVQcm9maWxlUmVzcG9uc2USKQoHcHJvZmlsZRgBIAEoCzIPLnYxLlVzZXJQcm9maWxlUgdwcm9maWxlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use listUserProfilesRequestDescriptor instead')
const ListUserProfilesRequest$json = const {
  '1': 'ListUserProfilesRequest',
  '2': const [
    const {'1': 'user_uuid', '3': 1, '4': 1, '5': 9, '10': 'userUuid'},
    const {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListUserProfilesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserProfilesRequestDescriptor = $convert.base64Decode('ChdMaXN0VXNlclByb2ZpbGVzUmVxdWVzdBIbCgl1c2VyX3V1aWQYASABKAlSCHVzZXJVdWlkEhQKBWxpbWl0GAIgASgFUgVsaW1pdBIWCgZvZmZzZXQYAyABKAVSBm9mZnNldA==');
@$core.Deprecated('Use listUserProfilesResponseDescriptor instead')
const ListUserProfilesResponse$json = const {
  '1': 'ListUserProfilesResponse',
  '2': const [
    const {'1': 'profiles', '3': 1, '4': 3, '5': 11, '6': '.v1.UserProfile', '10': 'profiles'},
    const {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
    const {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
    const {'1': 'has_more', '3': 5, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListUserProfilesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserProfilesResponseDescriptor = $convert.base64Decode('ChhMaXN0VXNlclByb2ZpbGVzUmVzcG9uc2USKwoIcHJvZmlsZXMYASADKAsyDy52MS5Vc2VyUHJvZmlsZVIIcHJvZmlsZXMSHwoLdG90YWxfY291bnQYAiABKAVSCnRvdGFsQ291bnQSFAoFbGltaXQYAyABKAVSBWxpbWl0EhYKBm9mZnNldBgEIAEoBVIGb2Zmc2V0EhkKCGhhc19tb3JlGAUgASgIUgdoYXNNb3Jl');
@$core.Deprecated('Use updateProfileRequestDescriptor instead')
const UpdateProfileRequest$json = const {
  '1': 'UpdateProfileRequest',
  '2': const [
    const {'1': 'profile_uuid', '3': 1, '4': 1, '5': 9, '10': 'profileUuid'},
    const {'1': 'profile_name', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'profileName', '17': true},
    const {'1': 'first_name', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'firstName', '17': true},
    const {'1': 'last_name', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'lastName', '17': true},
    const {'1': 'display_name', '3': 5, '4': 1, '5': 9, '9': 3, '10': 'displayName', '17': true},
    const {'1': 'bio', '3': 6, '4': 1, '5': 9, '9': 4, '10': 'bio', '17': true},
    const {'1': 'avatar_url', '3': 7, '4': 1, '5': 9, '9': 5, '10': 'avatarUrl', '17': true},
    const {'1': 'date_of_birth', '3': 8, '4': 1, '5': 3, '9': 6, '10': 'dateOfBirth', '17': true},
    const {'1': 'gender', '3': 9, '4': 1, '5': 9, '9': 7, '10': 'gender', '17': true},
    const {'1': 'timezone', '3': 10, '4': 1, '5': 9, '9': 8, '10': 'timezone', '17': true},
    const {'1': 'locale', '3': 11, '4': 1, '5': 9, '9': 9, '10': 'locale', '17': true},
    const {'1': 'country', '3': 12, '4': 1, '5': 9, '9': 10, '10': 'country', '17': true},
    const {'1': 'city', '3': 13, '4': 1, '5': 9, '9': 11, '10': 'city', '17': true},
    const {'1': 'address', '3': 14, '4': 1, '5': 9, '9': 12, '10': 'address', '17': true},
    const {'1': 'postal_code', '3': 15, '4': 1, '5': 9, '9': 13, '10': 'postalCode', '17': true},
    const {'1': 'website_url', '3': 16, '4': 1, '5': 9, '9': 14, '10': 'websiteUrl', '17': true},
    const {'1': 'metadata', '3': 17, '4': 1, '5': 12, '10': 'metadata'},
  ],
  '8': const [
    const {'1': '_profile_name'},
    const {'1': '_first_name'},
    const {'1': '_last_name'},
    const {'1': '_display_name'},
    const {'1': '_bio'},
    const {'1': '_avatar_url'},
    const {'1': '_date_of_birth'},
    const {'1': '_gender'},
    const {'1': '_timezone'},
    const {'1': '_locale'},
    const {'1': '_country'},
    const {'1': '_city'},
    const {'1': '_address'},
    const {'1': '_postal_code'},
    const {'1': '_website_url'},
  ],
};

/// Descriptor for `UpdateProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProfileRequestDescriptor = $convert.base64Decode('ChRVcGRhdGVQcm9maWxlUmVxdWVzdBIhCgxwcm9maWxlX3V1aWQYASABKAlSC3Byb2ZpbGVVdWlkEiYKDHByb2ZpbGVfbmFtZRgCIAEoCUgAUgtwcm9maWxlTmFtZYgBARIiCgpmaXJzdF9uYW1lGAMgASgJSAFSCWZpcnN0TmFtZYgBARIgCglsYXN0X25hbWUYBCABKAlIAlIIbGFzdE5hbWWIAQESJgoMZGlzcGxheV9uYW1lGAUgASgJSANSC2Rpc3BsYXlOYW1liAEBEhUKA2JpbxgGIAEoCUgEUgNiaW+IAQESIgoKYXZhdGFyX3VybBgHIAEoCUgFUglhdmF0YXJVcmyIAQESJwoNZGF0ZV9vZl9iaXJ0aBgIIAEoA0gGUgtkYXRlT2ZCaXJ0aIgBARIbCgZnZW5kZXIYCSABKAlIB1IGZ2VuZGVyiAEBEh8KCHRpbWV6b25lGAogASgJSAhSCHRpbWV6b25liAEBEhsKBmxvY2FsZRgLIAEoCUgJUgZsb2NhbGWIAQESHQoHY291bnRyeRgMIAEoCUgKUgdjb3VudHJ5iAEBEhcKBGNpdHkYDSABKAlIC1IEY2l0eYgBARIdCgdhZGRyZXNzGA4gASgJSAxSB2FkZHJlc3OIAQESJAoLcG9zdGFsX2NvZGUYDyABKAlIDVIKcG9zdGFsQ29kZYgBARIkCgt3ZWJzaXRlX3VybBgQIAEoCUgOUgp3ZWJzaXRlVXJsiAEBEhoKCG1ldGFkYXRhGBEgASgMUghtZXRhZGF0YUIPCg1fcHJvZmlsZV9uYW1lQg0KC19maXJzdF9uYW1lQgwKCl9sYXN0X25hbWVCDwoNX2Rpc3BsYXlfbmFtZUIGCgRfYmlvQg0KC19hdmF0YXJfdXJsQhAKDl9kYXRlX29mX2JpcnRoQgkKB19nZW5kZXJCCwoJX3RpbWV6b25lQgkKB19sb2NhbGVCCgoIX2NvdW50cnlCBwoFX2NpdHlCCgoIX2FkZHJlc3NCDgoMX3Bvc3RhbF9jb2RlQg4KDF93ZWJzaXRlX3VybA==');
@$core.Deprecated('Use updateProfileResponseDescriptor instead')
const UpdateProfileResponse$json = const {
  '1': 'UpdateProfileResponse',
  '2': const [
    const {'1': 'profile', '3': 1, '4': 1, '5': 11, '6': '.v1.UserProfile', '10': 'profile'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UpdateProfileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProfileResponseDescriptor = $convert.base64Decode('ChVVcGRhdGVQcm9maWxlUmVzcG9uc2USKQoHcHJvZmlsZRgBIAEoCzIPLnYxLlVzZXJQcm9maWxlUgdwcm9maWxlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use deleteProfileRequestDescriptor instead')
const DeleteProfileRequest$json = const {
  '1': 'DeleteProfileRequest',
  '2': const [
    const {'1': 'profile_uuid', '3': 1, '4': 1, '5': 9, '10': 'profileUuid'},
  ],
};

/// Descriptor for `DeleteProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProfileRequestDescriptor = $convert.base64Decode('ChREZWxldGVQcm9maWxlUmVxdWVzdBIhCgxwcm9maWxlX3V1aWQYASABKAlSC3Byb2ZpbGVVdWlk');
@$core.Deprecated('Use deleteProfileResponseDescriptor instead')
const DeleteProfileResponse$json = const {
  '1': 'DeleteProfileResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteProfileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProfileResponseDescriptor = $convert.base64Decode('ChVEZWxldGVQcm9maWxlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use getUserRequestDescriptor instead')
const GetUserRequest$json = const {
  '1': 'GetUserRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '9': 0, '10': 'id'},
    const {'1': 'uuid', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'uuid'},
    const {'1': 'username', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'username'},
    const {'1': 'email', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'email'},
    const {'1': 'include_profile', '3': 5, '4': 1, '5': 8, '10': 'includeProfile'},
  ],
  '8': const [
    const {'1': 'identifier'},
  ],
};

/// Descriptor for `GetUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRequestDescriptor = $convert.base64Decode('Cg5HZXRVc2VyUmVxdWVzdBIQCgJpZBgBIAEoA0gAUgJpZBIUCgR1dWlkGAIgASgJSABSBHV1aWQSHAoIdXNlcm5hbWUYAyABKAlIAFIIdXNlcm5hbWUSFgoFZW1haWwYBCABKAlIAFIFZW1haWwSJwoPaW5jbHVkZV9wcm9maWxlGAUgASgIUg5pbmNsdWRlUHJvZmlsZUIMCgppZGVudGlmaWVy');
@$core.Deprecated('Use getUserResponseDescriptor instead')
const GetUserResponse$json = const {
  '1': 'GetUserResponse',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
    const {'1': 'profile', '3': 2, '4': 1, '5': 11, '6': '.v1.UserProfile', '9': 0, '10': 'profile', '17': true},
  ],
  '8': const [
    const {'1': '_profile'},
  ],
};

/// Descriptor for `GetUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserResponseDescriptor = $convert.base64Decode('Cg9HZXRVc2VyUmVzcG9uc2USHAoEdXNlchgBIAEoCzIILnYxLlVzZXJSBHVzZXISLgoHcHJvZmlsZRgCIAEoCzIPLnYxLlVzZXJQcm9maWxlSABSB3Byb2ZpbGWIAQFCCgoIX3Byb2ZpbGU=');
@$core.Deprecated('Use updateUserRequestDescriptor instead')
const UpdateUserRequest$json = const {
  '1': 'UpdateUserRequest',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'username', '17': true},
    const {'1': 'email', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'email', '17': true},
    const {'1': 'phone', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'phone', '17': true},
    const {'1': 'is_active', '3': 5, '4': 1, '5': 8, '9': 3, '10': 'isActive', '17': true},
    const {'1': 'first_name', '3': 6, '4': 1, '5': 9, '9': 4, '10': 'firstName', '17': true},
    const {'1': 'last_name', '3': 7, '4': 1, '5': 9, '9': 5, '10': 'lastName', '17': true},
    const {'1': 'display_name', '3': 8, '4': 1, '5': 9, '9': 6, '10': 'displayName', '17': true},
    const {'1': 'bio', '3': 9, '4': 1, '5': 9, '9': 7, '10': 'bio', '17': true},
    const {'1': 'avatar_url', '3': 10, '4': 1, '5': 9, '9': 8, '10': 'avatarUrl', '17': true},
    const {'1': 'timezone', '3': 11, '4': 1, '5': 9, '9': 9, '10': 'timezone', '17': true},
    const {'1': 'locale', '3': 12, '4': 1, '5': 9, '9': 10, '10': 'locale', '17': true},
    const {'1': 'country', '3': 13, '4': 1, '5': 9, '9': 11, '10': 'country', '17': true},
    const {'1': 'city', '3': 14, '4': 1, '5': 9, '9': 12, '10': 'city', '17': true},
    const {'1': 'address', '3': 15, '4': 1, '5': 9, '9': 13, '10': 'address', '17': true},
    const {'1': 'postal_code', '3': 16, '4': 1, '5': 9, '9': 14, '10': 'postalCode', '17': true},
    const {'1': 'website_url', '3': 17, '4': 1, '5': 9, '9': 15, '10': 'websiteUrl', '17': true},
  ],
  '8': const [
    const {'1': '_username'},
    const {'1': '_email'},
    const {'1': '_phone'},
    const {'1': '_is_active'},
    const {'1': '_first_name'},
    const {'1': '_last_name'},
    const {'1': '_display_name'},
    const {'1': '_bio'},
    const {'1': '_avatar_url'},
    const {'1': '_timezone'},
    const {'1': '_locale'},
    const {'1': '_country'},
    const {'1': '_city'},
    const {'1': '_address'},
    const {'1': '_postal_code'},
    const {'1': '_website_url'},
  ],
};

/// Descriptor for `UpdateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserRequestDescriptor = $convert.base64Decode('ChFVcGRhdGVVc2VyUmVxdWVzdBISCgR1dWlkGAEgASgJUgR1dWlkEh8KCHVzZXJuYW1lGAIgASgJSABSCHVzZXJuYW1liAEBEhkKBWVtYWlsGAMgASgJSAFSBWVtYWlsiAEBEhkKBXBob25lGAQgASgJSAJSBXBob25liAEBEiAKCWlzX2FjdGl2ZRgFIAEoCEgDUghpc0FjdGl2ZYgBARIiCgpmaXJzdF9uYW1lGAYgASgJSARSCWZpcnN0TmFtZYgBARIgCglsYXN0X25hbWUYByABKAlIBVIIbGFzdE5hbWWIAQESJgoMZGlzcGxheV9uYW1lGAggASgJSAZSC2Rpc3BsYXlOYW1liAEBEhUKA2JpbxgJIAEoCUgHUgNiaW+IAQESIgoKYXZhdGFyX3VybBgKIAEoCUgIUglhdmF0YXJVcmyIAQESHwoIdGltZXpvbmUYCyABKAlICVIIdGltZXpvbmWIAQESGwoGbG9jYWxlGAwgASgJSApSBmxvY2FsZYgBARIdCgdjb3VudHJ5GA0gASgJSAtSB2NvdW50cnmIAQESFwoEY2l0eRgOIAEoCUgMUgRjaXR5iAEBEh0KB2FkZHJlc3MYDyABKAlIDVIHYWRkcmVzc4gBARIkCgtwb3N0YWxfY29kZRgQIAEoCUgOUgpwb3N0YWxDb2RliAEBEiQKC3dlYnNpdGVfdXJsGBEgASgJSA9SCndlYnNpdGVVcmyIAQFCCwoJX3VzZXJuYW1lQggKBl9lbWFpbEIICgZfcGhvbmVCDAoKX2lzX2FjdGl2ZUINCgtfZmlyc3RfbmFtZUIMCgpfbGFzdF9uYW1lQg8KDV9kaXNwbGF5X25hbWVCBgoEX2Jpb0INCgtfYXZhdGFyX3VybEILCglfdGltZXpvbmVCCQoHX2xvY2FsZUIKCghfY291bnRyeUIHCgVfY2l0eUIKCghfYWRkcmVzc0IOCgxfcG9zdGFsX2NvZGVCDgoMX3dlYnNpdGVfdXJs');
@$core.Deprecated('Use updateUserResponseDescriptor instead')
const UpdateUserResponse$json = const {
  '1': 'UpdateUserResponse',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
    const {'1': 'profile', '3': 2, '4': 1, '5': 11, '6': '.v1.UserProfile', '10': 'profile'},
  ],
};

/// Descriptor for `UpdateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserResponseDescriptor = $convert.base64Decode('ChJVcGRhdGVVc2VyUmVzcG9uc2USHAoEdXNlchgBIAEoCzIILnYxLlVzZXJSBHVzZXISKQoHcHJvZmlsZRgCIAEoCzIPLnYxLlVzZXJQcm9maWxlUgdwcm9maWxl');
@$core.Deprecated('Use changePasswordRequestDescriptor instead')
const ChangePasswordRequest$json = const {
  '1': 'ChangePasswordRequest',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'current_password', '3': 2, '4': 1, '5': 9, '10': 'currentPassword'},
    const {'1': 'new_password', '3': 3, '4': 1, '5': 9, '10': 'newPassword'},
  ],
};

/// Descriptor for `ChangePasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordRequestDescriptor = $convert.base64Decode('ChVDaGFuZ2VQYXNzd29yZFJlcXVlc3QSEgoEdXVpZBgBIAEoCVIEdXVpZBIpChBjdXJyZW50X3Bhc3N3b3JkGAIgASgJUg9jdXJyZW50UGFzc3dvcmQSIQoMbmV3X3Bhc3N3b3JkGAMgASgJUgtuZXdQYXNzd29yZA==');
@$core.Deprecated('Use changePasswordResponseDescriptor instead')
const ChangePasswordResponse$json = const {
  '1': 'ChangePasswordResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ChangePasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordResponseDescriptor = $convert.base64Decode('ChZDaGFuZ2VQYXNzd29yZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use listUsersRequestDescriptor instead')
const ListUsersRequest$json = const {
  '1': 'ListUsersRequest',
  '2': const [
    const {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
    const {'1': 'search', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    const {'1': 'is_active', '3': 4, '4': 1, '5': 8, '9': 1, '10': 'isActive', '17': true},
    const {'1': 'email_verified', '3': 5, '4': 1, '5': 8, '9': 2, '10': 'emailVerified', '17': true},
    const {'1': 'phone_verified', '3': 6, '4': 1, '5': 8, '9': 3, '10': 'phoneVerified', '17': true},
    const {'1': 'sort_by', '3': 7, '4': 1, '5': 9, '9': 4, '10': 'sortBy', '17': true},
    const {'1': 'sort_order', '3': 8, '4': 1, '5': 9, '9': 5, '10': 'sortOrder', '17': true},
  ],
  '8': const [
    const {'1': '_search'},
    const {'1': '_is_active'},
    const {'1': '_email_verified'},
    const {'1': '_phone_verified'},
    const {'1': '_sort_by'},
    const {'1': '_sort_order'},
  ],
};

/// Descriptor for `ListUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersRequestDescriptor = $convert.base64Decode('ChBMaXN0VXNlcnNSZXF1ZXN0EhQKBWxpbWl0GAEgASgFUgVsaW1pdBIWCgZvZmZzZXQYAiABKAVSBm9mZnNldBIbCgZzZWFyY2gYAyABKAlIAFIGc2VhcmNoiAEBEiAKCWlzX2FjdGl2ZRgEIAEoCEgBUghpc0FjdGl2ZYgBARIqCg5lbWFpbF92ZXJpZmllZBgFIAEoCEgCUg1lbWFpbFZlcmlmaWVkiAEBEioKDnBob25lX3ZlcmlmaWVkGAYgASgISANSDXBob25lVmVyaWZpZWSIAQESHAoHc29ydF9ieRgHIAEoCUgEUgZzb3J0QnmIAQESIgoKc29ydF9vcmRlchgIIAEoCUgFUglzb3J0T3JkZXKIAQFCCQoHX3NlYXJjaEIMCgpfaXNfYWN0aXZlQhEKD19lbWFpbF92ZXJpZmllZEIRCg9fcGhvbmVfdmVyaWZpZWRCCgoIX3NvcnRfYnlCDQoLX3NvcnRfb3JkZXI=');
@$core.Deprecated('Use listUsersResponseDescriptor instead')
const ListUsersResponse$json = const {
  '1': 'ListUsersResponse',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.v1.User', '10': 'users'},
    const {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
    const {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
    const {'1': 'has_more', '3': 5, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ListUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersResponseDescriptor = $convert.base64Decode('ChFMaXN0VXNlcnNSZXNwb25zZRIeCgV1c2VycxgBIAMoCzIILnYxLlVzZXJSBXVzZXJzEh8KC3RvdGFsX2NvdW50GAIgASgFUgp0b3RhbENvdW50EhQKBWxpbWl0GAMgASgFUgVsaW1pdBIWCgZvZmZzZXQYBCABKAVSBm9mZnNldBIZCghoYXNfbW9yZRgFIAEoCFIHaGFzTW9yZQ==');
@$core.Deprecated('Use deleteUserRequestDescriptor instead')
const DeleteUserRequest$json = const {
  '1': 'DeleteUserRequest',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'soft_delete', '3': 2, '4': 1, '5': 8, '10': 'softDelete'},
  ],
};

/// Descriptor for `DeleteUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserRequestDescriptor = $convert.base64Decode('ChFEZWxldGVVc2VyUmVxdWVzdBISCgR1dWlkGAEgASgJUgR1dWlkEh8KC3NvZnRfZGVsZXRlGAIgASgIUgpzb2Z0RGVsZXRl');
@$core.Deprecated('Use deleteUserResponseDescriptor instead')
const DeleteUserResponse$json = const {
  '1': 'DeleteUserResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserResponseDescriptor = $convert.base64Decode('ChJEZWxldGVVc2VyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use signInRequestDescriptor instead')
const SignInRequest$json = const {
  '1': 'SignInRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    const {'1': 'device_id', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'deviceId', '17': true},
    const {'1': 'device_name', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'deviceName', '17': true},
    const {'1': 'device_type', '3': 5, '4': 1, '5': 9, '9': 2, '10': 'deviceType', '17': true},
    const {'1': 'remember_me', '3': 6, '4': 1, '5': 8, '9': 3, '10': 'rememberMe', '17': true},
  ],
  '8': const [
    const {'1': '_device_id'},
    const {'1': '_device_name'},
    const {'1': '_device_type'},
    const {'1': '_remember_me'},
  ],
};

/// Descriptor for `SignInRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signInRequestDescriptor = $convert.base64Decode('Cg1TaWduSW5SZXF1ZXN0EhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIaCghwYXNzd29yZBgCIAEoCVIIcGFzc3dvcmQSIAoJZGV2aWNlX2lkGAMgASgJSABSCGRldmljZUlkiAEBEiQKC2RldmljZV9uYW1lGAQgASgJSAFSCmRldmljZU5hbWWIAQESJAoLZGV2aWNlX3R5cGUYBSABKAlIAlIKZGV2aWNlVHlwZYgBARIkCgtyZW1lbWJlcl9tZRgGIAEoCEgDUgpyZW1lbWJlck1liAEBQgwKCl9kZXZpY2VfaWRCDgoMX2RldmljZV9uYW1lQg4KDF9kZXZpY2VfdHlwZUIOCgxfcmVtZW1iZXJfbWU=');
@$core.Deprecated('Use signInResponseDescriptor instead')
const SignInResponse$json = const {
  '1': 'SignInResponse',
  '2': const [
    const {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    const {'1': 'refresh_token', '3': 2, '4': 1, '5': 9, '10': 'refreshToken'},
    const {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '10': 'expiresAt'},
    const {'1': 'refresh_expires_at', '3': 4, '4': 1, '5': 3, '10': 'refreshExpiresAt'},
    const {'1': 'user', '3': 5, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
    const {'1': 'profile', '3': 6, '4': 1, '5': 11, '6': '.v1.UserProfile', '10': 'profile'},
    const {'1': 'session_id', '3': 7, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'message', '3': 8, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SignInResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signInResponseDescriptor = $convert.base64Decode('Cg5TaWduSW5SZXNwb25zZRIhCgxhY2Nlc3NfdG9rZW4YASABKAlSC2FjY2Vzc1Rva2VuEiMKDXJlZnJlc2hfdG9rZW4YAiABKAlSDHJlZnJlc2hUb2tlbhIdCgpleHBpcmVzX2F0GAMgASgDUglleHBpcmVzQXQSLAoScmVmcmVzaF9leHBpcmVzX2F0GAQgASgDUhByZWZyZXNoRXhwaXJlc0F0EhwKBHVzZXIYBSABKAsyCC52MS5Vc2VyUgR1c2VyEikKB3Byb2ZpbGUYBiABKAsyDy52MS5Vc2VyUHJvZmlsZVIHcHJvZmlsZRIdCgpzZXNzaW9uX2lkGAcgASgJUglzZXNzaW9uSWQSGAoHbWVzc2FnZRgIIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use refreshTokenRequestDescriptor instead')
const RefreshTokenRequest$json = const {
  '1': 'RefreshTokenRequest',
  '2': const [
    const {'1': 'refresh_token', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
    const {'1': 'device_id', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'deviceId', '17': true},
  ],
  '8': const [
    const {'1': '_device_id'},
  ],
};

/// Descriptor for `RefreshTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshTokenRequestDescriptor = $convert.base64Decode('ChNSZWZyZXNoVG9rZW5SZXF1ZXN0EiMKDXJlZnJlc2hfdG9rZW4YASABKAlSDHJlZnJlc2hUb2tlbhIgCglkZXZpY2VfaWQYAiABKAlIAFIIZGV2aWNlSWSIAQFCDAoKX2RldmljZV9pZA==');
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
    const {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
    const {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListUserSessionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserSessionsResponseDescriptor = $convert.base64Decode('ChhMaXN0VXNlclNlc3Npb25zUmVzcG9uc2USJwoIc2Vzc2lvbnMYASADKAsyCy52MS5TZXNzaW9uUghzZXNzaW9ucxIfCgt0b3RhbF9jb3VudBgCIAEoBVIKdG90YWxDb3VudBIUCgVsaW1pdBgDIAEoBVIFbGltaXQSFgoGb2Zmc2V0GAQgASgFUgZvZmZzZXQ=');
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
