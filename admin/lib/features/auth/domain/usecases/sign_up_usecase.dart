import '../entities/auth_session.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user sign up
class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<AuthUser> call({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    // Validate input
    if (username.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    
    if (email.isEmpty || !_isValidEmail(email)) {
      throw ArgumentError('Invalid email address');
    }
    
    if (password.length < 8) {
      throw ArgumentError('Password must be at least 8 characters long');
    }

    return await _authRepository.signUp(
      username: username,
      email: email,
      password: password,
      phone: phone,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
