import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/permissions_repository.dart';
import '../datasources/permissions_remote_datasource_impl.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;

class PermissionsRepositoryImpl implements PermissionsRepository {
  final PermissionsRemoteDataSource remoteDataSource;

  PermissionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<pb.Permission>>> getPermissions({
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
      return Right(response.permissions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.Permission>> getPermission(Int64 permissionId) async {
    try {
      return Right(await remoteDataSource.getPermission(permissionId));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.Permission>> createPermission(pb.CreatePermissionRequest request) async {
    try {
      final permission = await remoteDataSource.createPermission(request);
      return Right(permission);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, pb.Permission>> updatePermission(pb.UpdatePermissionRequest request) async {
    try {
      final permission = await remoteDataSource.updatePermission(request);
      return Right(permission);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePermission(Int64 permissionId) async {
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
