import '../repositories/auth_repository.dart';
import '../../../../shared/utils/login_validators.dart';
import '../../../../shared/utils/device_utils.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

/// Use case for user sign in
class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<pb.SignInResponse> call({
    required String username,
    required String password,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    bool rememberMe = false,
  }) async {
    // Validate input using enhanced validators
    final usernameValidation = LoginValidators.validateIdentifier(username);
    if (!usernameValidation.isValid) {
      throw ArgumentError(usernameValidation.message);
    }
    
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    // Get device information if not provided
    if (deviceId == null || deviceName == null || deviceType == null) {
      final deviceSession = await DeviceUtils.createDeviceSession();
      deviceId ??= deviceSession['deviceId'];
      deviceName ??= deviceSession['deviceName']; 
      deviceType ??= deviceSession['deviceType'];
    }

    return await _authRepository.signIn(
      username: username.trim(),
      password: password,
      deviceId: deviceId,
      deviceName: deviceName,
      deviceType: deviceType,
      rememberMe: rememberMe,
    );
  }
}
