///
//  Generated code. Do not modify.
//  source: openauth/v1/configs.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use valueTypeDescriptor instead')
const ValueType$json = const {
  '1': 'ValueType',
  '2': const [
    const {'1': 'VALUE_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'VALUE_TYPE_STRING', '2': 1},
    const {'1': 'VALUE_TYPE_INT', '2': 2},
    const {'1': 'VALUE_TYPE_FLOAT', '2': 3},
    const {'1': 'VALUE_TYPE_BOOL', '2': 4},
    const {'1': 'VALUE_TYPE_JSON', '2': 5},
  ],
};

/// Descriptor for `ValueType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List valueTypeDescriptor = $convert.base64Decode('CglWYWx1ZVR5cGUSGgoWVkFMVUVfVFlQRV9VTlNQRUNJRklFRBAAEhUKEVZBTFVFX1RZUEVfU1RSSU5HEAESEgoOVkFMVUVfVFlQRV9JTlQQAhIUChBWQUxVRV9UWVBFX0ZMT0FUEAMSEwoPVkFMVUVfVFlQRV9CT09MEAQSEwoPVkFMVUVfVFlQRV9KU09OEAU=');
@$core.Deprecated('Use configEntityDescriptor instead')
const ConfigEntity$json = const {
  '1': 'ConfigEntity',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'read_perm', '3': 5, '4': 1, '5': 9, '10': 'readPerm'},
    const {'1': 'write_perm', '3': 6, '4': 1, '5': 9, '10': 'writePerm'},
    const {'1': 'created_by', '3': 7, '4': 1, '5': 3, '10': 'createdBy'},
    const {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 9, '4': 1, '5': 3, '10': 'updatedAt'},
    const {'1': 'is_system', '3': 10, '4': 1, '5': 8, '10': 'isSystem'},
  ],
};

/// Descriptor for `ConfigEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configEntityDescriptor = $convert.base64Decode('CgxDb25maWdFbnRpdHkSDgoCaWQYASABKANSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSIQoMZGlzcGxheV9uYW1lGAMgASgJUgtkaXNwbGF5TmFtZRIgCgtkZXNjcmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24SGwoJcmVhZF9wZXJtGAUgASgJUghyZWFkUGVybRIdCgp3cml0ZV9wZXJtGAYgASgJUgl3cml0ZVBlcm0SHQoKY3JlYXRlZF9ieRgHIAEoA1IJY3JlYXRlZEJ5Eh0KCmNyZWF0ZWRfYXQYCCABKANSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAkgASgDUgl1cGRhdGVkQXQSGwoJaXNfc3lzdGVtGAogASgIUghpc1N5c3RlbQ==');
@$core.Deprecated('Use configDescriptor instead')
const Config$json = const {
  '1': 'Config',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'entity_id', '3': 2, '4': 1, '5': 3, '10': 'entityId'},
    const {'1': 'key', '3': 3, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    const {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'string_value', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'stringValue'},
    const {'1': 'int_value', '3': 7, '4': 1, '5': 3, '9': 0, '10': 'intValue'},
    const {'1': 'float_value', '3': 8, '4': 1, '5': 1, '9': 0, '10': 'floatValue'},
    const {'1': 'bool_value', '3': 9, '4': 1, '5': 8, '9': 0, '10': 'boolValue'},
    const {'1': 'json_value', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'jsonValue'},
    const {'1': 'type', '3': 11, '4': 1, '5': 14, '6': '.v1.ValueType', '10': 'type'},
    const {'1': 'metadata', '3': 12, '4': 1, '5': 9, '9': 1, '10': 'metadata', '17': true},
    const {'1': 'created_by', '3': 13, '4': 1, '5': 3, '10': 'createdBy'},
    const {'1': 'updated_by', '3': 14, '4': 1, '5': 3, '10': 'updatedBy'},
    const {'1': 'created_at', '3': 15, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 16, '4': 1, '5': 3, '10': 'updatedAt'},
    const {'1': 'is_system', '3': 17, '4': 1, '5': 8, '10': 'isSystem'},
  ],
  '8': const [
    const {'1': 'value'},
    const {'1': '_metadata'},
  ],
};

