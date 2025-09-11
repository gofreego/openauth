import 'package:equatable/equatable.dart';
import 'package:openauth/core/errors/failures.dart';
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

  const ProfilesLoaded({
    required this.profiles,
  });

  @override
  List<Object?> get props => [profiles];
}

class ProfilesError extends ProfilesState {
  final String message;

  const ProfilesError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfilesListError extends ProfilesState {
  final Failure failure;

  const ProfilesListError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class ProfileCreateError extends ProfilesState {
  final String message;

  const ProfileCreateError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateError extends ProfilesState {
  final String message;

  const ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileDeleteError extends ProfilesState {
  final String message;

  const ProfileDeleteError(this.message);

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
