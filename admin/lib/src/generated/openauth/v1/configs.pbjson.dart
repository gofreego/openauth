///
//  Generated code. Do not modify.
//  source: openauth/v1/configs.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use configEntityDescriptor instead')
const ConfigEntity$json = const {
  '1': 'ConfigEntity',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'display_name', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'description', '17': true},
    const {'1': 'read_perm', '3': 5, '4': 1, '5': 3, '10': 'readPerm'},
    const {'1': 'write_perm', '3': 6, '4': 1, '5': 3, '10': 'writePerm'},
    const {'1': 'created_by', '3': 7, '4': 1, '5': 3, '10': 'createdBy'},
    const {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 9, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '8': const [
    const {'1': '_display_name'},
    const {'1': '_description'},
  ],
};

/// Descriptor for `ConfigEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configEntityDescriptor = $convert.base64Decode('CgxDb25maWdFbnRpdHkSDgoCaWQYASABKANSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSJgoMZGlzcGxheV9uYW1lGAMgASgJSABSC2Rpc3BsYXlOYW1liAEBEiUKC2Rlc2NyaXB0aW9uGAQgASgJSAFSC2Rlc2NyaXB0aW9uiAEBEhsKCXJlYWRfcGVybRgFIAEoA1IIcmVhZFBlcm0SHQoKd3JpdGVfcGVybRgGIAEoA1IJd3JpdGVQZXJtEh0KCmNyZWF0ZWRfYnkYByABKANSCWNyZWF0ZWRCeRIdCgpjcmVhdGVkX2F0GAggASgDUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgJIAEoA1IJdXBkYXRlZEF0Qg8KDV9kaXNwbGF5X25hbWVCDgoMX2Rlc2NyaXB0aW9u');
@$core.Deprecated('Use configDescriptor instead')
const Config$json = const {
  '1': 'Config',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'entity_id', '3': 2, '4': 1, '5': 3, '10': 'entityId'},
    const {'1': 'key', '3': 3, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'display_name', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 5, '4': 1, '5': 9, '9': 2, '10': 'description', '17': true},
    const {'1': 'string_value', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'stringValue'},
    const {'1': 'int_value', '3': 7, '4': 1, '5': 3, '9': 0, '10': 'intValue'},
    const {'1': 'float_value', '3': 8, '4': 1, '5': 1, '9': 0, '10': 'floatValue'},
    const {'1': 'bool_value', '3': 9, '4': 1, '5': 8, '9': 0, '10': 'boolValue'},
    const {'1': 'json_value', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'jsonValue'},
    const {'1': 'type', '3': 11, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'metadata', '3': 12, '4': 1, '5': 9, '10': 'metadata'},
    const {'1': 'created_by', '3': 13, '4': 1, '5': 3, '10': 'createdBy'},
    const {'1': 'updated_by', '3': 14, '4': 1, '5': 3, '10': 'updatedBy'},
    const {'1': 'created_at', '3': 15, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 16, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '8': const [
    const {'1': 'value'},
    const {'1': '_display_name'},
    const {'1': '_description'},
  ],
};

