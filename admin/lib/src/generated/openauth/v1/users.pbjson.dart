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
    const {'1': 'name', '3': 6, '4': 1, '5': 9, '9': 2, '10': 'name', '17': true},
    const {'1': 'avatar_url', '3': 7, '4': 1, '5': 9, '9': 3, '10': 'avatarUrl', '17': true},
    const {'1': 'email_verified', '3': 8, '4': 1, '5': 8, '10': 'emailVerified'},
    const {'1': 'phone_verified', '3': 9, '4': 1, '5': 8, '10': 'phoneVerified'},
    const {'1': 'deactivated', '3': 10, '4': 1, '5': 8, '10': 'deactivated'},
    const {'1': 'is_active', '3': 11, '4': 1, '5': 8, '10': 'isActive'},
    const {'1': 'is_locked', '3': 12, '4': 1, '5': 8, '10': 'isLocked'},
    const {'1': 'failed_login_attempts', '3': 13, '4': 1, '5': 5, '10': 'failedLoginAttempts'},
    const {'1': 'last_login_at', '3': 14, '4': 1, '5': 3, '9': 4, '10': 'lastLoginAt', '17': true},
    const {'1': 'password_changed_at', '3': 15, '4': 1, '5': 3, '10': 'passwordChangedAt'},
    const {'1': 'created_at', '3': 16, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 17, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '8': const [
    const {'1': '_email'},
    const {'1': '_phone'},
    const {'1': '_name'},
    const {'1': '_avatar_url'},
    const {'1': '_last_login_at'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode('CgRVc2VyEg4KAmlkGAEgASgDUgJpZBISCgR1dWlkGAIgASgJUgR1dWlkEhoKCHVzZXJuYW1lGAMgASgJUgh1c2VybmFtZRIZCgVlbWFpbBgEIAEoCUgAUgVlbWFpbIgBARIZCgVwaG9uZRgFIAEoCUgBUgVwaG9uZYgBARIXCgRuYW1lGAYgASgJSAJSBG5hbWWIAQESIgoKYXZhdGFyX3VybBgHIAEoCUgDUglhdmF0YXJVcmyIAQESJQoOZW1haWxfdmVyaWZpZWQYCCABKAhSDWVtYWlsVmVyaWZpZWQSJQoOcGhvbmVfdmVyaWZpZWQYCSABKAhSDXBob25lVmVyaWZpZWQSIAoLZGVhY3RpdmF0ZWQYCiABKAhSC2RlYWN0aXZhdGVkEhsKCWlzX2FjdGl2ZRgLIAEoCFIIaXNBY3RpdmUSGwoJaXNfbG9ja2VkGAwgASgIUghpc0xvY2tlZBIyChVmYWlsZWRfbG9naW5fYXR0ZW1wdHMYDSABKAVSE2ZhaWxlZExvZ2luQXR0ZW1wdHMSJwoNbGFzdF9sb2dpbl9hdBgOIAEoA0gEUgtsYXN0TG9naW5BdIgBARIuChNwYXNzd29yZF9jaGFuZ2VkX2F0GA8gASgDUhFwYXNzd29yZENoYW5nZWRBdBIdCgpjcmVhdGVkX2F0GBAgASgDUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgRIAEoA1IJdXBkYXRlZEF0QggKBl9lbWFpbEIICgZfcGhvbmVCBwoFX25hbWVCDQoLX2F2YXRhcl91cmxCEAoOX2xhc3RfbG9naW5fYXQ=');
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
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '9': 2, '10': 'name', '17': true},
  ],
  '8': const [
    const {'1': '_email'},
    const {'1': '_phone'},
    const {'1': '_name'},
  ],
};

/// Descriptor for `SignUpRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signUpRequestDescriptor = $convert.base64Decode('Cg1TaWduVXBSZXF1ZXN0EhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIZCgVlbWFpbBgCIAEoCUgAUgVlbWFpbIgBARIZCgVwaG9uZRgDIAEoCUgBUgVwaG9uZYgBARIaCghwYXNzd29yZBgEIAEoCVIIcGFzc3dvcmQSFwoEbmFtZRgFIAEoCUgCUgRuYW1liAEBQggKBl9lbWFpbEIICgZfcGhvbmVCBwoFX25hbWU=');
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
@$core.Deprecated('Use sendVerificationCodeRequestDescriptor instead')
const SendVerificationCodeRequest$json = const {
  '1': 'SendVerificationCodeRequest',
  '2': const [
    const {'1': 'identifier', '3': 1, '4': 1, '5': 9, '10': 'identifier'},
  ],
};