/// Descriptor for `Config`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configDescriptor = $convert.base64Decode('CgZDb25maWcSDgoCaWQYASABKANSAmlkEhsKCWVudGl0eV9pZBgCIAEoA1IIZW50aXR5SWQSEAoDa2V5GAMgASgJUgNrZXkSIQoMZGlzcGxheV9uYW1lGAQgASgJUgtkaXNwbGF5TmFtZRIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24SIwoMc3RyaW5nX3ZhbHVlGAYgASgJSABSC3N0cmluZ1ZhbHVlEh0KCWludF92YWx1ZRgHIAEoA0gAUghpbnRWYWx1ZRIhCgtmbG9hdF92YWx1ZRgIIAEoAUgAUgpmbG9hdFZhbHVlEh8KCmJvb2xfdmFsdWUYCSABKAhIAFIJYm9vbFZhbHVlEh8KCmpzb25fdmFsdWUYCiABKAlIAFIJanNvblZhbHVlEiEKBHR5cGUYCyABKA4yDS52MS5WYWx1ZVR5cGVSBHR5cGUSHwoIbWV0YWRhdGEYDCABKAlIAVIIbWV0YWRhdGGIAQESHQoKY3JlYXRlZF9ieRgNIAEoA1IJY3JlYXRlZEJ5Eh0KCnVwZGF0ZWRfYnkYDiABKANSCXVwZGF0ZWRCeRIdCgpjcmVhdGVkX2F0GA8gASgDUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgQIAEoA1IJdXBkYXRlZEF0EhsKCWlzX3N5c3RlbRgRIAEoCFIIaXNTeXN0ZW1CBwoFdmFsdWVCCwoJX21ldGFkYXRh');
@$core.Deprecated('Use createConfigEntityRequestDescriptor instead')
const CreateConfigEntityRequest$json = const {
  '1': 'CreateConfigEntityRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'name'},
    const {'1': 'display_name', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'displayName'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'description'},
    const {'1': 'read_perm', '3': 4, '4': 1, '5': 9, '8': const {}, '10': 'readPerm'},
    const {'1': 'write_perm', '3': 5, '4': 1, '5': 9, '8': const {}, '10': 'writePerm'},
  ],
};

/// Descriptor for `CreateConfigEntityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createConfigEntityRequestDescriptor = $convert.base64Decode('ChlDcmVhdGVDb25maWdFbnRpdHlSZXF1ZXN0Eh4KBG5hbWUYASABKAlCCvpCB3IFEAEY/wFSBG5hbWUSLQoMZGlzcGxheV9uYW1lGAIgASgJQgr6QgdyBRADGP8BUgtkaXNwbGF5TmFtZRIsCgtkZXNjcmlwdGlvbhgDIAEoCUIK+kIHcgUQChj/AVILZGVzY3JpcHRpb24SJgoJcmVhZF9wZXJtGAQgASgJQgn6QgZyBBABGGRSCHJlYWRQZXJtEigKCndyaXRlX3Blcm0YBSABKAlCCfpCBnIEEAEYZFIJd3JpdGVQZXJt');
@$core.Deprecated('Use getConfigEntityRequestDescriptor instead')
const GetConfigEntityRequest$json = const {
  '1': 'GetConfigEntityRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'id'},
  ],
};

/// Descriptor for `GetConfigEntityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigEntityRequestDescriptor = $convert.base64Decode('ChZHZXRDb25maWdFbnRpdHlSZXF1ZXN0EhcKAmlkGAEgASgDQgf6QgQiAiAAUgJpZA==');
@$core.Deprecated('Use getConfigEntityByNameRequestDescriptor instead')
const GetConfigEntityByNameRequest$json = const {
  '1': 'GetConfigEntityByNameRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'name'},
  ],
};

