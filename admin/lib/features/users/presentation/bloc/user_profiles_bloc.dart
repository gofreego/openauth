import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../profile/data/profile_repository.dart';
import 'user_profiles_state.dart';

class UserProfilesBloc extends Bloc<GeneratedMessage, UserProfilesState> {
  final ProfileRepository repository;

  UserProfilesBloc({
    required this.repository,
  }) : super(UserProfilesInitial()) {
    on<pb.ListUserProfilesRequest>(_onLoadUserProfiles);
    on<pb.CreateProfileRequest>(_onCreateProfile);
    on<pb.UpdateProfileRequest>(_onUpdateProfile);
    on<pb.DeleteProfileRequest>(_onDeleteProfile);
  }

  Future<void> _onLoadUserProfiles(
      pb.ListUserProfilesRequest event, Emitter<UserProfilesState> emit) async {
    try {
      emit(UserProfilesLoading());

      final result = await repository.listUserProfiles(event);

      result.fold(
        (failure) => emit(UserProfilesError(failure.message)),
        (response) => emit(UserProfilesLoaded(
          profiles: response.profiles,
          totalCount: response.totalCount,
          limit: response.limit,
          offset: response.offset,
          hasMore: response.hasMore,
        )),
      );
    } catch (e) {
      emit(UserProfilesError('Failed to load user profiles: ${e.toString()}'));
    }
  }

  Future<void> _onCreateProfile(
      pb.CreateProfileRequest event, Emitter<UserProfilesState> emit) async {
    try {
      emit(UserProfileCreating());

      final result = await repository.createProfile(event);

      result.fold(
        (failure) => emit(UserProfilesError(failure.message)),
        (response) => emit(UserProfileCreated(response.message)),
      );
    } catch (e) {
      emit(UserProfilesError('Failed to create profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
      pb.UpdateProfileRequest event, Emitter<UserProfilesState> emit) async {
    try {
      emit(UserProfileUpdating());

      final result = await repository.updateProfile(event);

      result.fold(
        (failure) => emit(UserProfilesError(failure.message)),
        (response) => emit(UserProfileUpdated(response.message)),
      );
    } catch (e) {
      emit(UserProfilesError('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProfile(
      pb.DeleteProfileRequest event, Emitter<UserProfilesState> emit) async {
    try {
      emit(UserProfileDeleting());

      final result = await repository.deleteProfile(event);

      result.fold(
        (failure) => emit(UserProfilesError(failure.message)),
        (response) => emit(UserProfileDeleted(response.message)),
      );
    } catch (e) {
      emit(UserProfilesError('Failed to delete profile: ${e.toString()}'));
    }
  }
}
