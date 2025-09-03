///
//  Generated code. Do not modify.
//  source: openauth/v1/groups.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use groupDescriptor instead')
const Group$json = const {
  '1': 'Group',
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

/// Descriptor for `Group`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupDescriptor = $convert.base64Decode('CgVHcm91cBIOCgJpZBgBIAEoA1ICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIhCgxkaXNwbGF5X25hbWUYAyABKAlSC2Rpc3BsYXlOYW1lEiUKC2Rlc2NyaXB0aW9uGAQgASgJSABSC2Rlc2NyaXB0aW9uiAEBEh0KCmNyZWF0ZWRfYnkYBSABKANSCWNyZWF0ZWRCeRIdCgpjcmVhdGVkX2F0GAYgASgDUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgHIAEoA1IJdXBkYXRlZEF0EhsKCWlzX3N5c3RlbRgIIAEoCFIIaXNTeXN0ZW1CDgoMX2Rlc2NyaXB0aW9u');
@$core.Deprecated('Use createGroupRequestDescriptor instead')
const CreateGroupRequest$json = const {
  '1': 'CreateGroupRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'description', '17': true},
    const {'1': 'is_default', '3': 4, '4': 1, '5': 8, '10': 'isDefault'},
  ],
  '8': const [
    const {'1': '_description'},
  ],
};

