import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protobuf/protobuf.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../data/profile_repository.dart';
import 'profiles_state.dart';

class ProfilesBloc extends Bloc<GeneratedMessage, ProfilesState> {
  final ProfileRepository repository;

  ProfilesBloc({
    required this.repository,
  }) : super(ProfilesInitial()) {
    on<pb.ListUserProfilesRequest>(_onLoadUserProfiles);
    on<pb.CreateProfileRequest>(_onCreateProfile);
    on<pb.UpdateProfileRequest>(_onUpdateProfile);
    on<pb.DeleteProfileRequest>(_onDeleteProfile);
  }

  Future<void> _onLoadUserProfiles(
      pb.ListUserProfilesRequest event, Emitter<ProfilesState> emit) async {
    try {
      emit(ProfilesLoading());

      final result = await repository.listUserProfiles(event);

      result.fold(
        (failure) => emit(ProfilesError(failure.message)),
        (response) => emit(ProfilesLoaded(
          profiles: response.profiles,
          totalCount: response.totalCount,
          limit: response.limit,
          offset: response.offset,
          hasMore: response.hasMore,
        )),
      );
    } catch (e) {
      emit(ProfilesError('Failed to load user profiles: ${e.toString()}'));
    }
  }

  Future<void> _onCreateProfile(
      pb.CreateProfileRequest event, Emitter<ProfilesState> emit) async {
    try {
      emit(ProfileCreating());

      final result = await repository.createProfile(event);

      result.fold(
        (failure) => emit(ProfilesError(failure.message)),
        (response) => emit(ProfileCreated(response.message)),
      );
    } catch (e) {
      emit(ProfilesError('Failed to create profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
      pb.UpdateProfileRequest event, Emitter<ProfilesState> emit) async {
    try {
      emit(ProfileUpdating());

      final result = await repository.updateProfile(event);

      result.fold(
        (failure) => emit(ProfilesError(failure.message)),
        (response) => emit(ProfileUpdated(response.message)),
      );
    } catch (e) {
      emit(ProfilesError('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProfile(
      pb.DeleteProfileRequest event, Emitter<ProfilesState> emit) async {
    try {
      emit(ProfileDeleting());

      final result = await repository.deleteProfile(event);

      result.fold(
        (failure) => emit(ProfilesError(failure.message)),
        (response) => emit(ProfileDeleted(response.message)),
      );
    } catch (e) {
      emit(ProfilesError('Failed to delete profile: ${e.toString()}'));
    }
  }
}