/// Descriptor for `GetConfigEntityByNameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigEntityByNameRequestDescriptor = $convert.base64Decode('ChxHZXRDb25maWdFbnRpdHlCeU5hbWVSZXF1ZXN0Eh4KBG5hbWUYASABKAlCCvpCB3IFEAEY/wFSBG5hbWU=');
@$core.Deprecated('Use listConfigEntitiesRequestDescriptor instead')
const ListConfigEntitiesRequest$json = const {
  '1': 'ListConfigEntitiesRequest',
  '2': const [
    const {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
    const {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
    const {'1': 'search', '3': 3, '4': 1, '5': 9, '8': const {}, '9': 0, '10': 'search', '17': true},
    const {'1': 'all', '3': 4, '4': 1, '5': 8, '10': 'all'},
  ],
  '8': const [
    const {'1': '_search'},
  ],
};

/// Descriptor for `ListConfigEntitiesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConfigEntitiesRequestDescriptor = $convert.base64Decode('ChlMaXN0Q29uZmlnRW50aXRpZXNSZXF1ZXN0EhQKBWxpbWl0GAEgASgFUgVsaW1pdBIWCgZvZmZzZXQYAiABKAVSBm9mZnNldBIlCgZzZWFyY2gYAyABKAlCCPpCBXIDGP8BSABSBnNlYXJjaIgBARIQCgNhbGwYBCABKAhSA2FsbEIJCgdfc2VhcmNo');
@$core.Deprecated('Use listConfigEntitiesResponseDescriptor instead')
const ListConfigEntitiesResponse$json = const {
  '1': 'ListConfigEntitiesResponse',
  '2': const [
    const {'1': 'entities', '3': 1, '4': 3, '5': 11, '6': '.v1.ConfigEntity', '10': 'entities'},
  ],
};

/// Descriptor for `ListConfigEntitiesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConfigEntitiesResponseDescriptor = $convert.base64Decode('ChpMaXN0Q29uZmlnRW50aXRpZXNSZXNwb25zZRIsCghlbnRpdGllcxgBIAMoCzIQLnYxLkNvbmZpZ0VudGl0eVIIZW50aXRpZXM=');
@$core.Deprecated('Use updateConfigEntityRequestDescriptor instead')
const UpdateConfigEntityRequest$json = const {
  '1': 'UpdateConfigEntityRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '8': const {}, '9': 0, '10': 'name', '17': true},
    const {'1': 'display_name', '3': 3, '4': 1, '5': 9, '8': const {}, '9': 1, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '8': const {}, '9': 2, '10': 'description', '17': true},
    const {'1': 'read_perm', '3': 5, '4': 1, '5': 9, '8': const {}, '9': 3, '10': 'readPerm', '17': true},
    const {'1': 'write_perm', '3': 6, '4': 1, '5': 9, '8': const {}, '9': 4, '10': 'writePerm', '17': true},
  ],
  '8': const [
    const {'1': '_name'},
    const {'1': '_display_name'},
    const {'1': '_description'},
    const {'1': '_read_perm'},
    const {'1': '_write_perm'},
  ],
};

/// Descriptor for `UpdateConfigEntityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateConfigEntityRequestDescriptor = $convert.base64Decode('ChlVcGRhdGVDb25maWdFbnRpdHlSZXF1ZXN0EhcKAmlkGAEgASgDQgf6QgQiAiAAUgJpZBIjCgRuYW1lGAIgASgJQgr6QgdyBRADGP8BSABSBG5hbWWIAQESMgoMZGlzcGxheV9uYW1lGAMgASgJQgr6QgdyBRADGP8BSAFSC2Rpc3BsYXlOYW1liAEBEjEKC2Rlc2NyaXB0aW9uGAQgASgJQgr6QgdyBRAKGP8BSAJSC2Rlc2NyaXB0aW9uiAEBEisKCXJlYWRfcGVybRgFIAEoCUIJ+kIGcgQQARhkSANSCHJlYWRQZXJtiAEBEi0KCndyaXRlX3Blcm0YBiABKAlCCfpCBnIEEAEYZEgEUgl3cml0ZVBlcm2IAQFCBwoFX25hbWVCDwoNX2Rpc3BsYXlfbmFtZUIOCgxfZGVzY3JpcHRpb25CDAoKX3JlYWRfcGVybUINCgtfd3JpdGVfcGVybQ==');
@$core.Deprecated('Use deleteConfigEntityRequestDescriptor instead')
const DeleteConfigEntityRequest$json = const {
  '1': 'DeleteConfigEntityRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'id'},
  ],
};

