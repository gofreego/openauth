import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

abstract class ProfileRepository {
  Future<Either<Failure, pb.ListUserProfilesResponse>> listUserProfiles(pb.ListUserProfilesRequest request);
  Future<Either<Failure, pb.CreateProfileResponse>> createProfile(pb.CreateProfileRequest request);
  Future<Either<Failure, pb.UpdateProfileResponse>> updateProfile(pb.UpdateProfileRequest request);
  Future<Either<Failure, pb.DeleteProfileResponse>> deleteProfile(pb.DeleteProfileRequest request);
}
