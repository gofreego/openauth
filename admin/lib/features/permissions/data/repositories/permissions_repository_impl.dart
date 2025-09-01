import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/permission_entity.dart';
import '../../domain/repositories/permissions_repository.dart';
import '../datasources/permissions_remote_datasource_impl.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;

class PermissionsRepositoryImpl implements PermissionsRepository {
  final PermissionsRemoteDataSource remoteDataSource;

  PermissionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PermissionEntity>>> getPermissions({
    int? limit,
    int? offset,
    String? search,
  }) async {
    try {
      final response = await remoteDataSource.getPermissions(
        limit: limit,
        offset: offset,
        search: search,
      );

      final permissionEntities = response.permissions
          .map((permission) => PermissionEntity.fromProto(permission))
          .toList();
      
      return Right(permissionEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PermissionEntity>> getPermission(int permissionId) async {
    try {
      final permission = await remoteDataSource.getPermission(permissionId);
      final permissionEntity = PermissionEntity.fromProto(permission);
      return Right(permissionEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PermissionEntity>> createPermission(pb.CreatePermissionRequest request) async {
    try {
      final permission = await remoteDataSource.createPermission(request);
      final permissionEntity = PermissionEntity.fromProto(permission);
      return Right(permissionEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PermissionEntity>> updatePermission(pb.UpdatePermissionRequest request) async {
    try {
      final permission = await remoteDataSource.updatePermission(request);
      final permissionEntity = PermissionEntity.fromProto(permission);
      return Right(permissionEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePermission(int permissionId) async {
    try {
      await remoteDataSource.deletePermission(permissionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}
