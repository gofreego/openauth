// This is a generated file - do not edit.
//
// Generated from common/ping.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Common header fields for authentication and client identification
class RequestHeaders extends $pb.GeneratedMessage {
  factory RequestHeaders({
    $core.String? authorization,
    $core.String? xClientId,
    $core.String? xClientVersion,
  }) {
    final result = create();
    if (authorization != null) result.authorization = authorization;
    if (xClientId != null) result.xClientId = xClientId;
    if (xClientVersion != null) result.xClientVersion = xClientVersion;
    return result;
  }

  RequestHeaders._();

  factory RequestHeaders.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestHeaders.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestHeaders',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'authorization')
    ..aOS(2, _omitFieldNames ? '' : 'xClientId')
    ..aOS(3, _omitFieldNames ? '' : 'xClientVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHeaders clone() => RequestHeaders()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestHeaders copyWith(void Function(RequestHeaders) updates) =>
      super.copyWith((message) => updates(message as RequestHeaders))
          as RequestHeaders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestHeaders create() => RequestHeaders._();
  @$core.override
  RequestHeaders createEmptyInstance() => create();
  static $pb.PbList<RequestHeaders> createRepeated() =>
      $pb.PbList<RequestHeaders>();
  @$core.pragma('dart2js:noInline')
  static RequestHeaders getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestHeaders>(create);
  static RequestHeaders? _defaultInstance;

  /// JWT authentication token
  @$pb.TagNumber(1)
  $core.String get authorization => $_getSZ(0);
  @$pb.TagNumber(1)
  set authorization($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthorization() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthorization() => $_clearField(1);

  /// Client identifier for tracking and analytics
  @$pb.TagNumber(2)
  $core.String get xClientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set xClientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasXClientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearXClientId() => $_clearField(2);

  /// Client version for compatibility and feature tracking
  @$pb.TagNumber(3)
  $core.String get xClientVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set xClientVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasXClientVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearXClientVersion() => $_clearField(3);
}

/// PingRequest is the request message for the Ping RPC method.
class PingRequest extends $pb.GeneratedMessage {
  factory PingRequest({
    RequestHeaders? headers,
    $core.String? message,
  }) {
    final result = create();
    if (headers != null) result.headers = headers;
    if (message != null) result.message = message;
    return result;
  }

  PingRequest._();

  factory PingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'),
      createEmptyInstance: create)
    ..aOM<RequestHeaders>(1, _omitFieldNames ? '' : 'headers',
        subBuilder: RequestHeaders.create)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingRequest copyWith(void Function(PingRequest) updates) =>
      super.copyWith((message) => updates(message as PingRequest))
          as PingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingRequest create() => PingRequest._();
  @$core.override
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() => $pb.PbList<PingRequest>();
  @$core.pragma('dart2js:noInline')
  static PingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PingRequest>(create);
  static PingRequest? _defaultInstance;

  /// Common header fields for authentication and client identification
  @$pb.TagNumber(1)
  RequestHeaders get headers => $_getN(0);
  @$pb.TagNumber(1)
  set headers(RequestHeaders value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHeaders() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeaders() => $_clearField(1);
  @$pb.TagNumber(1)
  RequestHeaders ensureHeaders() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

/// PingResponse is the response message for the Ping RPC method.
class PingResponse extends $pb.GeneratedMessage {
  factory PingResponse({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  PingResponse._();

  factory PingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingResponse clone() => PingResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingResponse copyWith(void Function(PingResponse) updates) =>
      super.copyWith((message) => updates(message as PingResponse))
          as PingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingResponse create() => PingResponse._();
  @$core.override
  PingResponse createEmptyInstance() => create();
  static $pb.PbList<PingResponse> createRepeated() =>
      $pb.PbList<PingResponse>();
  @$core.pragma('dart2js:noInline')
  static PingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PingResponse>(create);
  static PingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