/// Descriptor for `Config`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configDescriptor = $convert.base64Decode('CgZDb25maWcSDgoCaWQYASABKANSAmlkEhsKCWVudGl0eV9pZBgCIAEoA1IIZW50aXR5SWQSEAoDa2V5GAMgASgJUgNrZXkSJgoMZGlzcGxheV9uYW1lGAQgASgJSAFSC2Rpc3BsYXlOYW1liAEBEiUKC2Rlc2NyaXB0aW9uGAUgASgJSAJSC2Rlc2NyaXB0aW9uiAEBEiMKDHN0cmluZ192YWx1ZRgGIAEoCUgAUgtzdHJpbmdWYWx1ZRIdCglpbnRfdmFsdWUYByABKANIAFIIaW50VmFsdWUSIQoLZmxvYXRfdmFsdWUYCCABKAFIAFIKZmxvYXRWYWx1ZRIfCgpib29sX3ZhbHVlGAkgASgISABSCWJvb2xWYWx1ZRIfCgpqc29uX3ZhbHVlGAogASgJSABSCWpzb25WYWx1ZRISCgR0eXBlGAsgASgJUgR0eXBlEhoKCG1ldGFkYXRhGAwgASgJUghtZXRhZGF0YRIdCgpjcmVhdGVkX2J5GA0gASgDUgljcmVhdGVkQnkSHQoKdXBkYXRlZF9ieRgOIAEoA1IJdXBkYXRlZEJ5Eh0KCmNyZWF0ZWRfYXQYDyABKANSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GBAgASgDUgl1cGRhdGVkQXRCBwoFdmFsdWVCDwoNX2Rpc3BsYXlfbmFtZUIOCgxfZGVzY3JpcHRpb24=');
@$core.Deprecated('Use createConfigEntityRequestDescriptor instead')
const CreateConfigEntityRequest$json = const {
  '1': 'CreateConfigEntityRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '8': const {}, '10': 'name'},
    const {'1': 'display_name', '3': 2, '4': 1, '5': 9, '8': const {}, '9': 0, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'description', '17': true},
    const {'1': 'read_perm', '3': 4, '4': 1, '5': 3, '8': const {}, '10': 'readPerm'},
    const {'1': 'write_perm', '3': 5, '4': 1, '5': 3, '8': const {}, '10': 'writePerm'},
  ],
  '8': const [
    const {'1': '_display_name'},
    const {'1': '_description'},
  ],
};

/// Descriptor for `CreateConfigEntityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createConfigEntityRequestDescriptor = $convert.base64Decode('ChlDcmVhdGVDb25maWdFbnRpdHlSZXF1ZXN0EjIKBG5hbWUYASABKAlCHvpCG3IZEAEY/wEyEl5bYS16XVthLXowLTlfLV0qJFIEbmFtZRIwCgxkaXNwbGF5X25hbWUYAiABKAlCCPpCBXIDGP8BSABSC2Rpc3BsYXlOYW1liAEBEiUKC2Rlc2NyaXB0aW9uGAMgASgJSAFSC2Rlc2NyaXB0aW9uiAEBEiQKCXJlYWRfcGVybRgEIAEoA0IH+kIEIgIgAFIIcmVhZFBlcm0SJgoKd3JpdGVfcGVybRgFIAEoA0IH+kIEIgIgAFIJd3JpdGVQZXJtQg8KDV9kaXNwbGF5X25hbWVCDgoMX2Rlc2NyaXB0aW9u');
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
    const {'1': 'limit', '3': 1, '4': 1, '5': 5, '8': const {}, '10': 'limit'},
    const {'1': 'offset', '3': 2, '4': 1, '5': 5, '8': const {}, '10': 'offset'},
    const {'1': 'search', '3': 3, '4': 1, '5': 9, '8': const {}, '9': 0, '10': 'search', '17': true},
    const {'1': 'all', '3': 4, '4': 1, '5': 8, '10': 'all'},
  ],
  '8': const [
    const {'1': '_search'},
  ],
};

/// Descriptor for `ListConfigEntitiesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConfigEntitiesRequestDescriptor = $convert.base64Decode('ChlMaXN0Q29uZmlnRW50aXRpZXNSZXF1ZXN0Eh8KBWxpbWl0GAEgASgFQgn6QgYaBBhkKAFSBWxpbWl0Eh8KBm9mZnNldBgCIAEoBUIH+kIEGgIoAFIGb2Zmc2V0EiUKBnNlYXJjaBgDIAEoCUII+kIFcgMY/wFIAFIGc2VhcmNoiAEBEhAKA2FsbBgEIAEoCFIDYWxsQgkKB19zZWFyY2g=');
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
    const {'1': 'display_name', '3': 2, '4': 1, '5': 9, '8': const {}, '9': 0, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'description', '17': true},
    const {'1': 'read_perm', '3': 4, '4': 1, '5': 3, '8': const {}, '9': 2, '10': 'readPerm', '17': true},
    const {'1': 'write_perm', '3': 5, '4': 1, '5': 3, '8': const {}, '9': 3, '10': 'writePerm', '17': true},
  ],
  '8': const [
    const {'1': '_display_name'},
    const {'1': '_description'},
    const {'1': '_read_perm'},
    const {'1': '_write_perm'},
  ],
};