/// Descriptor for `SendVerificationCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerificationCodeRequestDescriptor = $convert.base64Decode('ChtTZW5kVmVyaWZpY2F0aW9uQ29kZVJlcXVlc3QSHgoKaWRlbnRpZmllchgBIAEoCVIKaWRlbnRpZmllcg==');
@$core.Deprecated('Use sendVerificationCodeResponseDescriptor instead')
const SendVerificationCodeResponse$json = const {
  '1': 'SendVerificationCodeResponse',
  '2': const [
    const {'1': 'sent', '3': 1, '4': 1, '5': 8, '10': 'sent'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '10': 'expiresAt'},
    const {'1': 'resend_after', '3': 4, '4': 1, '5': 3, '10': 'resendAfter'},
    const {'1': 'id', '3': 5, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `SendVerificationCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerificationCodeResponseDescriptor = $convert.base64Decode('ChxTZW5kVmVyaWZpY2F0aW9uQ29kZVJlc3BvbnNlEhIKBHNlbnQYASABKAhSBHNlbnQSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRIdCgpleHBpcmVzX2F0GAMgASgDUglleHBpcmVzQXQSIQoMcmVzZW5kX2FmdGVyGAQgASgDUgtyZXNlbmRBZnRlchIOCgJpZBgFIAEoA1ICaWQ=');
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
    const {'1': 'include_profile', '3': 3, '4': 1, '5': 8, '10': 'includeProfile'},
  ],
  '8': const [
    const {'1': 'identifier'},
  ],
};

/// Descriptor for `GetUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRequestDescriptor = $convert.base64Decode('Cg5HZXRVc2VyUmVxdWVzdBIQCgJpZBgBIAEoA0gAUgJpZBIUCgR1dWlkGAIgASgJSABSBHV1aWQSJwoPaW5jbHVkZV9wcm9maWxlGAMgASgIUg5pbmNsdWRlUHJvZmlsZUIMCgppZGVudGlmaWVy');
@$core.Deprecated('Use getUserResponseDescriptor instead')
const GetUserResponse$json = const {
  '1': 'GetUserResponse',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
    const {'1': 'profiles', '3': 2, '4': 3, '5': 11, '6': '.v1.UserProfile', '10': 'profiles'},
  ],
};

/// Descriptor for `GetUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserResponseDescriptor = $convert.base64Decode('Cg9HZXRVc2VyUmVzcG9uc2USHAoEdXNlchgBIAEoCzIILnYxLlVzZXJSBHVzZXISKwoIcHJvZmlsZXMYAiADKAsyDy52MS5Vc2VyUHJvZmlsZVIIcHJvZmlsZXM=');
@$core.Deprecated('Use updateUserRequestDescriptor instead')
const UpdateUserRequest$json = const {
  '1': 'UpdateUserRequest',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 9, '10': 'uuid'},
    const {'1': 'username', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'username', '17': true},
    const {'1': 'email', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'email', '17': true},
    const {'1': 'phone', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'phone', '17': true},
    const {'1': 'is_active', '3': 5, '4': 1, '5': 8, '9': 3, '10': 'isActive', '17': true},
    const {'1': 'name', '3': 6, '4': 1, '5': 9, '9': 4, '10': 'name', '17': true},
    const {'1': 'avatar_url', '3': 7, '4': 1, '5': 9, '9': 5, '10': 'avatarUrl', '17': true},
  ],
  '8': const [
    const {'1': '_username'},
    const {'1': '_email'},
    const {'1': '_phone'},
    const {'1': '_is_active'},
    const {'1': '_name'},
    const {'1': '_avatar_url'},
  ],
};

/// Descriptor for `UpdateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserRequestDescriptor = $convert.base64Decode('ChFVcGRhdGVVc2VyUmVxdWVzdBISCgR1dWlkGAEgASgJUgR1dWlkEh8KCHVzZXJuYW1lGAIgASgJSABSCHVzZXJuYW1liAEBEhkKBWVtYWlsGAMgASgJSAFSBWVtYWlsiAEBEhkKBXBob25lGAQgASgJSAJSBXBob25liAEBEiAKCWlzX2FjdGl2ZRgFIAEoCEgDUghpc0FjdGl2ZYgBARIXCgRuYW1lGAYgASgJSARSBG5hbWWIAQESIgoKYXZhdGFyX3VybBgHIAEoCUgFUglhdmF0YXJVcmyIAQFCCwoJX3VzZXJuYW1lQggKBl9lbWFpbEIICgZfcGhvbmVCDAoKX2lzX2FjdGl2ZUIHCgVfbmFtZUINCgtfYXZhdGFyX3VybA==');
@$core.Deprecated('Use updateUserResponseDescriptor instead')
const UpdateUserResponse$json = const {
  '1': 'UpdateUserResponse',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.v1.User', '10': 'user'},
  ],
};

/// Descriptor for `UpdateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserResponseDescriptor = $convert.base64Decode('ChJVcGRhdGVVc2VyUmVzcG9uc2USHAoEdXNlchgBIAEoCzIILnYxLlVzZXJSBHVzZXI=');
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
  ],
  '8': const [
    const {'1': '_search'},
  ],
};

/// Descriptor for `ListUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersRequestDescriptor = $convert.base64Decode('ChBMaXN0VXNlcnNSZXF1ZXN0EhQKBWxpbWl0GAEgASgFUgVsaW1pdBIWCgZvZmZzZXQYAiABKAVSBm9mZnNldBIbCgZzZWFyY2gYAyABKAlIAFIGc2VhcmNoiAEBQgkKB19zZWFyY2g=');
@$core.Deprecated('Use listUsersResponseDescriptor instead')
const ListUsersResponse$json = const {
  '1': 'ListUsersResponse',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.v1.User', '10': 'users'},
  ],
};

/// Descriptor for `ListUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersResponseDescriptor = $convert.base64Decode('ChFMaXN0VXNlcnNSZXNwb25zZRIeCgV1c2VycxgBIAMoCzIILnYxLlVzZXJSBXVzZXJz');
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
