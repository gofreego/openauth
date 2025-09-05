import 'package:equatable/equatable.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

abstract class ProfilesState extends Equatable {
  const ProfilesState();

  @override
  List<Object?> get props => [];
}

class ProfilesInitial extends ProfilesState {}

class ProfilesLoading extends ProfilesState {}

class ProfilesLoaded extends ProfilesState {
  final List<pb.UserProfile> profiles;
  final int totalCount;
  final int limit;
  final int offset;
  final bool hasMore;

  const ProfilesLoaded({
    required this.profiles,
    required this.totalCount,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [profiles, totalCount, limit, offset, hasMore];
}

class ProfilesError extends ProfilesState {
  final String message;

  const ProfilesError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileCreating extends ProfilesState {}

class ProfileCreated extends ProfilesState {
  final String message;

  const ProfileCreated([this.message = 'Profile created successfully']);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdating extends ProfilesState {}

class ProfileUpdated extends ProfilesState {
  final String message;

  const ProfileUpdated([this.message = 'Profile updated successfully']);

  @override
  List<Object?> get props => [message];
}

class ProfileDeleting extends ProfilesState {}

class ProfileDeleted extends ProfilesState {
  final String message;

  const ProfileDeleted([this.message = 'Profile deleted successfully']);

  @override
  List<Object?> get props => [message];
}
