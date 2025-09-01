///
//  Generated code. Do not modify.
//  source: openauth/v1/permission_assignments.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class GroupPermission extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GroupPermission', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionName')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionDisplayName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionDescription')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupName')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupDisplayName')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupDescription')
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'grantedBy')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..hasRequiredFields = false
  ;

  GroupPermission._() : super();
  factory GroupPermission({
    $fixnum.Int64? id,
    $fixnum.Int64? groupId,
    $fixnum.Int64? permissionId,
    $core.String? permissionName,
    $core.String? permissionDisplayName,
    $core.String? permissionDescription,
    $core.String? groupName,
    $core.String? groupDisplayName,
    $core.String? groupDescription,
    $fixnum.Int64? grantedBy,
    $fixnum.Int64? createdAt,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (permissionId != null) {
      _result.permissionId = permissionId;
    }
    if (permissionName != null) {
      _result.permissionName = permissionName;
    }
    if (permissionDisplayName != null) {
      _result.permissionDisplayName = permissionDisplayName;
    }
    if (permissionDescription != null) {
      _result.permissionDescription = permissionDescription;
    }
    if (groupName != null) {
      _result.groupName = groupName;
    }
    if (groupDisplayName != null) {
      _result.groupDisplayName = groupDisplayName;
    }
    if (groupDescription != null) {
      _result.groupDescription = groupDescription;
    }
    if (grantedBy != null) {
      _result.grantedBy = grantedBy;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    return _result;
  }
  factory GroupPermission.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GroupPermission.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GroupPermission clone() => GroupPermission()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GroupPermission copyWith(void Function(GroupPermission) updates) => super.copyWith((message) => updates(message as GroupPermission)) as GroupPermission; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GroupPermission create() => GroupPermission._();
  GroupPermission createEmptyInstance() => create();
  static $pb.PbList<GroupPermission> createRepeated() => $pb.PbList<GroupPermission>();
  @$core.pragma('dart2js:noInline')
  static GroupPermission getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupPermission>(create);
  static GroupPermission? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get groupId => $_getI64(1);
  @$pb.TagNumber(2)
  set groupId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get permissionId => $_getI64(2);
  @$pb.TagNumber(3)
  set permissionId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPermissionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermissionId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get permissionName => $_getSZ(3);
  @$pb.TagNumber(4)
  set permissionName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPermissionName() => $_has(3);
  @$pb.TagNumber(4)
  void clearPermissionName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get permissionDisplayName => $_getSZ(4);
  @$pb.TagNumber(5)
  set permissionDisplayName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPermissionDisplayName() => $_has(4);
  @$pb.TagNumber(5)
  void clearPermissionDisplayName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get permissionDescription => $_getSZ(5);
  @$pb.TagNumber(6)
  set permissionDescription($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPermissionDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearPermissionDescription() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get groupName => $_getSZ(6);
  @$pb.TagNumber(7)
  set groupName($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGroupName() => $_has(6);
  @$pb.TagNumber(7)
  void clearGroupName() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get groupDisplayName => $_getSZ(7);
  @$pb.TagNumber(8)
  set groupDisplayName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasGroupDisplayName() => $_has(7);
  @$pb.TagNumber(8)
  void clearGroupDisplayName() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get groupDescription => $_getSZ(8);
  @$pb.TagNumber(9)
  set groupDescription($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasGroupDescription() => $_has(8);
  @$pb.TagNumber(9)
  void clearGroupDescription() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get grantedBy => $_getI64(9);
  @$pb.TagNumber(10)
  set grantedBy($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasGrantedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearGrantedBy() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get createdAt => $_getI64(10);
  @$pb.TagNumber(11)
  set createdAt($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => clearField(11);
}

class UserPermission extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UserPermission', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionName')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionDisplayName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionDescription')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userUuid')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userEmail')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userDisplayName')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'grantedBy')
    ..aInt64(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiresAt')
    ..aInt64(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..hasRequiredFields = false
  ;

  UserPermission._() : super();
  factory UserPermission({
    $fixnum.Int64? id,
    $fixnum.Int64? userId,
    $fixnum.Int64? permissionId,
    $core.String? permissionName,
    $core.String? permissionDisplayName,
    $core.String? permissionDescription,
    $core.String? userUuid,
    $core.String? username,
    $core.String? userEmail,
    $core.String? userDisplayName,
    $fixnum.Int64? grantedBy,
    $fixnum.Int64? expiresAt,
    $fixnum.Int64? createdAt,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    if (permissionId != null) {
      _result.permissionId = permissionId;
    }
    if (permissionName != null) {
      _result.permissionName = permissionName;
    }
    if (permissionDisplayName != null) {
      _result.permissionDisplayName = permissionDisplayName;
    }
    if (permissionDescription != null) {
      _result.permissionDescription = permissionDescription;
    }
    if (userUuid != null) {
      _result.userUuid = userUuid;
    }
    if (username != null) {
      _result.username = username;
    }
    if (userEmail != null) {
      _result.userEmail = userEmail;
    }
    if (userDisplayName != null) {
      _result.userDisplayName = userDisplayName;
    }
    if (grantedBy != null) {
      _result.grantedBy = grantedBy;
    }
    if (expiresAt != null) {
      _result.expiresAt = expiresAt;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    return _result;
  }
  factory UserPermission.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserPermission.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserPermission clone() => UserPermission()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserPermission copyWith(void Function(UserPermission) updates) => super.copyWith((message) => updates(message as UserPermission)) as UserPermission; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UserPermission create() => UserPermission._();
  UserPermission createEmptyInstance() => create();
  static $pb.PbList<UserPermission> createRepeated() => $pb.PbList<UserPermission>();
  @$core.pragma('dart2js:noInline')
  static UserPermission getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserPermission>(create);
  static UserPermission? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get userId => $_getI64(1);
  @$pb.TagNumber(2)
  set userId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get permissionId => $_getI64(2);
  @$pb.TagNumber(3)
  set permissionId($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPermissionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermissionId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get permissionName => $_getSZ(3);
  @$pb.TagNumber(4)
  set permissionName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPermissionName() => $_has(3);
  @$pb.TagNumber(4)
  void clearPermissionName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get permissionDisplayName => $_getSZ(4);
  @$pb.TagNumber(5)
  set permissionDisplayName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPermissionDisplayName() => $_has(4);
  @$pb.TagNumber(5)
  void clearPermissionDisplayName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get permissionDescription => $_getSZ(5);
  @$pb.TagNumber(6)
  set permissionDescription($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPermissionDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearPermissionDescription() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get userUuid => $_getSZ(6);
  @$pb.TagNumber(7)
  set userUuid($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasUserUuid() => $_has(6);
  @$pb.TagNumber(7)
  void clearUserUuid() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get username => $_getSZ(7);
  @$pb.TagNumber(8)
  set username($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasUsername() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsername() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get userEmail => $_getSZ(8);
  @$pb.TagNumber(9)
  set userEmail($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasUserEmail() => $_has(8);
  @$pb.TagNumber(9)
  void clearUserEmail() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get userDisplayName => $_getSZ(9);
  @$pb.TagNumber(10)
  set userDisplayName($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasUserDisplayName() => $_has(9);
  @$pb.TagNumber(10)
  void clearUserDisplayName() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get grantedBy => $_getI64(10);
  @$pb.TagNumber(11)
  set grantedBy($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasGrantedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearGrantedBy() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get expiresAt => $_getI64(11);
  @$pb.TagNumber(12)
  set expiresAt($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasExpiresAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearExpiresAt() => clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get createdAt => $_getI64(12);
  @$pb.TagNumber(13)
  set createdAt($fixnum.Int64 v) { $_setInt64(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => clearField(13);
}

class AssignPermissionToGroupRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AssignPermissionToGroupRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionId')
    ..hasRequiredFields = false
  ;

  AssignPermissionToGroupRequest._() : super();
  factory AssignPermissionToGroupRequest({
    $fixnum.Int64? groupId,
    $fixnum.Int64? permissionId,
  }) {
    final _result = create();
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (permissionId != null) {
      _result.permissionId = permissionId;
    }
    return _result;
  }
  factory AssignPermissionToGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignPermissionToGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignPermissionToGroupRequest clone() => AssignPermissionToGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignPermissionToGroupRequest copyWith(void Function(AssignPermissionToGroupRequest) updates) => super.copyWith((message) => updates(message as AssignPermissionToGroupRequest)) as AssignPermissionToGroupRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AssignPermissionToGroupRequest create() => AssignPermissionToGroupRequest._();
  AssignPermissionToGroupRequest createEmptyInstance() => create();
  static $pb.PbList<AssignPermissionToGroupRequest> createRepeated() => $pb.PbList<AssignPermissionToGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static AssignPermissionToGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignPermissionToGroupRequest>(create);
  static AssignPermissionToGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get groupId => $_getI64(0);
  @$pb.TagNumber(1)
  set groupId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get permissionId => $_getI64(1);
  @$pb.TagNumber(2)
  set permissionId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPermissionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermissionId() => clearField(2);
}

class AssignPermissionToGroupResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AssignPermissionToGroupResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aOM<GroupPermission>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupPermission', subBuilder: GroupPermission.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  AssignPermissionToGroupResponse._() : super();
  factory AssignPermissionToGroupResponse({
    GroupPermission? groupPermission,
    $core.String? message,
  }) {
    final _result = create();
    if (groupPermission != null) {
      _result.groupPermission = groupPermission;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory AssignPermissionToGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignPermissionToGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignPermissionToGroupResponse clone() => AssignPermissionToGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignPermissionToGroupResponse copyWith(void Function(AssignPermissionToGroupResponse) updates) => super.copyWith((message) => updates(message as AssignPermissionToGroupResponse)) as AssignPermissionToGroupResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AssignPermissionToGroupResponse create() => AssignPermissionToGroupResponse._();
  AssignPermissionToGroupResponse createEmptyInstance() => create();
  static $pb.PbList<AssignPermissionToGroupResponse> createRepeated() => $pb.PbList<AssignPermissionToGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static AssignPermissionToGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignPermissionToGroupResponse>(create);
  static AssignPermissionToGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  GroupPermission get groupPermission => $_getN(0);
  @$pb.TagNumber(1)
  set groupPermission(GroupPermission v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupPermission() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupPermission() => clearField(1);
  @$pb.TagNumber(1)
  GroupPermission ensureGroupPermission() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class RemovePermissionFromGroupRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePermissionFromGroupRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionId')
    ..hasRequiredFields = false
  ;

  RemovePermissionFromGroupRequest._() : super();
  factory RemovePermissionFromGroupRequest({
    $fixnum.Int64? groupId,
    $fixnum.Int64? permissionId,
  }) {
    final _result = create();
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (permissionId != null) {
      _result.permissionId = permissionId;
    }
    return _result;
  }
  factory RemovePermissionFromGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePermissionFromGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePermissionFromGroupRequest clone() => RemovePermissionFromGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePermissionFromGroupRequest copyWith(void Function(RemovePermissionFromGroupRequest) updates) => super.copyWith((message) => updates(message as RemovePermissionFromGroupRequest)) as RemovePermissionFromGroupRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemovePermissionFromGroupRequest create() => RemovePermissionFromGroupRequest._();
  RemovePermissionFromGroupRequest createEmptyInstance() => create();
  static $pb.PbList<RemovePermissionFromGroupRequest> createRepeated() => $pb.PbList<RemovePermissionFromGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static RemovePermissionFromGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePermissionFromGroupRequest>(create);
  static RemovePermissionFromGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get groupId => $_getI64(0);
  @$pb.TagNumber(1)
  set groupId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get permissionId => $_getI64(1);
  @$pb.TagNumber(2)
  set permissionId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPermissionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermissionId() => clearField(2);
}

class RemovePermissionFromGroupResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePermissionFromGroupResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  RemovePermissionFromGroupResponse._() : super();
  factory RemovePermissionFromGroupResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory RemovePermissionFromGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePermissionFromGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePermissionFromGroupResponse clone() => RemovePermissionFromGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePermissionFromGroupResponse copyWith(void Function(RemovePermissionFromGroupResponse) updates) => super.copyWith((message) => updates(message as RemovePermissionFromGroupResponse)) as RemovePermissionFromGroupResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemovePermissionFromGroupResponse create() => RemovePermissionFromGroupResponse._();
  RemovePermissionFromGroupResponse createEmptyInstance() => create();
  static $pb.PbList<RemovePermissionFromGroupResponse> createRepeated() => $pb.PbList<RemovePermissionFromGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static RemovePermissionFromGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePermissionFromGroupResponse>(create);
  static RemovePermissionFromGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class ListGroupPermissionsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListGroupPermissionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'limit', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offset', $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'search')
    ..hasRequiredFields = false
  ;

  ListGroupPermissionsRequest._() : super();
  factory ListGroupPermissionsRequest({
    $fixnum.Int64? groupId,
    $core.int? limit,
    $core.int? offset,
    $core.String? search,
  }) {
    final _result = create();
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (limit != null) {
      _result.limit = limit;
    }
    if (offset != null) {
      _result.offset = offset;
    }
    if (search != null) {
      _result.search = search;
    }
    return _result;
  }
  factory ListGroupPermissionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListGroupPermissionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListGroupPermissionsRequest clone() => ListGroupPermissionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListGroupPermissionsRequest copyWith(void Function(ListGroupPermissionsRequest) updates) => super.copyWith((message) => updates(message as ListGroupPermissionsRequest)) as ListGroupPermissionsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListGroupPermissionsRequest create() => ListGroupPermissionsRequest._();
  ListGroupPermissionsRequest createEmptyInstance() => create();
  static $pb.PbList<ListGroupPermissionsRequest> createRepeated() => $pb.PbList<ListGroupPermissionsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListGroupPermissionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListGroupPermissionsRequest>(create);
  static ListGroupPermissionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get groupId => $_getI64(0);
  @$pb.TagNumber(1)
  set groupId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get offset => $_getIZ(2);
  @$pb.TagNumber(3)
  set offset($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get search => $_getSZ(3);
  @$pb.TagNumber(4)
  set search($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => clearField(4);
}

class ListGroupPermissionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListGroupPermissionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..pc<GroupPermission>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissions', $pb.PbFieldType.PM, subBuilder: GroupPermission.create)
    ..hasRequiredFields = false
  ;

  ListGroupPermissionsResponse._() : super();
  factory ListGroupPermissionsResponse({
    $core.Iterable<GroupPermission>? permissions,
  }) {
    final _result = create();
    if (permissions != null) {
      _result.permissions.addAll(permissions);
    }
    return _result;
  }
  factory ListGroupPermissionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListGroupPermissionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListGroupPermissionsResponse clone() => ListGroupPermissionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListGroupPermissionsResponse copyWith(void Function(ListGroupPermissionsResponse) updates) => super.copyWith((message) => updates(message as ListGroupPermissionsResponse)) as ListGroupPermissionsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListGroupPermissionsResponse create() => ListGroupPermissionsResponse._();
  ListGroupPermissionsResponse createEmptyInstance() => create();
  static $pb.PbList<ListGroupPermissionsResponse> createRepeated() => $pb.PbList<ListGroupPermissionsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListGroupPermissionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListGroupPermissionsResponse>(create);
  static ListGroupPermissionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<GroupPermission> get permissions => $_getList(0);
}

class AssignPermissionToUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AssignPermissionToUserRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionId')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiresAt')
    ..hasRequiredFields = false
  ;

  AssignPermissionToUserRequest._() : super();
  factory AssignPermissionToUserRequest({
    $fixnum.Int64? userId,
    $fixnum.Int64? permissionId,
    $fixnum.Int64? expiresAt,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (permissionId != null) {
      _result.permissionId = permissionId;
    }
    if (expiresAt != null) {
      _result.expiresAt = expiresAt;
    }
    return _result;
  }
  factory AssignPermissionToUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignPermissionToUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignPermissionToUserRequest clone() => AssignPermissionToUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignPermissionToUserRequest copyWith(void Function(AssignPermissionToUserRequest) updates) => super.copyWith((message) => updates(message as AssignPermissionToUserRequest)) as AssignPermissionToUserRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AssignPermissionToUserRequest create() => AssignPermissionToUserRequest._();
  AssignPermissionToUserRequest createEmptyInstance() => create();
  static $pb.PbList<AssignPermissionToUserRequest> createRepeated() => $pb.PbList<AssignPermissionToUserRequest>();
  @$core.pragma('dart2js:noInline')
  static AssignPermissionToUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignPermissionToUserRequest>(create);
  static AssignPermissionToUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get permissionId => $_getI64(1);
  @$pb.TagNumber(2)
  set permissionId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPermissionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermissionId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expiresAt => $_getI64(2);
  @$pb.TagNumber(3)
  set expiresAt($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasExpiresAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAt() => clearField(3);
}

class AssignPermissionToUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AssignPermissionToUserResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aOM<UserPermission>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userPermission', subBuilder: UserPermission.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  AssignPermissionToUserResponse._() : super();
  factory AssignPermissionToUserResponse({
    UserPermission? userPermission,
    $core.String? message,
  }) {
    final _result = create();
    if (userPermission != null) {
      _result.userPermission = userPermission;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory AssignPermissionToUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignPermissionToUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignPermissionToUserResponse clone() => AssignPermissionToUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignPermissionToUserResponse copyWith(void Function(AssignPermissionToUserResponse) updates) => super.copyWith((message) => updates(message as AssignPermissionToUserResponse)) as AssignPermissionToUserResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AssignPermissionToUserResponse create() => AssignPermissionToUserResponse._();
  AssignPermissionToUserResponse createEmptyInstance() => create();
  static $pb.PbList<AssignPermissionToUserResponse> createRepeated() => $pb.PbList<AssignPermissionToUserResponse>();
  @$core.pragma('dart2js:noInline')
  static AssignPermissionToUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignPermissionToUserResponse>(create);
  static AssignPermissionToUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UserPermission get userPermission => $_getN(0);
  @$pb.TagNumber(1)
  set userPermission(UserPermission v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserPermission() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserPermission() => clearField(1);
  @$pb.TagNumber(1)
  UserPermission ensureUserPermission() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class RemovePermissionFromUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePermissionFromUserRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionId')
    ..hasRequiredFields = false
  ;

  RemovePermissionFromUserRequest._() : super();
  factory RemovePermissionFromUserRequest({
    $fixnum.Int64? userId,
    $fixnum.Int64? permissionId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (permissionId != null) {
      _result.permissionId = permissionId;
    }
    return _result;
  }
  factory RemovePermissionFromUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePermissionFromUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePermissionFromUserRequest clone() => RemovePermissionFromUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePermissionFromUserRequest copyWith(void Function(RemovePermissionFromUserRequest) updates) => super.copyWith((message) => updates(message as RemovePermissionFromUserRequest)) as RemovePermissionFromUserRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemovePermissionFromUserRequest create() => RemovePermissionFromUserRequest._();
  RemovePermissionFromUserRequest createEmptyInstance() => create();
  static $pb.PbList<RemovePermissionFromUserRequest> createRepeated() => $pb.PbList<RemovePermissionFromUserRequest>();
  @$core.pragma('dart2js:noInline')
  static RemovePermissionFromUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePermissionFromUserRequest>(create);
  static RemovePermissionFromUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get permissionId => $_getI64(1);
  @$pb.TagNumber(2)
  set permissionId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPermissionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermissionId() => clearField(2);
}

class RemovePermissionFromUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePermissionFromUserResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  RemovePermissionFromUserResponse._() : super();
  factory RemovePermissionFromUserResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory RemovePermissionFromUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePermissionFromUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePermissionFromUserResponse clone() => RemovePermissionFromUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePermissionFromUserResponse copyWith(void Function(RemovePermissionFromUserResponse) updates) => super.copyWith((message) => updates(message as RemovePermissionFromUserResponse)) as RemovePermissionFromUserResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemovePermissionFromUserResponse create() => RemovePermissionFromUserResponse._();
  RemovePermissionFromUserResponse createEmptyInstance() => create();
  static $pb.PbList<RemovePermissionFromUserResponse> createRepeated() => $pb.PbList<RemovePermissionFromUserResponse>();
  @$core.pragma('dart2js:noInline')
  static RemovePermissionFromUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePermissionFromUserResponse>(create);
  static RemovePermissionFromUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class ListUserPermissionsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListUserPermissionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'limit', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offset', $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'search')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expired')
    ..hasRequiredFields = false
  ;

  ListUserPermissionsRequest._() : super();
  factory ListUserPermissionsRequest({
    $fixnum.Int64? userId,
    $core.int? limit,
    $core.int? offset,
    $core.String? search,
    $core.bool? expired,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (limit != null) {
      _result.limit = limit;
    }
    if (offset != null) {
      _result.offset = offset;
    }
    if (search != null) {
      _result.search = search;
    }
    if (expired != null) {
      _result.expired = expired;
    }
    return _result;
  }
  factory ListUserPermissionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListUserPermissionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListUserPermissionsRequest clone() => ListUserPermissionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListUserPermissionsRequest copyWith(void Function(ListUserPermissionsRequest) updates) => super.copyWith((message) => updates(message as ListUserPermissionsRequest)) as ListUserPermissionsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListUserPermissionsRequest create() => ListUserPermissionsRequest._();
  ListUserPermissionsRequest createEmptyInstance() => create();
  static $pb.PbList<ListUserPermissionsRequest> createRepeated() => $pb.PbList<ListUserPermissionsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListUserPermissionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListUserPermissionsRequest>(create);
  static ListUserPermissionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get offset => $_getIZ(2);
  @$pb.TagNumber(3)
  set offset($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get search => $_getSZ(3);
  @$pb.TagNumber(4)
  set search($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get expired => $_getBF(4);
  @$pb.TagNumber(5)
  set expired($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasExpired() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpired() => clearField(5);
}

class ListUserPermissionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListUserPermissionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..pc<UserPermission>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissions', $pb.PbFieldType.PM, subBuilder: UserPermission.create)
    ..hasRequiredFields = false
  ;

  ListUserPermissionsResponse._() : super();
  factory ListUserPermissionsResponse({
    $core.Iterable<UserPermission>? permissions,
  }) {
    final _result = create();
    if (permissions != null) {
      _result.permissions.addAll(permissions);
    }
    return _result;
  }
  factory ListUserPermissionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListUserPermissionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListUserPermissionsResponse clone() => ListUserPermissionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListUserPermissionsResponse copyWith(void Function(ListUserPermissionsResponse) updates) => super.copyWith((message) => updates(message as ListUserPermissionsResponse)) as ListUserPermissionsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListUserPermissionsResponse create() => ListUserPermissionsResponse._();
  ListUserPermissionsResponse createEmptyInstance() => create();
  static $pb.PbList<ListUserPermissionsResponse> createRepeated() => $pb.PbList<ListUserPermissionsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListUserPermissionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListUserPermissionsResponse>(create);
  static ListUserPermissionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<UserPermission> get permissions => $_getList(0);
}

class GetUserEffectivePermissionsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetUserEffectivePermissionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'limit', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offset', $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'search')
    ..hasRequiredFields = false
  ;

  GetUserEffectivePermissionsRequest._() : super();
  factory GetUserEffectivePermissionsRequest({
    $fixnum.Int64? userId,
    $core.int? limit,
    $core.int? offset,
    $core.String? search,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (limit != null) {
      _result.limit = limit;
    }
    if (offset != null) {
      _result.offset = offset;
    }
    if (search != null) {
      _result.search = search;
    }
    return _result;
  }
  factory GetUserEffectivePermissionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetUserEffectivePermissionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetUserEffectivePermissionsRequest clone() => GetUserEffectivePermissionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetUserEffectivePermissionsRequest copyWith(void Function(GetUserEffectivePermissionsRequest) updates) => super.copyWith((message) => updates(message as GetUserEffectivePermissionsRequest)) as GetUserEffectivePermissionsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetUserEffectivePermissionsRequest create() => GetUserEffectivePermissionsRequest._();
  GetUserEffectivePermissionsRequest createEmptyInstance() => create();
  static $pb.PbList<GetUserEffectivePermissionsRequest> createRepeated() => $pb.PbList<GetUserEffectivePermissionsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetUserEffectivePermissionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUserEffectivePermissionsRequest>(create);
  static GetUserEffectivePermissionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get offset => $_getIZ(2);
  @$pb.TagNumber(3)
  set offset($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get search => $_getSZ(3);
  @$pb.TagNumber(4)
  set search($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => clearField(4);
}

class EffectivePermission extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EffectivePermission', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionDisplayName')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionDescription')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'source')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sourceGroupId')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sourceGroupName')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sourceGroupDisplayName')
    ..aInt64(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiresAt')
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'grantedAt')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'grantedBy')
    ..hasRequiredFields = false
  ;

  EffectivePermission._() : super();
  factory EffectivePermission({
    $fixnum.Int64? permissionId,
    $core.String? permissionName,
    $core.String? permissionDisplayName,
    $core.String? permissionDescription,
    $core.String? source,
    $fixnum.Int64? sourceGroupId,
    $core.String? sourceGroupName,
    $core.String? sourceGroupDisplayName,
    $fixnum.Int64? expiresAt,
    $fixnum.Int64? grantedAt,
    $fixnum.Int64? grantedBy,
  }) {
    final _result = create();
    if (permissionId != null) {
      _result.permissionId = permissionId;
    }
    if (permissionName != null) {
      _result.permissionName = permissionName;
    }
    if (permissionDisplayName != null) {
      _result.permissionDisplayName = permissionDisplayName;
    }
    if (permissionDescription != null) {
      _result.permissionDescription = permissionDescription;
    }
    if (source != null) {
      _result.source = source;
    }
    if (sourceGroupId != null) {
      _result.sourceGroupId = sourceGroupId;
    }
    if (sourceGroupName != null) {
      _result.sourceGroupName = sourceGroupName;
    }
    if (sourceGroupDisplayName != null) {
      _result.sourceGroupDisplayName = sourceGroupDisplayName;
    }
    if (expiresAt != null) {
      _result.expiresAt = expiresAt;
    }
    if (grantedAt != null) {
      _result.grantedAt = grantedAt;
    }
    if (grantedBy != null) {
      _result.grantedBy = grantedBy;
    }
    return _result;
  }
  factory EffectivePermission.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EffectivePermission.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EffectivePermission clone() => EffectivePermission()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EffectivePermission copyWith(void Function(EffectivePermission) updates) => super.copyWith((message) => updates(message as EffectivePermission)) as EffectivePermission; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EffectivePermission create() => EffectivePermission._();
  EffectivePermission createEmptyInstance() => create();
  static $pb.PbList<EffectivePermission> createRepeated() => $pb.PbList<EffectivePermission>();
  @$core.pragma('dart2js:noInline')
  static EffectivePermission getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EffectivePermission>(create);
  static EffectivePermission? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get permissionId => $_getI64(0);
  @$pb.TagNumber(1)
  set permissionId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPermissionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPermissionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get permissionName => $_getSZ(1);
  @$pb.TagNumber(2)
  set permissionName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPermissionName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermissionName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get permissionDisplayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set permissionDisplayName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPermissionDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermissionDisplayName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get permissionDescription => $_getSZ(3);
  @$pb.TagNumber(4)
  set permissionDescription($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPermissionDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearPermissionDescription() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get source => $_getSZ(4);
  @$pb.TagNumber(5)
  set source($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get sourceGroupId => $_getI64(5);
  @$pb.TagNumber(6)
  set sourceGroupId($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSourceGroupId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceGroupId() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get sourceGroupName => $_getSZ(6);
  @$pb.TagNumber(7)
  set sourceGroupName($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSourceGroupName() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceGroupName() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get sourceGroupDisplayName => $_getSZ(7);
  @$pb.TagNumber(8)
  set sourceGroupDisplayName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSourceGroupDisplayName() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceGroupDisplayName() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get expiresAt => $_getI64(8);
  @$pb.TagNumber(9)
  set expiresAt($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasExpiresAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpiresAt() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get grantedAt => $_getI64(9);
  @$pb.TagNumber(10)
  set grantedAt($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasGrantedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearGrantedAt() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get grantedBy => $_getI64(10);
  @$pb.TagNumber(11)
  set grantedBy($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasGrantedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearGrantedBy() => clearField(11);
}

class GetUserEffectivePermissionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetUserEffectivePermissionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..pc<EffectivePermission>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissions', $pb.PbFieldType.PM, subBuilder: EffectivePermission.create)
    ..hasRequiredFields = false
  ;

  GetUserEffectivePermissionsResponse._() : super();
  factory GetUserEffectivePermissionsResponse({
    $core.Iterable<EffectivePermission>? permissions,
  }) {
    final _result = create();
    if (permissions != null) {
      _result.permissions.addAll(permissions);
    }
    return _result;
  }
  factory GetUserEffectivePermissionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetUserEffectivePermissionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetUserEffectivePermissionsResponse clone() => GetUserEffectivePermissionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetUserEffectivePermissionsResponse copyWith(void Function(GetUserEffectivePermissionsResponse) updates) => super.copyWith((message) => updates(message as GetUserEffectivePermissionsResponse)) as GetUserEffectivePermissionsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetUserEffectivePermissionsResponse create() => GetUserEffectivePermissionsResponse._();
  GetUserEffectivePermissionsResponse createEmptyInstance() => create();
  static $pb.PbList<GetUserEffectivePermissionsResponse> createRepeated() => $pb.PbList<GetUserEffectivePermissionsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetUserEffectivePermissionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUserEffectivePermissionsResponse>(create);
  static GetUserEffectivePermissionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<EffectivePermission> get permissions => $_getList(0);
}