/// Descriptor for `DeleteConfigEntityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteConfigEntityRequestDescriptor = $convert.base64Decode('ChlEZWxldGVDb25maWdFbnRpdHlSZXF1ZXN0EhcKAmlkGAEgASgDQgf6QgQiAiAAUgJpZA==');
@$core.Deprecated('Use createConfigRequestDescriptor instead')
const CreateConfigRequest$json = const {
  '1': 'CreateConfigRequest',
  '2': const [
    const {'1': 'entity_id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'entityId'},
    const {'1': 'key', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'key'},
    const {'1': 'display_name', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'displayName'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'string_value', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'stringValue'},
    const {'1': 'int_value', '3': 6, '4': 1, '5': 3, '9': 0, '10': 'intValue'},
    const {'1': 'float_value', '3': 7, '4': 1, '5': 1, '9': 0, '10': 'floatValue'},
    const {'1': 'bool_value', '3': 8, '4': 1, '5': 8, '9': 0, '10': 'boolValue'},
    const {'1': 'json_value', '3': 9, '4': 1, '5': 9, '9': 0, '10': 'jsonValue'},
    const {'1': 'type', '3': 10, '4': 1, '5': 14, '6': '.v1.ValueType', '10': 'type'},
    const {'1': 'metadata', '3': 11, '4': 1, '5': 9, '9': 1, '10': 'metadata', '17': true},
  ],
  '8': const [
    const {'1': 'value'},
    const {'1': '_metadata'},
  ],
};

/// Descriptor for `CreateConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createConfigRequestDescriptor = $convert.base64Decode('ChNDcmVhdGVDb25maWdSZXF1ZXN0EiQKCWVudGl0eV9pZBgBIAEoA0IH+kIEIgIgAFIIZW50aXR5SWQSHAoDa2V5GAIgASgJQgr6QgdyBRABGP8BUgNrZXkSKwoMZGlzcGxheV9uYW1lGAMgASgJQgj6QgVyAxj/AVILZGlzcGxheU5hbWUSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEiMKDHN0cmluZ192YWx1ZRgFIAEoCUgAUgtzdHJpbmdWYWx1ZRIdCglpbnRfdmFsdWUYBiABKANIAFIIaW50VmFsdWUSIQoLZmxvYXRfdmFsdWUYByABKAFIAFIKZmxvYXRWYWx1ZRIfCgpib29sX3ZhbHVlGAggASgISABSCWJvb2xWYWx1ZRIfCgpqc29uX3ZhbHVlGAkgASgJSABSCWpzb25WYWx1ZRIhCgR0eXBlGAogASgOMg0udjEuVmFsdWVUeXBlUgR0eXBlEh8KCG1ldGFkYXRhGAsgASgJSAFSCG1ldGFkYXRhiAEBQgcKBXZhbHVlQgsKCV9tZXRhZGF0YQ==');
@$core.Deprecated('Use updateConfigRequestDescriptor instead')
const UpdateConfigRequest$json = const {
  '1': 'UpdateConfigRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '8': const {}, '9': 1, '10': 'name', '17': true},
    const {'1': 'display_name', '3': 3, '4': 1, '5': 9, '8': const {}, '9': 2, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '9': 3, '10': 'description', '17': true},
    const {'1': 'string_value', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'stringValue'},
    const {'1': 'int_value', '3': 6, '4': 1, '5': 3, '9': 0, '10': 'intValue'},
    const {'1': 'float_value', '3': 7, '4': 1, '5': 1, '9': 0, '10': 'floatValue'},
    const {'1': 'bool_value', '3': 8, '4': 1, '5': 8, '9': 0, '10': 'boolValue'},
    const {'1': 'json_value', '3': 9, '4': 1, '5': 9, '9': 0, '10': 'jsonValue'},
    const {'1': 'metadata', '3': 10, '4': 1, '5': 9, '9': 4, '10': 'metadata', '17': true},
  ],
  '8': const [
    const {'1': 'value'},
    const {'1': '_name'},
    const {'1': '_display_name'},
    const {'1': '_description'},
    const {'1': '_metadata'},
  ],
};

