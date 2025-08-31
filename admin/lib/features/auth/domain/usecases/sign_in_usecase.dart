import '../repositories/auth_repository.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

/// Use case for user sign in
class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<pb.SignInResponse> call({
    required String identifier,
    required String password,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    bool rememberMe = false,
  }) async {
    // Validate input
    if (identifier.isEmpty) {
      throw ArgumentError('Username/email/phone cannot be empty');
    }
    
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    return await _authRepository.signIn(
      identifier: identifier,
      password: password,
      deviceId: deviceId,
      deviceName: deviceName,
      deviceType: deviceType,
      rememberMe: rememberMe,
    );
  }
}
