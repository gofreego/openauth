import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import 'permissions_repository.dart';
import '../datasources/permissions_remote_datasource_impl.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart';

class PermissionsRepositoryImpl implements PermissionsRepository {
  final PermissionsRemoteDataSource remoteDataSource;

  PermissionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Permission>>> getPermissions(ListPermissionsRequest request) async {
    try {
      final response = await remoteDataSource.getPermissions(request);
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
  Future<Either<Failure, Permission>> getPermission(GetPermissionRequest request) async {
    try {
      return Right(await remoteDataSource.getPermission(request));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Permission>> createPermission(CreatePermissionRequest request) async {
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
  Future<Either<Failure, Permission>> updatePermission(UpdatePermissionRequest request) async {
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
  Future<Either<Failure, void>> deletePermission(DeletePermissionRequest request) async {
    try {
      await remoteDataSource.deletePermission(request);
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