/// Descriptor for `UpdateConfigEntityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateConfigEntityRequestDescriptor = $convert.base64Decode('ChlVcGRhdGVDb25maWdFbnRpdHlSZXF1ZXN0EhcKAmlkGAEgASgDQgf6QgQiAiAAUgJpZBIwCgxkaXNwbGF5X25hbWUYAiABKAlCCPpCBXIDGP8BSABSC2Rpc3BsYXlOYW1liAEBEiUKC2Rlc2NyaXB0aW9uGAMgASgJSAFSC2Rlc2NyaXB0aW9uiAEBEikKCXJlYWRfcGVybRgEIAEoA0IH+kIEIgIgAEgCUghyZWFkUGVybYgBARIrCgp3cml0ZV9wZXJtGAUgASgDQgf6QgQiAiAASANSCXdyaXRlUGVybYgBAUIPCg1fZGlzcGxheV9uYW1lQg4KDF9kZXNjcmlwdGlvbkIMCgpfcmVhZF9wZXJtQg0KC193cml0ZV9wZXJt');
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
    const {'1': 'display_name', '3': 3, '4': 1, '5': 9, '8': const {}, '9': 1, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'description', '17': true},
    const {'1': 'string_value', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'stringValue'},
    const {'1': 'int_value', '3': 6, '4': 1, '5': 3, '9': 0, '10': 'intValue'},
    const {'1': 'float_value', '3': 7, '4': 1, '5': 1, '9': 0, '10': 'floatValue'},
    const {'1': 'bool_value', '3': 8, '4': 1, '5': 8, '9': 0, '10': 'boolValue'},
    const {'1': 'json_value', '3': 9, '4': 1, '5': 9, '9': 0, '10': 'jsonValue'},
    const {'1': 'type', '3': 10, '4': 1, '5': 9, '8': const {}, '10': 'type'},
    const {'1': 'metadata', '3': 11, '4': 1, '5': 9, '9': 3, '10': 'metadata', '17': true},
  ],
  '8': const [
    const {'1': 'value'},
    const {'1': '_display_name'},
    const {'1': '_description'},
    const {'1': '_metadata'},
  ],
};

/// Descriptor for `CreateConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createConfigRequestDescriptor = $convert.base64Decode('ChNDcmVhdGVDb25maWdSZXF1ZXN0EiQKCWVudGl0eV9pZBgBIAEoA0IH+kIEIgIgAFIIZW50aXR5SWQSNwoDa2V5GAIgASgJQiX6QiJyIBABGP8BMhleW2EtekEtWl1bYS16QS1aMC05Xy4tXSokUgNrZXkSMAoMZGlzcGxheV9uYW1lGAMgASgJQgj6QgVyAxj/AUgBUgtkaXNwbGF5TmFtZYgBARIlCgtkZXNjcmlwdGlvbhgEIAEoCUgCUgtkZXNjcmlwdGlvbogBARIjCgxzdHJpbmdfdmFsdWUYBSABKAlIAFILc3RyaW5nVmFsdWUSHQoJaW50X3ZhbHVlGAYgASgDSABSCGludFZhbHVlEiEKC2Zsb2F0X3ZhbHVlGAcgASgBSABSCmZsb2F0VmFsdWUSHwoKYm9vbF92YWx1ZRgIIAEoCEgAUglib29sVmFsdWUSHwoKanNvbl92YWx1ZRgJIAEoCUgAUglqc29uVmFsdWUSQQoEdHlwZRgKIAEoCUIt+kIqcihSBnN0cmluZ1IDaW50UgVmbG9hdFIEYm9vbFIEanNvblIGY2hvaWNlUgR0eXBlEh8KCG1ldGFkYXRhGAsgASgJSANSCG1ldGFkYXRhiAEBQgcKBXZhbHVlQg8KDV9kaXNwbGF5X25hbWVCDgoMX2Rlc2NyaXB0aW9uQgsKCV9tZXRhZGF0YQ==');
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
    const {'1': 'entity_id', '3': 1, '4': 1, '5': 3, '8': const {}, '9': 0, '10': 'entityId'},
    const {'1': 'entity_name', '3': 2, '4': 1, '5': 9, '8': const {}, '9': 0, '10': 'entityName'},
    const {'1': 'key', '3': 3, '4': 1, '5': 9, '8': const {}, '10': 'key'},
  ],
  '8': const [
    const {'1': 'entity_identifier'},
  ],
};