/// Descriptor for `CreateGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGroupRequestDescriptor = $convert.base64Decode('ChJDcmVhdGVHcm91cFJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIhCgxkaXNwbGF5X25hbWUYAiABKAlSC2Rpc3BsYXlOYW1lEiUKC2Rlc2NyaXB0aW9uGAMgASgJSABSC2Rlc2NyaXB0aW9uiAEBEh0KCmlzX2RlZmF1bHQYBCABKAhSCWlzRGVmYXVsdEIOCgxfZGVzY3JpcHRpb24=');
@$core.Deprecated('Use createGroupResponseDescriptor instead')
const CreateGroupResponse$json = const {
  '1': 'CreateGroupResponse',
  '2': const [
    const {'1': 'group', '3': 1, '4': 1, '5': 11, '6': '.v1.Group', '10': 'group'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CreateGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGroupResponseDescriptor = $convert.base64Decode('ChNDcmVhdGVHcm91cFJlc3BvbnNlEh8KBWdyb3VwGAEgASgLMgkudjEuR3JvdXBSBWdyb3VwEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use getGroupRequestDescriptor instead')
const GetGroupRequest$json = const {
  '1': 'GetGroupRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `GetGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGroupRequestDescriptor = $convert.base64Decode('Cg9HZXRHcm91cFJlcXVlc3QSDgoCaWQYASABKANSAmlk');
@$core.Deprecated('Use getGroupResponseDescriptor instead')
const GetGroupResponse$json = const {
  '1': 'GetGroupResponse',
  '2': const [
    const {'1': 'group', '3': 1, '4': 1, '5': 11, '6': '.v1.Group', '10': 'group'},
  ],
};

/// Descriptor for `GetGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGroupResponseDescriptor = $convert.base64Decode('ChBHZXRHcm91cFJlc3BvbnNlEh8KBWdyb3VwGAEgASgLMgkudjEuR3JvdXBSBWdyb3Vw');
@$core.Deprecated('Use updateGroupRequestDescriptor instead')
const UpdateGroupRequest$json = const {
  '1': 'UpdateGroupRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'new_name', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'newName', '17': true},
    const {'1': 'display_name', '3': 5, '4': 1, '5': 9, '9': 1, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 6, '4': 1, '5': 9, '9': 2, '10': 'description', '17': true},
  ],
  '8': const [
    const {'1': '_new_name'},
    const {'1': '_display_name'},
    const {'1': '_description'},
  ],
};

/// Descriptor for `UpdateGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateGroupRequestDescriptor = $convert.base64Decode('ChJVcGRhdGVHcm91cFJlcXVlc3QSDgoCaWQYASABKANSAmlkEh4KCG5ld19uYW1lGAQgASgJSABSB25ld05hbWWIAQESJgoMZGlzcGxheV9uYW1lGAUgASgJSAFSC2Rpc3BsYXlOYW1liAEBEiUKC2Rlc2NyaXB0aW9uGAYgASgJSAJSC2Rlc2NyaXB0aW9uiAEBQgsKCV9uZXdfbmFtZUIPCg1fZGlzcGxheV9uYW1lQg4KDF9kZXNjcmlwdGlvbg==');
@$core.Deprecated('Use updateGroupResponseDescriptor instead')
const UpdateGroupResponse$json = const {
  '1': 'UpdateGroupResponse',
  '2': const [
    const {'1': 'group', '3': 1, '4': 1, '5': 11, '6': '.v1.Group', '10': 'group'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UpdateGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateGroupResponseDescriptor = $convert.base64Decode('ChNVcGRhdGVHcm91cFJlc3BvbnNlEh8KBWdyb3VwGAEgASgLMgkudjEuR3JvdXBSBWdyb3VwEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use deleteGroupRequestDescriptor instead')
const DeleteGroupRequest$json = const {
  '1': 'DeleteGroupRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `DeleteGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteGroupRequestDescriptor = $convert.base64Decode('ChJEZWxldGVHcm91cFJlcXVlc3QSDgoCaWQYASABKANSAmlk');
@$core.Deprecated('Use deleteGroupResponseDescriptor instead')
const DeleteGroupResponse$json = const {
  '1': 'DeleteGroupResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteGroupResponseDescriptor = $convert.base64Decode('ChNEZWxldGVHcm91cFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use listGroupsRequestDescriptor instead')
const ListGroupsRequest$json = const {
  '1': 'ListGroupsRequest',
  '2': const [
    const {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
    const {'1': 'id', '3': 3, '4': 1, '5': 3, '9': 0, '10': 'id', '17': true},
    const {'1': 'search', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'search', '17': true},
  ],
  '8': const [
    const {'1': '_id'},
    const {'1': '_search'},
  ],
};

/// Descriptor for `ListGroupsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGroupsRequestDescriptor = $convert.base64Decode('ChFMaXN0R3JvdXBzUmVxdWVzdBIUCgVsaW1pdBgBIAEoBVIFbGltaXQSFgoGb2Zmc2V0GAIgASgFUgZvZmZzZXQSEwoCaWQYAyABKANIAFICaWSIAQESGwoGc2VhcmNoGAQgASgJSAFSBnNlYXJjaIgBAUIFCgNfaWRCCQoHX3NlYXJjaA==');
@$core.Deprecated('Use listGroupsResponseDescriptor instead')
const ListGroupsResponse$json = const {
  '1': 'ListGroupsResponse',
  '2': const [
    const {'1': 'groups', '3': 1, '4': 3, '5': 11, '6': '.v1.Group', '10': 'groups'},
  ],
};

/// Descriptor for `ListGroupsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGroupsResponseDescriptor = $convert.base64Decode('ChJMaXN0R3JvdXBzUmVzcG9uc2USIQoGZ3JvdXBzGAEgAygLMgkudjEuR3JvdXBSBmdyb3Vwcw==');
@$core.Deprecated('Use assignUserToGroupRequestDescriptor instead')
const AssignUserToGroupRequest$json = const {
  '1': 'AssignUserToGroupRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 3, '10': 'groupId'},
    const {'1': 'expires_at', '3': 3, '4': 1, '5': 3, '9': 0, '10': 'expiresAt', '17': true},
  ],
  '8': const [
    const {'1': '_expires_at'},
  ],
};

/// Descriptor for `AssignUserToGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignUserToGroupRequestDescriptor = $convert.base64Decode('ChhBc3NpZ25Vc2VyVG9Hcm91cFJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoA1IGdXNlcklkEhkKCGdyb3VwX2lkGAIgASgDUgdncm91cElkEiIKCmV4cGlyZXNfYXQYAyABKANIAFIJZXhwaXJlc0F0iAEBQg0KC19leHBpcmVzX2F0');
@$core.Deprecated('Use assignUserToGroupResponseDescriptor instead')
const AssignUserToGroupResponse$json = const {
  '1': 'AssignUserToGroupResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `AssignUserToGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignUserToGroupResponseDescriptor = $convert.base64Decode('ChlBc3NpZ25Vc2VyVG9Hcm91cFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use removeUserFromGroupRequestDescriptor instead')
const RemoveUserFromGroupRequest$json = const {
  '1': 'RemoveUserFromGroupRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'group_id', '3': 2, '4': 1, '5': 3, '10': 'groupId'},
  ],
};

/// Descriptor for `RemoveUserFromGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeUserFromGroupRequestDescriptor = $convert.base64Decode('ChpSZW1vdmVVc2VyRnJvbUdyb3VwUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgDUgZ1c2VySWQSGQoIZ3JvdXBfaWQYAiABKANSB2dyb3VwSWQ=');
@$core.Deprecated('Use removeUserFromGroupResponseDescriptor instead')
const RemoveUserFromGroupResponse$json = const {
  '1': 'RemoveUserFromGroupResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RemoveUserFromGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeUserFromGroupResponseDescriptor = $convert.base64Decode('ChtSZW1vdmVVc2VyRnJvbUdyb3VwUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
@$core.Deprecated('Use listGroupUsersRequestDescriptor instead')
const ListGroupUsersRequest$json = const {
  '1': 'ListGroupUsersRequest',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 3, '10': 'groupId'},
    const {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListGroupUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGroupUsersRequestDescriptor = $convert.base64Decode('ChVMaXN0R3JvdXBVc2Vyc1JlcXVlc3QSGQoIZ3JvdXBfaWQYASABKANSB2dyb3VwSWQSFAoFbGltaXQYAiABKAVSBWxpbWl0EhYKBm9mZnNldBgDIAEoBVIGb2Zmc2V0');
@$core.Deprecated('Use listGroupUsersResponseDescriptor instead')
const ListGroupUsersResponse$json = const {
  '1': 'ListGroupUsersResponse',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 11, '6': '.v1.GroupUser', '10': 'users'},
  ],
};

/// Descriptor for `ListGroupUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listGroupUsersResponseDescriptor = $convert.base64Decode('ChZMaXN0R3JvdXBVc2Vyc1Jlc3BvbnNlEiMKBXVzZXJzGAEgAygLMg0udjEuR3JvdXBVc2VyUgV1c2Vycw==');
@$core.Deprecated('Use groupUserDescriptor instead')
const GroupUser$json = const {
  '1': 'GroupUser',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'user_uuid', '3': 2, '4': 1, '5': 9, '10': 'userUuid'},
    const {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'email', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'email', '17': true},
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '9': 1, '10': 'name', '17': true},
    const {'1': 'avatar', '3': 6, '4': 1, '5': 9, '9': 2, '10': 'avatar', '17': true},
    const {'1': 'expires_at', '3': 7, '4': 1, '5': 3, '9': 3, '10': 'expiresAt', '17': true},
    const {'1': 'assigned_at', '3': 8, '4': 1, '5': 3, '10': 'assignedAt'},
    const {'1': 'assigned_by', '3': 9, '4': 1, '5': 3, '10': 'assignedBy'},
  ],
  '8': const [
    const {'1': '_email'},
    const {'1': '_name'},
    const {'1': '_avatar'},
    const {'1': '_expires_at'},
  ],
};

/// Descriptor for `GroupUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupUserDescriptor = $convert.base64Decode('CglHcm91cFVzZXISFwoHdXNlcl9pZBgBIAEoA1IGdXNlcklkEhsKCXVzZXJfdXVpZBgCIAEoCVIIdXNlclV1aWQSGgoIdXNlcm5hbWUYAyABKAlSCHVzZXJuYW1lEhkKBWVtYWlsGAQgASgJSABSBWVtYWlsiAEBEhcKBG5hbWUYBSABKAlIAVIEbmFtZYgBARIbCgZhdmF0YXIYBiABKAlIAlIGYXZhdGFyiAEBEiIKCmV4cGlyZXNfYXQYByABKANIA1IJZXhwaXJlc0F0iAEBEh8KC2Fzc2lnbmVkX2F0GAggASgDUgphc3NpZ25lZEF0Eh8KC2Fzc2lnbmVkX2J5GAkgASgDUgphc3NpZ25lZEJ5QggKBl9lbWFpbEIHCgVfbmFtZUIJCgdfYXZhdGFyQg0KC19leHBpcmVzX2F0');
@$core.Deprecated('Use listUserGroupsRequestDescriptor instead')
const ListUserGroupsRequest$json = const {
  '1': 'ListUserGroupsRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListUserGroupsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserGroupsRequestDescriptor = $convert.base64Decode('ChVMaXN0VXNlckdyb3Vwc1JlcXVlc3QSFwoHdXNlcl9pZBgBIAEoA1IGdXNlcklkEhQKBWxpbWl0GAIgASgFUgVsaW1pdBIWCgZvZmZzZXQYAyABKAVSBm9mZnNldA==');
@$core.Deprecated('Use listUserGroupsResponseDescriptor instead')
const ListUserGroupsResponse$json = const {
  '1': 'ListUserGroupsResponse',
  '2': const [
    const {'1': 'groups', '3': 1, '4': 3, '5': 11, '6': '.v1.UserGroup', '10': 'groups'},
  ],
};

/// Descriptor for `ListUserGroupsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserGroupsResponseDescriptor = $convert.base64Decode('ChZMaXN0VXNlckdyb3Vwc1Jlc3BvbnNlEiUKBmdyb3VwcxgBIAMoCzINLnYxLlVzZXJHcm91cFIGZ3JvdXBz');
@$core.Deprecated('Use userGroupDescriptor instead')
const UserGroup$json = const {
  '1': 'UserGroup',
  '2': const [
    const {'1': 'group_id', '3': 1, '4': 1, '5': 3, '10': 'groupId'},
    const {'1': 'group_name', '3': 2, '4': 1, '5': 9, '10': 'groupName'},
    const {'1': 'group_display_name', '3': 3, '4': 1, '5': 9, '10': 'groupDisplayName'},
    const {'1': 'group_description', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'groupDescription', '17': true},
    const {'1': 'is_system', '3': 5, '4': 1, '5': 8, '10': 'isSystem'},
    const {'1': 'is_default', '3': 6, '4': 1, '5': 8, '10': 'isDefault'},
    const {'1': 'expires_at', '3': 7, '4': 1, '5': 3, '9': 1, '10': 'expiresAt', '17': true},
    const {'1': 'assigned_at', '3': 8, '4': 1, '5': 3, '10': 'assignedAt'},
    const {'1': 'assigned_by', '3': 9, '4': 1, '5': 3, '10': 'assignedBy'},
  ],
  '8': const [
    const {'1': '_group_description'},
    const {'1': '_expires_at'},
  ],
};

/// Descriptor for `UserGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userGroupDescriptor = $convert.base64Decode('CglVc2VyR3JvdXASGQoIZ3JvdXBfaWQYASABKANSB2dyb3VwSWQSHQoKZ3JvdXBfbmFtZRgCIAEoCVIJZ3JvdXBOYW1lEiwKEmdyb3VwX2Rpc3BsYXlfbmFtZRgDIAEoCVIQZ3JvdXBEaXNwbGF5TmFtZRIwChFncm91cF9kZXNjcmlwdGlvbhgEIAEoCUgAUhBncm91cERlc2NyaXB0aW9uiAEBEhsKCWlzX3N5c3RlbRgFIAEoCFIIaXNTeXN0ZW0SHQoKaXNfZGVmYXVsdBgGIAEoCFIJaXNEZWZhdWx0EiIKCmV4cGlyZXNfYXQYByABKANIAVIJZXhwaXJlc0F0iAEBEh8KC2Fzc2lnbmVkX2F0GAggASgDUgphc3NpZ25lZEF0Eh8KC2Fzc2lnbmVkX2J5GAkgASgDUgphc3NpZ25lZEJ5QhQKEl9ncm91cF9kZXNjcmlwdGlvbkINCgtfZXhwaXJlc19hdA==');
