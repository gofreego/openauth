///
//  Generated code. Do not modify.
//  source: openauth/v1/configs.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class ValueType extends $pb.ProtobufEnum {
  static const ValueType VALUE_TYPE_UNSPECIFIED = ValueType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VALUE_TYPE_UNSPECIFIED');
  static const ValueType VALUE_TYPE_STRING = ValueType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VALUE_TYPE_STRING');
  static const ValueType VALUE_TYPE_INT = ValueType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VALUE_TYPE_INT');
  static const ValueType VALUE_TYPE_FLOAT = ValueType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VALUE_TYPE_FLOAT');
  static const ValueType VALUE_TYPE_BOOL = ValueType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VALUE_TYPE_BOOL');
  static const ValueType VALUE_TYPE_JSON = ValueType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VALUE_TYPE_JSON');
  static const ValueType VALUE_TYPE_CHOICE = ValueType._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VALUE_TYPE_CHOICE');

  static const $core.List<ValueType> values = <ValueType> [
    VALUE_TYPE_UNSPECIFIED,
    VALUE_TYPE_STRING,
    VALUE_TYPE_INT,
    VALUE_TYPE_FLOAT,
    VALUE_TYPE_BOOL,
    VALUE_TYPE_JSON,
    VALUE_TYPE_CHOICE,
  ];

  static final $core.Map<$core.int, ValueType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ValueType? valueOf($core.int value) => _byValue[value];

  const ValueType._($core.int v, $core.String n) : super(v, n);
}

