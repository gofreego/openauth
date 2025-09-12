import 'package:dartz/dartz.dart';
import '../../../../src/generated/openauth/v1/configs.pb.dart' as pb;
import '../../../../core/errors/failures.dart';
import 'configs_repository.dart';
import '../datasources/configs_remote_datasource_impl.dart';

class ConfigsRepositoryImpl implements ConfigsRepository {
  final ConfigsRemoteDataSource remoteDataSource;

  ConfigsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<pb.ConfigEntity>>> getConfigEntities(pb.ListConfigEntitiesRequest request) async {
    try {
      final response = await remoteDataSource.getConfigEntities(request);
      return Right(response.entities);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.ConfigEntity>> getConfigEntity(pb.GetConfigEntityRequest request) async {
    try {
      final response = await remoteDataSource.getConfigEntity(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.ConfigEntity>> createConfigEntity(pb.CreateConfigEntityRequest request) async {
    try {
      final response = await remoteDataSource.createConfigEntity(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.UpdateResponse>> updateConfigEntity(pb.UpdateConfigEntityRequest request) async {
    try {
      final response = await remoteDataSource.updateConfigEntity(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConfigEntity(pb.DeleteConfigEntityRequest request) async {
    try {
      await remoteDataSource.deleteConfigEntity(request);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<pb.Config>>> getConfigs(pb.ListConfigsRequest request) async {
    try {
      final response = await remoteDataSource.getConfigs(request);
      return Right(response.configs);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.Config>> getConfig(pb.GetConfigRequest request) async {
    try {
      final response = await remoteDataSource.getConfig(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.Config>> createConfig(pb.CreateConfigRequest request) async {
    try {
      final response = await remoteDataSource.createConfig(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, pb.UpdateResponse>> updateConfig(pb.UpdateConfigRequest request) async {
    try {
      final response = await remoteDataSource.updateConfig(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConfig(pb.DeleteConfigRequest request) async {
    try {
      await remoteDataSource.deleteConfig(request);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, pb.Config>>> getConfigsByKeys(pb.GetConfigsByKeysRequest request) async {
    try {
      final response = await remoteDataSource.getConfigsByKeys(request);
      return Right(response.configs);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