/// Descriptor for `UpdateConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateConfigRequestDescriptor = $convert.base64Decode('ChNVcGRhdGVDb25maWdSZXF1ZXN0EhcKAmlkGAEgASgDQgf6QgQiAiAAUgJpZBIjCgRuYW1lGAIgASgJQgr6QgdyBRABGP8BSAFSBG5hbWWIAQESMAoMZGlzcGxheV9uYW1lGAMgASgJQgj6QgVyAxj/AUgCUgtkaXNwbGF5TmFtZYgBARIlCgtkZXNjcmlwdGlvbhgEIAEoCUgDUgtkZXNjcmlwdGlvbogBARIjCgxzdHJpbmdfdmFsdWUYBSABKAlIAFILc3RyaW5nVmFsdWUSHQoJaW50X3ZhbHVlGAYgASgDSABSCGludFZhbHVlEiEKC2Zsb2F0X3ZhbHVlGAcgASgBSABSCmZsb2F0VmFsdWUSHwoKYm9vbF92YWx1ZRgIIAEoCEgAUglib29sVmFsdWUSHwoKanNvbl92YWx1ZRgJIAEoCUgAUglqc29uVmFsdWUSHwoIbWV0YWRhdGEYCiABKAlIBFIIbWV0YWRhdGGIAQFCBwoFdmFsdWVCBwoFX25hbWVCDwoNX2Rpc3BsYXlfbmFtZUIOCgxfZGVzY3JpcHRpb25CCwoJX21ldGFkYXRh');
@$core.Deprecated('Use deleteConfigRequestDescriptor instead')
const DeleteConfigRequest$json = const {
  '1': 'DeleteConfigRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'id'},
  ],
};

/// Descriptor for `DeleteConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteConfigRequestDescriptor = $convert.base64Decode('ChNEZWxldGVDb25maWdSZXF1ZXN0EhcKAmlkGAEgASgDQgf6QgQiAiAAUgJpZA==');
@$core.Deprecated('Use getConfigRequestDescriptor instead')
const GetConfigRequest$json = const {
  '1': 'GetConfigRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'id'},
  ],
};

/// Descriptor for `GetConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigRequestDescriptor = $convert.base64Decode('ChBHZXRDb25maWdSZXF1ZXN0EhcKAmlkGAEgASgDQgf6QgQiAiAAUgJpZA==');
@$core.Deprecated('Use getConfigByKeyRequestDescriptor instead')
const GetConfigByKeyRequest$json = const {
  '1': 'GetConfigByKeyRequest',
  '2': const [
    const {'1': 'entity_name', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'entityName'},
    const {'1': 'key', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'key'},
  ],
};

