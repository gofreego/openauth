import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

abstract class GroupsRepository {
  Future<Either<Failure, List<Group>>> getGroups({
    String? search,
    int? pageSize,
    String? pageToken,
  });

  Future<Either<Failure, Group>> getGroup(Int64 groupId);

  Future<Either<Failure, Group>> createGroup({
    required String name,
    required String displayName,
    String? description,
  });

  Future<Either<Failure, Group>> updateGroup({
    required Int64 groupId,
    required String name,
    required String displayName,
    String? description,
  });

  Future<Either<Failure, void>> deleteGroup(Int64 groupId);

  Future<Either<Failure, List<GroupUser>>> getGroupUsers(Int64 groupId);

  Future<Either<Failure, void>> assignUserToGroup({
    required Int64 groupId,
    required Int64 userId,
  });

  Future<Either<Failure, void>> removeUserFromGroup({
    required Int64 groupId,
    required Int64 userId,
  });
}
