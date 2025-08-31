import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';

abstract class UsersRemoteDataSource {
  Future<pb.ListUsersResponse> getUsers({
    int page = 1,
    int limit = 50,
    String? search,
    bool? isActive,
  });

  Future<pb.GetUserResponse> getUser(String userIdOrUuid);

  Future<pb.SignUpResponse> createUser(pb.SignUpRequest request);

  Future<pb.UpdateUserResponse> updateUser(pb.UpdateUserRequest request);

  Future<pb.DeleteUserResponse> deleteUser(String userIdOrUuid);

  Future<pb.CreateProfileResponse> createProfile(pb.CreateProfileRequest request);

  Future<pb.UpdateProfileResponse> updateProfile(pb.UpdateProfileRequest request);

  Future<pb.DeleteProfileResponse> deleteProfile(String profileUuid);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final ApiService _apiService;

  UsersRemoteDataSourceImpl(this._apiService);

  @override
  Future<pb.ListUsersResponse> getUsers({
    int page = 1,
    int limit = 50,
    String? search,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (isActive != null) {
        queryParams['is_active'] = isActive;
      }

      // For now, return mock data until backend is ready
      await _apiService.get(
        '/openauth/v1/users',
        queryParameters: queryParams,
      );
      
      return _createMockListUsersResponse();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch users',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.GetUserResponse> getUser(String userIdOrUuid) async {
    try {
      // For now, return mock data until backend is ready
      await _apiService.get('/openauth/v1/users/$userIdOrUuid');
      
      return _createMockGetUserResponse(userIdOrUuid);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.SignUpResponse> createUser(pb.SignUpRequest request) async {
    try {
      // For now, return mock data until backend is ready
      await _apiService.post(
        '/openauth/v1/users',
        data: {
          'username': request.username,
          'email': request.email,
          'password': request.password,
          'phone': request.phone,
        },
      );

      return _createMockSignUpResponse(request);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to create user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.UpdateUserResponse> updateUser(pb.UpdateUserRequest request) async {
    try {
      final userUuid = request.uuid;
      
      // For now, return mock data until backend is ready
      await _apiService.put(
        '/openauth/v1/users/$userUuid',
        data: {
          'username': request.username,
          'email': request.email,
          'phone': request.phone,
          'is_active': request.isActive,
        },
      );

      return _createMockUpdateUserResponse(request);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to update user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.DeleteUserResponse> deleteUser(String userIdOrUuid) async {
    try {
      await _apiService.delete('/openauth/v1/users/$userIdOrUuid');

      return pb.DeleteUserResponse()
        ..success = true
        ..message = 'User deleted successfully';
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to delete user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.CreateProfileResponse> createProfile(pb.CreateProfileRequest request) async {
    try {
      // For now, return mock data until backend is ready
      await _apiService.post(
        '/openauth/v1/profiles',
        data: {
          'user_uuid': request.userUuid,
          'profile_name': request.profileName,
          'first_name': request.firstName,
          'last_name': request.lastName,
          'display_name': request.displayName,
          'bio': request.bio,
          'avatar_url': request.avatarUrl,
        },
      );

      return _createMockCreateProfileResponse(request);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to create profile',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.UpdateProfileResponse> updateProfile(pb.UpdateProfileRequest request) async {
    try {
      final profileUuid = request.profileUuid;
      
      // For now, return mock data until backend is ready
      await _apiService.put(
        '/openauth/v1/profiles/$profileUuid',
        data: {
          'profile_name': request.profileName,
          'first_name': request.firstName,
          'last_name': request.lastName,
          'display_name': request.displayName,
          'bio': request.bio,
          'avatar_url': request.avatarUrl,
        },
      );

      return _createMockUpdateProfileResponse(request);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to update profile',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  @override
  Future<pb.DeleteProfileResponse> deleteProfile(String profileUuid) async {
    try {
      await _apiService.delete('/openauth/v1/profiles/$profileUuid');

      return pb.DeleteProfileResponse()
        ..success = true
        ..message = 'Profile deleted successfully';
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to delete profile',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException(message: 'Network error: ${e.toString()}');
    }
  }

  // Mock data methods for development
  pb.ListUsersResponse _createMockListUsersResponse() {
    final mockUsers = [
      _createMockUser(
        id: 1,
        uuid: 'user-1-uuid',
        username: 'johndoe',
        email: 'john.doe@example.com',
        isActive: true,
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      _createMockUser(
        id: 2,
        uuid: 'user-2-uuid',
        username: 'janesmith',
        email: 'jane.smith@example.com',
        isActive: true,
        lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      _createMockUser(
        id: 3,
        uuid: 'user-3-uuid',
        username: 'bobjohnson',
        email: 'bob.johnson@example.com',
        isActive: false,
        lastLoginAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      _createMockUser(
        id: 4,
        uuid: 'user-4-uuid',
        username: 'alicewilson',
        email: 'alice.wilson@example.com',
        isActive: true,
        lastLoginAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      _createMockUser(
        id: 5,
        uuid: 'user-5-uuid',
        username: 'charliebrown',
        email: 'charlie.brown@example.com',
        isActive: true,
        lastLoginAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    return pb.ListUsersResponse()
      ..users.addAll(mockUsers)
      ..totalCount = mockUsers.length
      ..limit = 50
      ..offset = 0
      ..hasMore = false;
  }

  pb.GetUserResponse _createMockGetUserResponse(String userIdOrUuid) {
    final user = _createMockUser(
      id: 1,
      uuid: userIdOrUuid.contains('-') ? userIdOrUuid : 'user-$userIdOrUuid-uuid',
      username: 'johndoe',
      email: 'john.doe@example.com',
      isActive: true,
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    final profile = pb.UserProfile()
      ..id = Int64(1)
      ..uuid = 'profile-1-uuid'
      ..userId = user.id
      ..profileName = 'johndoe'
      ..firstName = 'John'
      ..lastName = 'Doe'
      ..displayName = 'John Doe'
      ..bio = 'Software Engineer'
      ..avatarUrl = 'https://via.placeholder.com/150'
      ..createdAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000)
      ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);

    return pb.GetUserResponse()
      ..user = user
      ..profile = profile;
  }

  pb.SignUpResponse _createMockSignUpResponse(pb.SignUpRequest request) {
    final user = pb.User()
      ..id = Int64(DateTime.now().millisecondsSinceEpoch)
      ..uuid = 'user-${DateTime.now().millisecondsSinceEpoch}-uuid'
      ..username = request.username
      ..email = request.email
      ..phone = request.phone
      ..emailVerified = false
      ..phoneVerified = false
      ..isActive = true
      ..isLocked = false
      ..failedLoginAttempts = 0
      ..createdAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000)
      ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);

    return pb.SignUpResponse()
      ..user = user
      ..message = 'User created successfully'
      ..emailVerificationRequired = true
      ..phoneVerificationRequired = false;
  }

  pb.UpdateUserResponse _createMockUpdateUserResponse(pb.UpdateUserRequest request) {
    final user = pb.User()
      ..id = Int64(1)
      ..uuid = request.uuid
      ..username = request.username
      ..email = request.email
      ..phone = request.phone
      ..emailVerified = true
      ..phoneVerified = true
      ..isActive = request.isActive
      ..isLocked = false
      ..failedLoginAttempts = 0
      ..createdAt = Int64(DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000)
      ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);

    return pb.UpdateUserResponse()..user = user;
  }

  pb.CreateProfileResponse _createMockCreateProfileResponse(pb.CreateProfileRequest request) {
    final profile = pb.UserProfile()
      ..id = Int64(DateTime.now().millisecondsSinceEpoch)
      ..uuid = 'profile-${DateTime.now().millisecondsSinceEpoch}-uuid'
      ..userId = Int64(1)
      ..profileName = request.profileName
      ..firstName = request.firstName
      ..lastName = request.lastName
      ..displayName = request.displayName
      ..bio = request.bio
      ..avatarUrl = request.avatarUrl
      ..createdAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000)
      ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);

    return pb.CreateProfileResponse()..profile = profile;
  }

  pb.UpdateProfileResponse _createMockUpdateProfileResponse(pb.UpdateProfileRequest request) {
    final profile = pb.UserProfile()
      ..id = Int64(1)
      ..uuid = request.profileUuid
      ..userId = Int64(1)
      ..profileName = request.profileName
      ..firstName = request.firstName
      ..lastName = request.lastName
      ..displayName = request.displayName
      ..bio = request.bio
      ..avatarUrl = request.avatarUrl
      ..createdAt = Int64(DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000)
      ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);

    return pb.UpdateProfileResponse()..profile = profile;
  }

  pb.User _createMockUser({
    required int id,
    required String uuid,
    required String username,
    required String email,
    required bool isActive,
    required DateTime lastLoginAt,
  }) {
    return pb.User()
      ..id = Int64(id)
      ..uuid = uuid
      ..username = username
      ..email = email
      ..phone = '+1234567890'
      ..emailVerified = true
      ..phoneVerified = true
      ..isActive = isActive
      ..isLocked = false
      ..failedLoginAttempts = 0
      ..lastLoginAt = Int64(lastLoginAt.millisecondsSinceEpoch ~/ 1000)
      ..createdAt = Int64(DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000)
      ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }
}