/// Descriptor for `GetConfigByKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigByKeyRequestDescriptor = $convert.base64Decode('ChVHZXRDb25maWdCeUtleVJlcXVlc3QSJgoJZW50aXR5X2lkGAEgASgDQgf6QgQiAiAASABSCGVudGl0eUlkEi0KC2VudGl0eV9uYW1lGAIgASgJQgr6QgdyBRABGP8BSABSCmVudGl0eU5hbWUSHAoDa2V5GAMgASgJQgr6QgdyBRABGP8BUgNrZXlCEwoRZW50aXR5X2lkZW50aWZpZXI=');
@$core.Deprecated('Use listConfigsRequestDescriptor instead')
const ListConfigsRequest$json = const {
  '1': 'ListConfigsRequest',
  '2': const [
    const {'1': 'entity_id', '3': 1, '4': 1, '5': 3, '8': const {}, '9': 0, '10': 'entityId', '17': true},
    const {'1': 'limit', '3': 2, '4': 1, '5': 5, '8': const {}, '10': 'limit'},
    const {'1': 'offset', '3': 3, '4': 1, '5': 5, '8': const {}, '10': 'offset'},
    const {'1': 'search', '3': 4, '4': 1, '5': 9, '8': const {}, '9': 1, '10': 'search', '17': true},
    const {'1': 'type', '3': 5, '4': 1, '5': 9, '8': const {}, '9': 2, '10': 'type', '17': true},
    const {'1': 'all', '3': 6, '4': 1, '5': 8, '10': 'all'},
  ],
  '8': const [
    const {'1': '_entity_id'},
    const {'1': '_search'},
    const {'1': '_type'},
  ],
};

/// Descriptor for `ListConfigsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConfigsRequestDescriptor = $convert.base64Decode('ChJMaXN0Q29uZmlnc1JlcXVlc3QSKQoJZW50aXR5X2lkGAEgASgDQgf6QgQiAiAASABSCGVudGl0eUlkiAEBEh8KBWxpbWl0GAIgASgFQgn6QgYaBBhkKAFSBWxpbWl0Eh8KBm9mZnNldBgDIAEoBUIH+kIEGgIoAFIGb2Zmc2V0EiUKBnNlYXJjaBgEIAEoCUII+kIFcgMY/wFIAVIGc2VhcmNoiAEBEkYKBHR5cGUYBSABKAlCLfpCKnIoUgZzdHJpbmdSA2ludFIFZmxvYXRSBGJvb2xSBGpzb25SBmNob2ljZUgCUgR0eXBliAEBEhAKA2FsbBgGIAEoCFIDYWxsQgwKCl9lbnRpdHlfaWRCCQoHX3NlYXJjaEIHCgVfdHlwZQ==');
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
@$core.Deprecated('Use updateConfigRequestDescriptor instead')
const UpdateConfigRequest$json = const {
  '1': 'UpdateConfigRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'id'},
    const {'1': 'display_name', '3': 2, '4': 1, '5': 9, '8': const {}, '9': 1, '10': 'displayName', '17': true},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '9': 2, '10': 'description', '17': true},
    const {'1': 'string_value', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'stringValue'},
    const {'1': 'int_value', '3': 5, '4': 1, '5': 3, '9': 0, '10': 'intValue'},
    const {'1': 'float_value', '3': 6, '4': 1, '5': 1, '9': 0, '10': 'floatValue'},
    const {'1': 'bool_value', '3': 7, '4': 1, '5': 8, '9': 0, '10': 'boolValue'},
    const {'1': 'json_value', '3': 8, '4': 1, '5': 9, '9': 0, '10': 'jsonValue'},
    const {'1': 'metadata', '3': 9, '4': 1, '5': 9, '9': 3, '10': 'metadata', '17': true},
  ],
  '8': const [
    const {'1': 'value'},
    const {'1': '_display_name'},
    const {'1': '_description'},
    const {'1': '_metadata'},
  ],
};

