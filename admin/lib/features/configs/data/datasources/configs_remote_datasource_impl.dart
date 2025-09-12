import 'package:openauth/core/network/api_service.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart' as pb;

abstract class ConfigsRemoteDataSource {
  // Config Entity methods
  Future<pb.ListConfigEntitiesResponse> getConfigEntities(pb.ListConfigEntitiesRequest request);
  Future<pb.ConfigEntity> getConfigEntity(pb.GetConfigEntityRequest request);
  Future<pb.ConfigEntity> createConfigEntity(pb.CreateConfigEntityRequest request);
  Future<pb.UpdateResponse> updateConfigEntity(pb.UpdateConfigEntityRequest request);
  Future<pb.DeleteResponse> deleteConfigEntity(pb.DeleteConfigEntityRequest request);

  // Config methods
  Future<pb.ListConfigsResponse> getConfigs(pb.ListConfigsRequest request);
  Future<pb.Config> getConfig(pb.GetConfigRequest request);
  Future<pb.Config> createConfig(pb.CreateConfigRequest request);
  Future<pb.UpdateResponse> updateConfig(pb.UpdateConfigRequest request);
  Future<pb.DeleteResponse> deleteConfig(pb.DeleteConfigRequest request);
  Future<pb.GetConfigsByKeysResponse> getConfigsByKeys(pb.GetConfigsByKeysRequest request);
}

class ConfigsRemoteDataSourceImpl implements ConfigsRemoteDataSource {
  final ApiService apiService;

  ConfigsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<pb.ListConfigEntitiesResponse> getConfigEntities(pb.ListConfigEntitiesRequest request) async {
    final response = await apiService.get(
      '/openauth/v1/config-entities?search=${request.search}&limit=${request.limit}&offset=${request.offset}&all=${request.all}',
    );
    
    var res = pb.ListConfigEntitiesResponse();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.ConfigEntity> getConfigEntity(pb.GetConfigEntityRequest request) async {
    final response = await apiService.get(
      '/openauth/v1/config-entities/${request.id}',
    );
    var res = pb.ConfigEntity();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.ConfigEntity> createConfigEntity(pb.CreateConfigEntityRequest request) async {
    final response = await apiService.post(
      '/openauth/v1/config-entities',
      data: request.toProto3Json(),
    );
    var res = pb.ConfigEntity();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.UpdateResponse> updateConfigEntity(pb.UpdateConfigEntityRequest request) async {
    final response = await apiService.put(
      '/openauth/v1/config-entities/${request.id}',
      data: request.toProto3Json(),
    );
    var res = pb.UpdateResponse();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.DeleteResponse> deleteConfigEntity(pb.DeleteConfigEntityRequest request) async {
    final response = await apiService.delete(
      '/openauth/v1/config-entities/${request.id}',
    );
    var res = pb.DeleteResponse();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.ListConfigsResponse> getConfigs(pb.ListConfigsRequest request) async {
    final response = await apiService.get(
      '/openauth/v1/configs?entity_id=${request.entityId}&search=${request.search}&limit=${request.limit}&offset=${request.offset}&all=${request.all}',
    );
    var res = pb.ListConfigsResponse();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.Config> getConfig(pb.GetConfigRequest request) async {
    final response = await apiService.get(
      '/openauth/v1/configs/${request.id}',
    );
    var res = pb.Config();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.Config> createConfig(pb.CreateConfigRequest request) async {
    final response = await apiService.post(
      '/openauth/v1/configs',
      data: request.toProto3Json(),
    );
    var res = pb.Config();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.UpdateResponse> updateConfig(pb.UpdateConfigRequest request) async {
    final response = await apiService.put(
      '/openauth/v1/configs/${request.id}',
      data: request.toProto3Json(),
    );
    var res = pb.UpdateResponse();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.DeleteResponse> deleteConfig(pb.DeleteConfigRequest request) async {
    final response = await apiService.delete(
      '/openauth/v1/configs/${request.id}',
    );
    var res = pb.DeleteResponse();
    res.mergeFromProto3Json(response.data);
    return res;
  }

  @override
  Future<pb.GetConfigsByKeysResponse> getConfigsByKeys(pb.GetConfigsByKeysRequest request) async {
    final response = await apiService.post(
      '/openauth/v1/entities/${request.entityId}/configs/batch',
      data: request.toProto3Json(),
    );
    var res = pb.GetConfigsByKeysResponse();
    res.mergeFromProto3Json(response.data);
    return res;
  }
}
