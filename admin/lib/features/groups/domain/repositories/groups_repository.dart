import 'package:dartz/dartz.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

abstract class GroupsRepository {
  Future<Either<Failure, List<Group>>> getGroups({
      required ListGroupsRequest request,
  });

  Future<Either<Failure, Group>> getGroup(Int64 groupId);

  Future<Either<Failure, Group>> createGroup({
    required CreateGroupRequest request,
  });

  Future<Either<Failure, Group>> updateGroup({
    required UpdateGroupRequest request,
  });

  Future<Either<Failure, void>> deleteGroup(Int64 groupId);

  Future<Either<Failure, List<GroupUser>>> getGroupUsers(Int64 groupId);

  Future<Either<Failure, void>> assignUserToGroup({
  required AssignUserToGroupRequest request,
  });

  Future<Either<Failure, void>> removeUserFromGroup({
    required RemoveUserFromGroupRequest request,
  });
}
