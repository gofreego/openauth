///
//  Generated code. Do not modify.
//  source: openauth/v1/stats.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class StatsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StatsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  StatsRequest._() : super();
  factory StatsRequest() => create();
  factory StatsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StatsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StatsRequest clone() => StatsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StatsRequest copyWith(void Function(StatsRequest) updates) => super.copyWith((message) => updates(message as StatsRequest)) as StatsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StatsRequest create() => StatsRequest._();
  StatsRequest createEmptyInstance() => create();
  static $pb.PbList<StatsRequest> createRepeated() => $pb.PbList<StatsRequest>();
  @$core.pragma('dart2js:noInline')
  static StatsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StatsRequest>(create);
  static StatsRequest? _defaultInstance;
}

class StatsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'StatsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalUsers')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalPermissions')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalGroups')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'activeUsers')
    ..hasRequiredFields = false
  ;

  StatsResponse._() : super();
  factory StatsResponse({
    $fixnum.Int64? totalUsers,
    $fixnum.Int64? totalPermissions,
    $fixnum.Int64? totalGroups,
    $fixnum.Int64? activeUsers,
  }) {
    final _result = create();
    if (totalUsers != null) {
      _result.totalUsers = totalUsers;
    }
    if (totalPermissions != null) {
      _result.totalPermissions = totalPermissions;
    }
    if (totalGroups != null) {
      _result.totalGroups = totalGroups;
    }
    if (activeUsers != null) {
      _result.activeUsers = activeUsers;
    }
    return _result;
  }
  factory StatsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StatsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StatsResponse clone() => StatsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StatsResponse copyWith(void Function(StatsResponse) updates) => super.copyWith((message) => updates(message as StatsResponse)) as StatsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StatsResponse create() => StatsResponse._();
  StatsResponse createEmptyInstance() => create();
  static $pb.PbList<StatsResponse> createRepeated() => $pb.PbList<StatsResponse>();
  @$core.pragma('dart2js:noInline')
  static StatsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StatsResponse>(create);
  static StatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get totalUsers => $_getI64(0);
  @$pb.TagNumber(1)
  set totalUsers($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalUsers() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalUsers() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalPermissions => $_getI64(1);
  @$pb.TagNumber(2)
  set totalPermissions($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalPermissions() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalPermissions() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalGroups => $_getI64(2);
  @$pb.TagNumber(3)
  set totalGroups($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalGroups() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalGroups() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get activeUsers => $_getI64(3);
  @$pb.TagNumber(4)
  set activeUsers($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasActiveUsers() => $_has(3);
  @$pb.TagNumber(4)
  void clearActiveUsers() => clearField(4);
}

