import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import '../../../../core/errors/failures.dart';

abstract class ConfigsRepository {
  // Config Entity methods
  Future<Either<Failure, List<ConfigEntity>>> getConfigEntities(ListConfigEntitiesRequest request);
  Future<Either<Failure, ConfigEntity>> getConfigEntity(GetConfigEntityRequest request);
  Future<Either<Failure, ConfigEntity>> createConfigEntity(CreateConfigEntityRequest request);
  Future<Either<Failure, ConfigEntity>> updateConfigEntity(UpdateConfigEntityRequest request);
  Future<Either<Failure, void>> deleteConfigEntity(DeleteConfigEntityRequest request);

  // Config methods
  Future<Either<Failure, List<Config>>> getConfigs(ListConfigsRequest request);
  Future<Either<Failure, Config>> getConfig(GetConfigRequest request);
  Future<Either<Failure, Config>> createConfig(CreateConfigRequest request);
  Future<Either<Failure, Config>> updateConfig(UpdateConfigRequest request);
  Future<Either<Failure, void>> deleteConfig(DeleteConfigRequest request);
  Future<Either<Failure, Map<String, Config>>> getConfigsByKeys(GetConfigsByKeysRequest request);
}
