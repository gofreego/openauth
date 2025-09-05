import 'package:equatable/equatable.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

abstract class UserProfilesState extends Equatable {
  const UserProfilesState();

  @override
  List<Object?> get props => [];
}

class UserProfilesInitial extends UserProfilesState {}

class UserProfilesLoading extends UserProfilesState {}

class UserProfilesLoaded extends UserProfilesState {
  final List<pb.UserProfile> profiles;
  final int totalCount;
  final int limit;
  final int offset;
  final bool hasMore;

  const UserProfilesLoaded({
    required this.profiles,
    required this.totalCount,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [profiles, totalCount, limit, offset, hasMore];
}

class UserProfilesError extends UserProfilesState {
  final String message;

  const UserProfilesError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserProfileCreating extends UserProfilesState {}

class UserProfileCreated extends UserProfilesState {
  final String message;

  const UserProfileCreated([this.message = 'Profile created successfully']);

  @override
  List<Object?> get props => [message];
}

class UserProfileUpdating extends UserProfilesState {}

class UserProfileUpdated extends UserProfilesState {
  final String message;

  const UserProfileUpdated([this.message = 'Profile updated successfully']);

  @override
  List<Object?> get props => [message];
}

class UserProfileDeleting extends UserProfilesState {}

class UserProfileDeleted extends UserProfilesState {
  final String message;

  const UserProfileDeleted([this.message = 'Profile deleted successfully']);

  @override
  List<Object?> get props => [message];
}
