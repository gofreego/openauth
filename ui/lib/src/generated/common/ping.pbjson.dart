// This is a generated file - do not edit.
//
// Generated from common/ping.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use requestHeadersDescriptor instead')
const RequestHeaders$json = {
  '1': 'RequestHeaders',
  '2': [
    {
      '1': 'authorization',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'authorization',
      '17': true
    },
    {
      '1': 'x_client_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'xClientId',
      '17': true
    },
    {
      '1': 'x_client_version',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'xClientVersion',
      '17': true
    },
  ],
  '8': [
    {'1': '_authorization'},
    {'1': '_x_client_id'},
    {'1': '_x_client_version'},
  ],
};

/// Descriptor for `RequestHeaders`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestHeadersDescriptor = $convert.base64Decode(
    'Cg5SZXF1ZXN0SGVhZGVycxIpCg1hdXRob3JpemF0aW9uGAEgASgJSABSDWF1dGhvcml6YXRpb2'
    '6IAQESIwoLeF9jbGllbnRfaWQYAiABKAlIAVIJeENsaWVudElkiAEBEi0KEHhfY2xpZW50X3Zl'
    'cnNpb24YAyABKAlIAlIOeENsaWVudFZlcnNpb26IAQFCEAoOX2F1dGhvcml6YXRpb25CDgoMX3'
    'hfY2xpZW50X2lkQhMKEV94X2NsaWVudF92ZXJzaW9u');

@$core.Deprecated('Use pingRequestDescriptor instead')
const PingRequest$json = {
  '1': 'PingRequest',
  '2': [
    {
      '1': 'headers',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.v1.RequestHeaders',
      '10': 'headers'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `PingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingRequestDescriptor = $convert.base64Decode(
    'CgtQaW5nUmVxdWVzdBIsCgdoZWFkZXJzGAEgASgLMhIudjEuUmVxdWVzdEhlYWRlcnNSB2hlYW'
    'RlcnMSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use pingResponseDescriptor instead')
const PingResponse$json = {
  '1': 'PingResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `PingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingResponseDescriptor = $convert
    .base64Decode('CgxQaW5nUmVzcG9uc2USGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');
