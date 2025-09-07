import 'package:dartz/dartz.dart';
import 'package:openauth/src/generated/openauth/v1/permission_assignments.pb.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';
import '../../../../core/errors/failures.dart';
import 'permissions_repository.dart';
import '../datasources/permissions_remote_datasource_impl.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart';

class PermissionsRepositoryImpl implements PermissionsRepository {
  final PermissionsRemoteDataSource remoteDataSource;

  PermissionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Permission>>> getPermissions(
      ListPermissionsRequest request) async {
    try {
      final response = await remoteDataSource.getPermissions(request);
      return Right(response.permissions);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Permission>> getPermission(
      GetPermissionRequest request) async {
    try {
      return Right(await remoteDataSource.getPermission(request));
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Permission>> createPermission(
      CreatePermissionRequest request) async {
    try {
      final permission = await remoteDataSource.createPermission(request);
      return Right(permission);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Permission>> updatePermission(
      UpdatePermissionRequest request) async {
    try {
      final permission = await remoteDataSource.updatePermission(request);
      return Right(permission);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePermission(
      DeletePermissionRequest request) async {
    try {
      await remoteDataSource.deletePermission(request);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, ListUserPermissionsResponse>> getUserPermissions(
      ListUserPermissionsRequest request) async {
    try {
      final response = await remoteDataSource.getUserPermissions(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, AssignPermissionsToUserResponse>>
      assignPermissionsToUser(AssignPermissionsToUserRequest request) async {
    try {
      final response = await remoteDataSource.assignPermissionsToUser(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, RemovePermissionsFromUserResponse>>
      removePermissionsFromUser(
          RemovePermissionsFromUserRequest request) async {
    try {
      final response =
          await remoteDataSource.removePermissionsFromUser(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, ListGroupPermissionsResponse>> getGroupPermissions(
      ListGroupPermissionsRequest request) async {
    try {
      final response = await remoteDataSource.getGroupPermissions(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, AssignPermissionsToGroupResponse>>
      assignPermissionsToGroup(AssignPermissionsToGroupRequest request) async {
    try {
      final response = await remoteDataSource.assignPermissionsToGroup(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, RemovePermissionsFromGroupResponse>>
      removePermissionsFromGroup(
          RemovePermissionsFromGroupRequest request) async {
    try {
      final response =
          await remoteDataSource.removePermissionsFromGroup(request);
      return Right(response);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
