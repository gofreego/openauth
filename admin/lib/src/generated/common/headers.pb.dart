///
//  Generated code. Do not modify.
//  source: common/headers.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RequestHeaders extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RequestHeaders', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'v1'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authorization')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'xClientId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'xClientVersion')
    ..hasRequiredFields = false
  ;

  RequestHeaders._() : super();
  factory RequestHeaders({
    $core.String? authorization,
    $core.String? xClientId,
    $core.String? xClientVersion,
  }) {
    final _result = create();
    if (authorization != null) {
      _result.authorization = authorization;
    }
    if (xClientId != null) {
      _result.xClientId = xClientId;
    }
    if (xClientVersion != null) {
      _result.xClientVersion = xClientVersion;
    }
    return _result;
  }
  factory RequestHeaders.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RequestHeaders.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RequestHeaders clone() => RequestHeaders()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RequestHeaders copyWith(void Function(RequestHeaders) updates) => super.copyWith((message) => updates(message as RequestHeaders)) as RequestHeaders; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RequestHeaders create() => RequestHeaders._();
  RequestHeaders createEmptyInstance() => create();
  static $pb.PbList<RequestHeaders> createRepeated() => $pb.PbList<RequestHeaders>();
  @$core.pragma('dart2js:noInline')
  static RequestHeaders getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RequestHeaders>(create);
  static RequestHeaders? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get authorization => $_getSZ(0);
  @$pb.TagNumber(1)
  set authorization($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAuthorization() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthorization() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get xClientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set xClientId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasXClientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearXClientId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get xClientVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set xClientVersion($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasXClientVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearXClientVersion() => clearField(3);
}