/// Descriptor for `UpdateConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateConfigRequestDescriptor = $convert.base64Decode('ChNVcGRhdGVDb25maWdSZXF1ZXN0EhcKAmlkGAEgASgDQgf6QgQiAiAAUgJpZBIwCgxkaXNwbGF5X25hbWUYAiABKAlCCPpCBXIDGP8BSAFSC2Rpc3BsYXlOYW1liAEBEiUKC2Rlc2NyaXB0aW9uGAMgASgJSAJSC2Rlc2NyaXB0aW9uiAEBEiMKDHN0cmluZ192YWx1ZRgEIAEoCUgAUgtzdHJpbmdWYWx1ZRIdCglpbnRfdmFsdWUYBSABKANIAFIIaW50VmFsdWUSIQoLZmxvYXRfdmFsdWUYBiABKAFIAFIKZmxvYXRWYWx1ZRIfCgpib29sX3ZhbHVlGAcgASgISABSCWJvb2xWYWx1ZRIfCgpqc29uX3ZhbHVlGAggASgJSABSCWpzb25WYWx1ZRIfCghtZXRhZGF0YRgJIAEoCUgDUghtZXRhZGF0YYgBAUIHCgV2YWx1ZUIPCg1fZGlzcGxheV9uYW1lQg4KDF9kZXNjcmlwdGlvbkILCglfbWV0YWRhdGE=');
@$core.Deprecated('Use deleteConfigRequestDescriptor instead')
const DeleteConfigRequest$json = const {
  '1': 'DeleteConfigRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '8': const {}, '10': 'id'},
  ],
};

/// Descriptor for `DeleteConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteConfigRequestDescriptor = $convert.base64Decode('ChNEZWxldGVDb25maWdSZXF1ZXN0EhcKAmlkGAEgASgDQgf6QgQiAiAAUgJpZA==');
@$core.Deprecated('Use getConfigsByKeysRequestDescriptor instead')
const GetConfigsByKeysRequest$json = const {
  '1': 'GetConfigsByKeysRequest',
  '2': const [
    const {'1': 'entity_id', '3': 1, '4': 1, '5': 3, '8': const {}, '9': 0, '10': 'entityId'},
    const {'1': 'entity_name', '3': 2, '4': 1, '5': 9, '8': const {}, '9': 0, '10': 'entityName'},
    const {'1': 'keys', '3': 3, '4': 3, '5': 9, '8': const {}, '10': 'keys'},
  ],
  '8': const [
    const {'1': 'entity_identifier'},
  ],
};

/// Descriptor for `GetConfigsByKeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConfigsByKeysRequestDescriptor = $convert.base64Decode('ChdHZXRDb25maWdzQnlLZXlzUmVxdWVzdBImCgllbnRpdHlfaWQYASABKANCB/pCBCICIABIAFIIZW50aXR5SWQSLQoLZW50aXR5X25hbWUYAiABKAlCCvpCB3IFEAEY/wFIAFIKZW50aXR5TmFtZRInCgRrZXlzGAMgAygJQhP6QhCSAQ0IARBkIgdyBRABGP8BUgRrZXlzQhMKEWVudGl0eV9pZGVudGlmaWVy');
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
