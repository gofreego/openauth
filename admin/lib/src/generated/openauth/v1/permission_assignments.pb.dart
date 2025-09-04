///
//  Generated code. Do not modify.
//  source: openauth/v1/permission_assignments.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class AssignPermissionsToGroupRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AssignPermissionsToGroupRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId')
    ..p<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionsIds', $pb.PbFieldType.K6)
    ..hasRequiredFields = false
  ;

  AssignPermissionsToGroupRequest._() : super();
  factory AssignPermissionsToGroupRequest({
    $fixnum.Int64? groupId,
    $core.Iterable<$fixnum.Int64>? permissionsIds,
  }) {
    final _result = create();
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (permissionsIds != null) {
      _result.permissionsIds.addAll(permissionsIds);
    }
    return _result;
  }
  factory AssignPermissionsToGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignPermissionsToGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignPermissionsToGroupRequest clone() => AssignPermissionsToGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignPermissionsToGroupRequest copyWith(void Function(AssignPermissionsToGroupRequest) updates) => super.copyWith((message) => updates(message as AssignPermissionsToGroupRequest)) as AssignPermissionsToGroupRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AssignPermissionsToGroupRequest create() => AssignPermissionsToGroupRequest._();
  AssignPermissionsToGroupRequest createEmptyInstance() => create();
  static $pb.PbList<AssignPermissionsToGroupRequest> createRepeated() => $pb.PbList<AssignPermissionsToGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static AssignPermissionsToGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignPermissionsToGroupRequest>(create);
  static AssignPermissionsToGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get groupId => $_getI64(0);
  @$pb.TagNumber(1)
  set groupId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$fixnum.Int64> get permissionsIds => $_getList(1);
}

class AssignPermissionsToGroupResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AssignPermissionsToGroupResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  AssignPermissionsToGroupResponse._() : super();
  factory AssignPermissionsToGroupResponse({
    $core.String? message,
  }) {
    final _result = create();
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory AssignPermissionsToGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignPermissionsToGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignPermissionsToGroupResponse clone() => AssignPermissionsToGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignPermissionsToGroupResponse copyWith(void Function(AssignPermissionsToGroupResponse) updates) => super.copyWith((message) => updates(message as AssignPermissionsToGroupResponse)) as AssignPermissionsToGroupResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AssignPermissionsToGroupResponse create() => AssignPermissionsToGroupResponse._();
  AssignPermissionsToGroupResponse createEmptyInstance() => create();
  static $pb.PbList<AssignPermissionsToGroupResponse> createRepeated() => $pb.PbList<AssignPermissionsToGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static AssignPermissionsToGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignPermissionsToGroupResponse>(create);
  static AssignPermissionsToGroupResponse? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class RemovePermissionsFromGroupRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePermissionsFromGroupRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId')
    ..p<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionsIds', $pb.PbFieldType.K6)
    ..hasRequiredFields = false
  ;

  RemovePermissionsFromGroupRequest._() : super();
  factory RemovePermissionsFromGroupRequest({
    $fixnum.Int64? groupId,
    $core.Iterable<$fixnum.Int64>? permissionsIds,
  }) {
    final _result = create();
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (permissionsIds != null) {
      _result.permissionsIds.addAll(permissionsIds);
    }
    return _result;
  }
  factory RemovePermissionsFromGroupRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePermissionsFromGroupRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePermissionsFromGroupRequest clone() => RemovePermissionsFromGroupRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePermissionsFromGroupRequest copyWith(void Function(RemovePermissionsFromGroupRequest) updates) => super.copyWith((message) => updates(message as RemovePermissionsFromGroupRequest)) as RemovePermissionsFromGroupRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemovePermissionsFromGroupRequest create() => RemovePermissionsFromGroupRequest._();
  RemovePermissionsFromGroupRequest createEmptyInstance() => create();
  static $pb.PbList<RemovePermissionsFromGroupRequest> createRepeated() => $pb.PbList<RemovePermissionsFromGroupRequest>();
  @$core.pragma('dart2js:noInline')
  static RemovePermissionsFromGroupRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePermissionsFromGroupRequest>(create);
  static RemovePermissionsFromGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get groupId => $_getI64(0);
  @$pb.TagNumber(1)
  set groupId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$fixnum.Int64> get permissionsIds => $_getList(1);
}

class RemovePermissionsFromGroupResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePermissionsFromGroupResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  RemovePermissionsFromGroupResponse._() : super();
  factory RemovePermissionsFromGroupResponse({
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
  factory RemovePermissionsFromGroupResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePermissionsFromGroupResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePermissionsFromGroupResponse clone() => RemovePermissionsFromGroupResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePermissionsFromGroupResponse copyWith(void Function(RemovePermissionsFromGroupResponse) updates) => super.copyWith((message) => updates(message as RemovePermissionsFromGroupResponse)) as RemovePermissionsFromGroupResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemovePermissionsFromGroupResponse create() => RemovePermissionsFromGroupResponse._();
  RemovePermissionsFromGroupResponse createEmptyInstance() => create();
  static $pb.PbList<RemovePermissionsFromGroupResponse> createRepeated() => $pb.PbList<RemovePermissionsFromGroupResponse>();
  @$core.pragma('dart2js:noInline')
  static RemovePermissionsFromGroupResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePermissionsFromGroupResponse>(create);
  static RemovePermissionsFromGroupResponse? _defaultInstance;

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
    ..hasRequiredFields = false
  ;

  ListGroupPermissionsRequest._() : super();
  factory ListGroupPermissionsRequest({
    $fixnum.Int64? groupId,
  }) {
    final _result = create();
    if (groupId != null) {
      _result.groupId = groupId;
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
}

class ListGroupPermissionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListGroupPermissionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..pc<EffectivePermission>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissions', $pb.PbFieldType.PM, subBuilder: EffectivePermission.create)
    ..hasRequiredFields = false
  ;

  ListGroupPermissionsResponse._() : super();
  factory ListGroupPermissionsResponse({
    $core.Iterable<EffectivePermission>? permissions,
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
  $core.List<EffectivePermission> get permissions => $_getList(0);
}

class AssignPermissionsToUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AssignPermissionsToUserRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..p<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionsIds', $pb.PbFieldType.K6)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiresAt')
    ..hasRequiredFields = false
  ;

  AssignPermissionsToUserRequest._() : super();
  factory AssignPermissionsToUserRequest({
    $fixnum.Int64? userId,
    $core.Iterable<$fixnum.Int64>? permissionsIds,
    $fixnum.Int64? expiresAt,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (permissionsIds != null) {
      _result.permissionsIds.addAll(permissionsIds);
    }
    if (expiresAt != null) {
      _result.expiresAt = expiresAt;
    }
    return _result;
  }
  factory AssignPermissionsToUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignPermissionsToUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignPermissionsToUserRequest clone() => AssignPermissionsToUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignPermissionsToUserRequest copyWith(void Function(AssignPermissionsToUserRequest) updates) => super.copyWith((message) => updates(message as AssignPermissionsToUserRequest)) as AssignPermissionsToUserRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AssignPermissionsToUserRequest create() => AssignPermissionsToUserRequest._();
  AssignPermissionsToUserRequest createEmptyInstance() => create();
  static $pb.PbList<AssignPermissionsToUserRequest> createRepeated() => $pb.PbList<AssignPermissionsToUserRequest>();
  @$core.pragma('dart2js:noInline')
  static AssignPermissionsToUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignPermissionsToUserRequest>(create);
  static AssignPermissionsToUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$fixnum.Int64> get permissionsIds => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expiresAt => $_getI64(2);
  @$pb.TagNumber(3)
  set expiresAt($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasExpiresAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAt() => clearField(3);
}

class AssignPermissionsToUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AssignPermissionsToUserResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  AssignPermissionsToUserResponse._() : super();
  factory AssignPermissionsToUserResponse({
    $core.String? message,
  }) {
    final _result = create();
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory AssignPermissionsToUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignPermissionsToUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignPermissionsToUserResponse clone() => AssignPermissionsToUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignPermissionsToUserResponse copyWith(void Function(AssignPermissionsToUserResponse) updates) => super.copyWith((message) => updates(message as AssignPermissionsToUserResponse)) as AssignPermissionsToUserResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AssignPermissionsToUserResponse create() => AssignPermissionsToUserResponse._();
  AssignPermissionsToUserResponse createEmptyInstance() => create();
  static $pb.PbList<AssignPermissionsToUserResponse> createRepeated() => $pb.PbList<AssignPermissionsToUserResponse>();
  @$core.pragma('dart2js:noInline')
  static AssignPermissionsToUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignPermissionsToUserResponse>(create);
  static AssignPermissionsToUserResponse? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class RemovePermissionsFromUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePermissionsFromUserRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..p<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionsIds', $pb.PbFieldType.K6)
    ..hasRequiredFields = false
  ;

  RemovePermissionsFromUserRequest._() : super();
  factory RemovePermissionsFromUserRequest({
    $fixnum.Int64? userId,
    $core.Iterable<$fixnum.Int64>? permissionsIds,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (permissionsIds != null) {
      _result.permissionsIds.addAll(permissionsIds);
    }
    return _result;
  }
  factory RemovePermissionsFromUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePermissionsFromUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePermissionsFromUserRequest clone() => RemovePermissionsFromUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePermissionsFromUserRequest copyWith(void Function(RemovePermissionsFromUserRequest) updates) => super.copyWith((message) => updates(message as RemovePermissionsFromUserRequest)) as RemovePermissionsFromUserRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemovePermissionsFromUserRequest create() => RemovePermissionsFromUserRequest._();
  RemovePermissionsFromUserRequest createEmptyInstance() => create();
  static $pb.PbList<RemovePermissionsFromUserRequest> createRepeated() => $pb.PbList<RemovePermissionsFromUserRequest>();
  @$core.pragma('dart2js:noInline')
  static RemovePermissionsFromUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePermissionsFromUserRequest>(create);
  static RemovePermissionsFromUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$fixnum.Int64> get permissionsIds => $_getList(1);
}

class RemovePermissionsFromUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePermissionsFromUserResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  RemovePermissionsFromUserResponse._() : super();
  factory RemovePermissionsFromUserResponse({
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
  factory RemovePermissionsFromUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePermissionsFromUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePermissionsFromUserResponse clone() => RemovePermissionsFromUserResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePermissionsFromUserResponse copyWith(void Function(RemovePermissionsFromUserResponse) updates) => super.copyWith((message) => updates(message as RemovePermissionsFromUserResponse)) as RemovePermissionsFromUserResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RemovePermissionsFromUserResponse create() => RemovePermissionsFromUserResponse._();
  RemovePermissionsFromUserResponse createEmptyInstance() => create();
  static $pb.PbList<RemovePermissionsFromUserResponse> createRepeated() => $pb.PbList<RemovePermissionsFromUserResponse>();
  @$core.pragma('dart2js:noInline')
  static RemovePermissionsFromUserResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePermissionsFromUserResponse>(create);
  static RemovePermissionsFromUserResponse? _defaultInstance;

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
    ..hasRequiredFields = false
  ;

  ListUserPermissionsRequest._() : super();
  factory ListUserPermissionsRequest({
    $fixnum.Int64? userId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
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
}

class ListUserPermissionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListUserPermissionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..pc<EffectivePermission>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissions', $pb.PbFieldType.PM, subBuilder: EffectivePermission.create)
    ..hasRequiredFields = false
  ;

  ListUserPermissionsResponse._() : super();
  factory ListUserPermissionsResponse({
    $core.Iterable<EffectivePermission>? permissions,
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
  $core.List<EffectivePermission> get permissions => $_getList(0);
}

class GetUserEffectivePermissionsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetUserEffectivePermissionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false
  ;

  GetUserEffectivePermissionsRequest._() : super();
  factory GetUserEffectivePermissionsRequest({
    $fixnum.Int64? userId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
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
}

class EffectivePermission extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EffectivePermission', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionDisplayName')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'permissionDescription')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'source')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupId')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupName')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'groupDisplayName')
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
    $fixnum.Int64? groupId,
    $core.String? groupName,
    $core.String? groupDisplayName,
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
    if (groupId != null) {
      _result.groupId = groupId;
    }
    if (groupName != null) {
      _result.groupName = groupName;
    }
    if (groupDisplayName != null) {
      _result.groupDisplayName = groupDisplayName;
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
  $fixnum.Int64 get groupId => $_getI64(5);
  @$pb.TagNumber(6)
  set groupId($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasGroupId() => $_has(5);
  @$pb.TagNumber(6)
  void clearGroupId() => clearField(6);

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