/// Descriptor for `GetConfigByKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigByKeyRequestDescriptor = $convert.base64Decode('ChVHZXRDb25maWdCeUtleVJlcXVlc3QSKwoLZW50aXR5X25hbWUYAiABKAlCCvpCB3IFEAEY/wFSCmVudGl0eU5hbWUSHAoDa2V5GAMgASgJQgr6QgdyBRABGP8BUgNrZXk=');
@$core.Deprecated('Use listConfigsRequestDescriptor instead')
const ListConfigsRequest$json = const {
  '1': 'ListConfigsRequest',
  '2': const [
    const {'1': 'entity_id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'entityId'},
    const {'1': 'limit', '3': 2, '4': 1, '5': 5, '9': 0, '10': 'limit', '17': true},
    const {'1': 'offset', '3': 3, '4': 1, '5': 5, '9': 1, '10': 'offset', '17': true},
    const {'1': 'search', '3': 4, '4': 1, '5': 9, '8': const {}, '9': 2, '10': 'search', '17': true},
    const {'1': 'all', '3': 6, '4': 1, '5': 8, '10': 'all'},
  ],
  '8': const [
    const {'1': '_limit'},
    const {'1': '_offset'},
    const {'1': '_search'},
  ],
};

/// Descriptor for `ListConfigsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConfigsRequestDescriptor = $convert.base64Decode('ChJMaXN0Q29uZmlnc1JlcXVlc3QSJAoJZW50aXR5X2lkGAEgASgDQgf6QgQiAiAAUghlbnRpdHlJZBIZCgVsaW1pdBgCIAEoBUgAUgVsaW1pdIgBARIbCgZvZmZzZXQYAyABKAVIAVIGb2Zmc2V0iAEBEiUKBnNlYXJjaBgEIAEoCUII+kIFcgMY/wFIAlIGc2VhcmNoiAEBEhAKA2FsbBgGIAEoCFIDYWxsQggKBl9saW1pdEIJCgdfb2Zmc2V0QgkKB19zZWFyY2g=');
@$core.Deprecated('Use listConfigsResponseDescriptor instead')
const ListConfigsResponse$json = const {
  '1': 'ListConfigsResponse',
  '2': const [
    const {'1': 'configs', '3': 1, '4': 3, '5': 11, '6': '.v1.Config', '10': 'configs'},
    const {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListConfigsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConfigsResponseDescriptor = $convert.base64Decode('ChNMaXN0Q29uZmlnc1Jlc3BvbnNlEiQKB2NvbmZpZ3MYASADKAsyCi52MS5Db25maWdSB2NvbmZpZ3MSFAoFdG90YWwYAiABKANSBXRvdGFs');
@$core.Deprecated('Use getConfigsByKeysRequestDescriptor instead')
const GetConfigsByKeysRequest$json = const {
  '1': 'GetConfigsByKeysRequest',
  '2': const [
    const {'1': 'entity_name', '3': 2, '4': 1, '5': 9, '8': const {}, '10': 'entityName'},
    const {'1': 'keys', '3': 3, '4': 3, '5': 9, '8': const {}, '10': 'keys'},
  ],
};

/// Descriptor for `GetConfigsByKeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigsByKeysRequestDescriptor = $convert.base64Decode('ChdHZXRDb25maWdzQnlLZXlzUmVxdWVzdBIrCgtlbnRpdHlfbmFtZRgCIAEoCUIK+kIHcgUQARj/AVIKZW50aXR5TmFtZRInCgRrZXlzGAMgAygJQhP6QhCSAQ0IARBkIgdyBRABGP8BUgRrZXlz');
@$core.Deprecated('Use getConfigsByKeysResponseDescriptor instead')
const GetConfigsByKeysResponse$json = const {
  '1': 'GetConfigsByKeysResponse',
  '2': const [
    const {'1': 'configs', '3': 1, '4': 3, '5': 11, '6': '.v1.GetConfigsByKeysResponse.ConfigsEntry', '10': 'configs'},
  ],
  '3': const [GetConfigsByKeysResponse_ConfigsEntry$json],
};

@$core.Deprecated('Use getConfigsByKeysResponseDescriptor instead')
const GetConfigsByKeysResponse_ConfigsEntry$json = const {
  '1': 'ConfigsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.v1.Config', '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `GetConfigsByKeysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigsByKeysResponseDescriptor = $convert.base64Decode('ChhHZXRDb25maWdzQnlLZXlzUmVzcG9uc2USQwoHY29uZmlncxgBIAMoCzIpLnYxLkdldENvbmZpZ3NCeUtleXNSZXNwb25zZS5Db25maWdzRW50cnlSB2NvbmZpZ3MaRgoMQ29uZmlnc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EiAKBXZhbHVlGAIgASgLMgoudjEuQ29uZmlnUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use deleteResponseDescriptor instead')
const DeleteResponse$json = const {
  '1': 'DeleteResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'message', '17': true},
  ],
  '8': const [
    const {'1': '_message'},
  ],
};

/// Descriptor for `DeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteResponseDescriptor = $convert.base64Decode('Cg5EZWxldGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh0KB21lc3NhZ2UYAiABKAlIAFIHbWVzc2FnZYgBAUIKCghfbWVzc2FnZQ==');
@$core.Deprecated('Use updateResponseDescriptor instead')
const UpdateResponse$json = const {
  '1': 'UpdateResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'message', '17': true},
  ],
  '8': const [
    const {'1': '_message'},
  ],
};

/// Descriptor for `UpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateResponseDescriptor = $convert.base64Decode('Cg5VcGRhdGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEh0KB21lc3NhZ2UYAiABKAlIAFIHbWVzc2FnZYgBAUIKCghfbWVzc2FnZQ==');
@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = const {
  '1': 'Metadata',
  '2': const [
    const {'1': 'options', '3': 1, '4': 3, '5': 9, '10': 'options'},
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode('CghNZXRhZGF0YRIYCgdvcHRpb25zGAEgAygJUgdvcHRpb25z');
