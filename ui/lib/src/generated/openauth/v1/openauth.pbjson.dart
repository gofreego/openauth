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
import 'users.pbjson.dart' as $2;

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
    {
      '1': 'SignUp',
      '2': '.v1.SignUpRequest',
      '3': '.v1.SignUpResponse',
      '4': {}
    },
    {
      '1': 'VerifyEmail',
      '2': '.v1.VerifyEmailRequest',
      '3': '.v1.VerificationResponse',
      '4': {}
    },
    {
      '1': 'VerifyPhone',
      '2': '.v1.VerifyPhoneRequest',
      '3': '.v1.VerificationResponse',
      '4': {}
    },
    {
      '1': 'ResendVerification',
      '2': '.v1.ResendVerificationRequest',
      '3': '.v1.ResendVerificationResponse',
      '4': {}
    },
    {
      '1': 'CheckUsername',
      '2': '.v1.CheckUsernameRequest',
      '3': '.v1.CheckUsernameResponse',
      '4': {}
    },
    {
      '1': 'CheckEmail',
      '2': '.v1.CheckEmailRequest',
      '3': '.v1.CheckEmailResponse',
      '4': {}
    },
    {
      '1': 'GetUser',
      '2': '.v1.GetUserRequest',
      '3': '.v1.GetUserResponse',
      '4': {}
    },
    {
      '1': 'UpdateUser',
      '2': '.v1.UpdateUserRequest',
      '3': '.v1.UpdateUserResponse',
      '4': {}
    },
    {
      '1': 'ChangePassword',
      '2': '.v1.ChangePasswordRequest',
      '3': '.v1.ChangePasswordResponse',
      '4': {}
    },
    {
      '1': 'ListUsers',
      '2': '.v1.ListUsersRequest',
      '3': '.v1.ListUsersResponse',
      '4': {}
    },
    {
      '1': 'DeleteUser',
      '2': '.v1.DeleteUserRequest',
      '3': '.v1.DeleteUserResponse',
      '4': {}
    },
    {
      '1': 'CreateProfile',
      '2': '.v1.CreateProfileRequest',
      '3': '.v1.CreateProfileResponse',
      '4': {}
    },
    {
      '1': 'ListUserProfiles',
      '2': '.v1.ListUserProfilesRequest',
      '3': '.v1.ListUserProfilesResponse',
      '4': {}
    },
    {
      '1': 'UpdateProfile',
      '2': '.v1.UpdateProfileRequest',
      '3': '.v1.UpdateProfileResponse',
      '4': {}
    },
    {
      '1': 'DeleteProfile',
      '2': '.v1.DeleteProfileRequest',
      '3': '.v1.DeleteProfileResponse',
      '4': {}
    },
    {
      '1': 'SignIn',
      '2': '.v1.SignInRequest',
      '3': '.v1.SignInResponse',
      '4': {}
    },
    {
      '1': 'RefreshToken',
      '2': '.v1.RefreshTokenRequest',
      '3': '.v1.RefreshTokenResponse',
      '4': {}
    },
    {
      '1': 'Logout',
      '2': '.v1.LogoutRequest',
      '3': '.v1.LogoutResponse',
      '4': {}
    },
    {
      '1': 'ValidateToken',
      '2': '.v1.ValidateTokenRequest',
      '3': '.v1.ValidateTokenResponse',
      '4': {}
    },
    {
      '1': 'ListUserSessions',
      '2': '.v1.ListUserSessionsRequest',
      '3': '.v1.ListUserSessionsResponse',
      '4': {}
    },
    {
      '1': 'TerminateSession',
      '2': '.v1.TerminateSessionRequest',
      '3': '.v1.TerminateSessionResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use openAuthServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    OpenAuthServiceBase$messageJson = {
  '.v1.PingRequest': $0.PingRequest$json,
  '.v1.PingResponse': $0.PingResponse$json,
  '.v1.CreatePermissionRequest': $1.CreatePermissionRequest$json,
  '.v1.Permission': $1.Permission$json,
  '.v1.GetPermissionRequest': $1.GetPermissionRequest$json,
  '.v1.ListPermissionsRequest': $1.ListPermissionsRequest$json,
  '.v1.ListPermissionsResponse': $1.ListPermissionsResponse$json,
  '.v1.UpdatePermissionRequest': $1.UpdatePermissionRequest$json,
  '.v1.DeletePermissionRequest': $1.DeletePermissionRequest$json,
  '.v1.DeletePermissionResponse': $1.DeletePermissionResponse$json,
  '.v1.SignUpRequest': $2.SignUpRequest$json,
  '.v1.SignUpResponse': $2.SignUpResponse$json,
  '.v1.User': $2.User$json,
  '.v1.VerifyEmailRequest': $2.VerifyEmailRequest$json,
  '.v1.VerificationResponse': $2.VerificationResponse$json,
  '.v1.VerifyPhoneRequest': $2.VerifyPhoneRequest$json,
  '.v1.ResendVerificationRequest': $2.ResendVerificationRequest$json,
  '.v1.ResendVerificationResponse': $2.ResendVerificationResponse$json,
  '.v1.CheckUsernameRequest': $2.CheckUsernameRequest$json,
  '.v1.CheckUsernameResponse': $2.CheckUsernameResponse$json,
  '.v1.CheckEmailRequest': $2.CheckEmailRequest$json,
  '.v1.CheckEmailResponse': $2.CheckEmailResponse$json,
  '.v1.GetUserRequest': $2.GetUserRequest$json,
  '.v1.GetUserResponse': $2.GetUserResponse$json,
  '.v1.UserProfile': $2.UserProfile$json,
  '.v1.UpdateUserRequest': $2.UpdateUserRequest$json,
  '.v1.UpdateUserResponse': $2.UpdateUserResponse$json,
  '.v1.ChangePasswordRequest': $2.ChangePasswordRequest$json,
  '.v1.ChangePasswordResponse': $2.ChangePasswordResponse$json,
  '.v1.ListUsersRequest': $2.ListUsersRequest$json,
  '.v1.ListUsersResponse': $2.ListUsersResponse$json,
  '.v1.DeleteUserRequest': $2.DeleteUserRequest$json,
  '.v1.DeleteUserResponse': $2.DeleteUserResponse$json,
  '.v1.CreateProfileRequest': $2.CreateProfileRequest$json,
  '.v1.CreateProfileResponse': $2.CreateProfileResponse$json,
  '.v1.ListUserProfilesRequest': $2.ListUserProfilesRequest$json,
  '.v1.ListUserProfilesResponse': $2.ListUserProfilesResponse$json,
  '.v1.UpdateProfileRequest': $2.UpdateProfileRequest$json,
  '.v1.UpdateProfileResponse': $2.UpdateProfileResponse$json,
  '.v1.DeleteProfileRequest': $2.DeleteProfileRequest$json,
  '.v1.DeleteProfileResponse': $2.DeleteProfileResponse$json,
  '.v1.SignInRequest': $2.SignInRequest$json,
  '.v1.SignInResponse': $2.SignInResponse$json,
  '.v1.RefreshTokenRequest': $2.RefreshTokenRequest$json,
  '.v1.RefreshTokenResponse': $2.RefreshTokenResponse$json,
  '.v1.LogoutRequest': $2.LogoutRequest$json,
  '.v1.LogoutResponse': $2.LogoutResponse$json,
  '.v1.ValidateTokenRequest': $2.ValidateTokenRequest$json,
  '.v1.ValidateTokenResponse': $2.ValidateTokenResponse$json,
  '.v1.ListUserSessionsRequest': $2.ListUserSessionsRequest$json,
  '.v1.ListUserSessionsResponse': $2.ListUserSessionsResponse$json,
  '.v1.Session': $2.Session$json,
  '.v1.TerminateSessionRequest': $2.TerminateSessionRequest$json,
  '.v1.TerminateSessionResponse': $2.TerminateSessionResponse$json,
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
    '97aWR9ElUKBlNpZ25VcBIRLnYxLlNpZ25VcFJlcXVlc3QaEi52MS5TaWduVXBSZXNwb25zZSIk'
    'gtPkkwIeOgEqIhkvb3BlbmF1dGgvdjEvdXNlcnMvc2lnbnVwEmsKC1ZlcmlmeUVtYWlsEhYudj'
    'EuVmVyaWZ5RW1haWxSZXF1ZXN0GhgudjEuVmVyaWZpY2F0aW9uUmVzcG9uc2UiKoLT5JMCJDoB'
    'KiIfL29wZW5hdXRoL3YxL3VzZXJzL3ZlcmlmeS1lbWFpbBJrCgtWZXJpZnlQaG9uZRIWLnYxLl'
    'ZlcmlmeVBob25lUmVxdWVzdBoYLnYxLlZlcmlmaWNhdGlvblJlc3BvbnNlIiqC0+STAiQ6ASoi'
    'Hy9vcGVuYXV0aC92MS91c2Vycy92ZXJpZnktcGhvbmUShgEKElJlc2VuZFZlcmlmaWNhdGlvbh'
    'IdLnYxLlJlc2VuZFZlcmlmaWNhdGlvblJlcXVlc3QaHi52MS5SZXNlbmRWZXJpZmljYXRpb25S'
    'ZXNwb25zZSIxgtPkkwIrOgEqIiYvb3BlbmF1dGgvdjEvdXNlcnMvcmVzZW5kLXZlcmlmaWNhdG'
    'lvbhJ6Cg1DaGVja1VzZXJuYW1lEhgudjEuQ2hlY2tVc2VybmFtZVJlcXVlc3QaGS52MS5DaGVj'
    'a1VzZXJuYW1lUmVzcG9uc2UiNILT5JMCLhIsL29wZW5hdXRoL3YxL3VzZXJzL2NoZWNrLXVzZX'
    'JuYW1lL3t1c2VybmFtZX0SawoKQ2hlY2tFbWFpbBIVLnYxLkNoZWNrRW1haWxSZXF1ZXN0GhYu'
    'djEuQ2hlY2tFbWFpbFJlc3BvbnNlIi6C0+STAigSJi9vcGVuYXV0aC92MS91c2Vycy9jaGVjay'
    '1lbWFpbC97ZW1haWx9ElUKB0dldFVzZXISEi52MS5HZXRVc2VyUmVxdWVzdBoTLnYxLkdldFVz'
    'ZXJSZXNwb25zZSIhgtPkkwIbEhkvb3BlbmF1dGgvdjEvdXNlcnMve3V1aWR9EmEKClVwZGF0ZV'
    'VzZXISFS52MS5VcGRhdGVVc2VyUmVxdWVzdBoWLnYxLlVwZGF0ZVVzZXJSZXNwb25zZSIkgtPk'
    'kwIeOgEqGhkvb3BlbmF1dGgvdjEvdXNlcnMve3V1aWR9En0KDkNoYW5nZVBhc3N3b3JkEhkudj'
    'EuQ2hhbmdlUGFzc3dvcmRSZXF1ZXN0GhoudjEuQ2hhbmdlUGFzc3dvcmRSZXNwb25zZSI0gtPk'
    'kwIuOgEqIikvb3BlbmF1dGgvdjEvdXNlcnMve3V1aWR9L2NoYW5nZS1wYXNzd29yZBJUCglMaX'
    'N0VXNlcnMSFC52MS5MaXN0VXNlcnNSZXF1ZXN0GhUudjEuTGlzdFVzZXJzUmVzcG9uc2UiGoLT'
    '5JMCFBISL29wZW5hdXRoL3YxL3VzZXJzEl4KCkRlbGV0ZVVzZXISFS52MS5EZWxldGVVc2VyUm'
    'VxdWVzdBoWLnYxLkRlbGV0ZVVzZXJSZXNwb25zZSIhgtPkkwIbKhkvb3BlbmF1dGgvdjEvdXNl'
    'cnMve3V1aWR9EngKDUNyZWF0ZVByb2ZpbGUSGC52MS5DcmVhdGVQcm9maWxlUmVxdWVzdBoZLn'
    'YxLkNyZWF0ZVByb2ZpbGVSZXNwb25zZSIygtPkkwIsOgEqIicvb3BlbmF1dGgvdjEvdXNlcnMv'
    'e3VzZXJfdXVpZH0vcHJvZmlsZXMSfgoQTGlzdFVzZXJQcm9maWxlcxIbLnYxLkxpc3RVc2VyUH'
    'JvZmlsZXNSZXF1ZXN0GhwudjEuTGlzdFVzZXJQcm9maWxlc1Jlc3BvbnNlIi+C0+STAikSJy9v'
    'cGVuYXV0aC92MS91c2Vycy97dXNlcl91dWlkfS9wcm9maWxlcxJ1Cg1VcGRhdGVQcm9maWxlEh'
    'gudjEuVXBkYXRlUHJvZmlsZVJlcXVlc3QaGS52MS5VcGRhdGVQcm9maWxlUmVzcG9uc2UiL4LT'
    '5JMCKToBKhokL29wZW5hdXRoL3YxL3Byb2ZpbGVzL3twcm9maWxlX3V1aWR9EnIKDURlbGV0ZV'
    'Byb2ZpbGUSGC52MS5EZWxldGVQcm9maWxlUmVxdWVzdBoZLnYxLkRlbGV0ZVByb2ZpbGVSZXNw'
    'b25zZSIsgtPkkwImKiQvb3BlbmF1dGgvdjEvcHJvZmlsZXMve3Byb2ZpbGVfdXVpZH0SVAoGU2'
    'lnbkluEhEudjEuU2lnbkluUmVxdWVzdBoSLnYxLlNpZ25JblJlc3BvbnNlIiOC0+STAh06ASoi'
    'GC9vcGVuYXV0aC92MS9hdXRoL3NpZ25pbhJnCgxSZWZyZXNoVG9rZW4SFy52MS5SZWZyZXNoVG'
    '9rZW5SZXF1ZXN0GhgudjEuUmVmcmVzaFRva2VuUmVzcG9uc2UiJILT5JMCHjoBKiIZL29wZW5h'
    'dXRoL3YxL2F1dGgvcmVmcmVzaBJUCgZMb2dvdXQSES52MS5Mb2dvdXRSZXF1ZXN0GhIudjEuTG'
    '9nb3V0UmVzcG9uc2UiI4LT5JMCHToBKiIYL29wZW5hdXRoL3YxL2F1dGgvbG9nb3V0EmsKDVZh'
    'bGlkYXRlVG9rZW4SGC52MS5WYWxpZGF0ZVRva2VuUmVxdWVzdBoZLnYxLlZhbGlkYXRlVG9rZW'
    '5SZXNwb25zZSIlgtPkkwIfOgEqIhovb3BlbmF1dGgvdjEvYXV0aC92YWxpZGF0ZRJ+ChBMaXN0'
    'VXNlclNlc3Npb25zEhsudjEuTGlzdFVzZXJTZXNzaW9uc1JlcXVlc3QaHC52MS5MaXN0VXNlcl'
    'Nlc3Npb25zUmVzcG9uc2UiL4LT5JMCKRInL29wZW5hdXRoL3YxL3VzZXJzL3t1c2VyX3V1aWR9'
    'L3Nlc3Npb25zEnkKEFRlcm1pbmF0ZVNlc3Npb24SGy52MS5UZXJtaW5hdGVTZXNzaW9uUmVxdW'
    'VzdBocLnYxLlRlcm1pbmF0ZVNlc3Npb25SZXNwb25zZSIqgtPkkwIkKiIvb3BlbmF1dGgvdjEv'
    'c2Vzc2lvbnMve3Nlc3Npb25faWR9');
