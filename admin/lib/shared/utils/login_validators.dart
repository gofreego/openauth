/// Utilities for validating different login identifier types
class LoginValidators {
  
  /// Regular expression for email validation
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
  );

  /// Regular expression for phone number validation (international format)
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$' // E.164 format
  );

  /// Regular expression for username validation
  static final RegExp _usernameRegex = RegExp(
    r'^[a-zA-Z0-9_.-]{3,30}$'
  );

  /// Check if input is a valid email address
  static bool isValidEmail(String input) {
    if (input.isEmpty) return false;
    return _emailRegex.hasMatch(input.trim());
  }

  /// Check if input is a valid phone number
  static bool isValidPhone(String input) {
    if (input.isEmpty) return false;
    
    // Remove common phone number separators and spaces
    final cleanedInput = input
        .replaceAll(RegExp(r'[\s\-\(\)\.]'), '')
        .trim();
    
    return _phoneRegex.hasMatch(cleanedInput);
  }

  /// Check if input is a valid username
  static bool isValidUsername(String input) {
    if (input.isEmpty) return false;
    return _usernameRegex.hasMatch(input.trim());
  }

  /// Determine the type of identifier (email, phone, or username)
  static IdentifierType getIdentifierType(String input) {
    if (input.isEmpty) return IdentifierType.unknown;
    
    final trimmedInput = input.trim();
    
    if (isValidEmail(trimmedInput)) {
      return IdentifierType.email;
    } else if (isValidPhone(trimmedInput)) {
      return IdentifierType.phone;
    } else if (isValidUsername(trimmedInput)) {
      return IdentifierType.username;
    } else {
      return IdentifierType.unknown;
    }
  }

  /// Validate identifier and return validation result
  static ValidationResult validateIdentifier(String input) {
    if (input.isEmpty) {
      return const ValidationResult(
        isValid: false,
        type: IdentifierType.unknown,
        message: 'Please enter your username, email, or phone number',
      );
    }

    final type = getIdentifierType(input);
    
    switch (type) {
      case IdentifierType.email:
        return ValidationResult(
          isValid: true,
          type: type,
          message: 'Valid email address',
        );
      case IdentifierType.phone:
        return ValidationResult(
          isValid: true,
          type: type,
          message: 'Valid phone number',
        );
      case IdentifierType.username:
        return ValidationResult(
          isValid: true,
          type: type,
          message: 'Valid username',
        );
      case IdentifierType.unknown:
        return ValidationResult(
          isValid: false,
          type: type,
          message: 'Please enter a valid username, email, or phone number',
        );
    }
  }

  /// Validate password strength
  static PasswordValidationResult validatePassword(String password) {
    if (password.isEmpty) {
      return const PasswordValidationResult(
        isValid: false,
        strength: PasswordStrength.weak,
        message: 'Password is required',
      );
    }

    if (password.length < 6) {
      return const PasswordValidationResult(
        isValid: false,
        strength: PasswordStrength.weak,
        message: 'Password must be at least 6 characters long',
      );
    }

    // Calculate password strength
    int score = 0;
    
    // Length bonus
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Character variety
    if (password.contains(RegExp(r'[a-z]'))) score++; // lowercase
    if (password.contains(RegExp(r'[A-Z]'))) score++; // uppercase
    if (password.contains(RegExp(r'[0-9]'))) score++; // numbers
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++; // special chars
    
    PasswordStrength strength;
    String message;
    
    if (score <= 2) {
      strength = PasswordStrength.weak;
      message = 'Weak password';
    } else if (score <= 4) {
      strength = PasswordStrength.medium;
      message = 'Medium strength password';
    } else {
      strength = PasswordStrength.strong;
      message = 'Strong password';
    }

    return PasswordValidationResult(
      isValid: true,
      strength: strength,
      message: message,
    );
  }

  /// Format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    if (!isValidPhone(phoneNumber)) return phoneNumber;
    
    // Basic formatting for common patterns
    final cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
    
    // If it starts with +, keep the format mostly intact
    if (cleaned.startsWith('+')) {
      return cleaned;
    }
    
    // For US numbers (10 digits), format as (XXX) XXX-XXXX
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    
    return phoneNumber; // Return original if can't format
  }

  /// Get placeholder text based on identifier type
  static String getPlaceholderText() {
    return 'Username, email, or phone number';
  }

  /// Get hint text for identifier input
  static String getHintText() {
    return 'Enter your username, email, or phone number';
  }
}

/// Enum for different types of login identifiers
enum IdentifierType {
  username,
  email,
  phone,
  unknown,
}

/// Enum for password strength levels
enum PasswordStrength {
  weak,
  medium,
  strong,
}

/// Result of identifier validation
class ValidationResult {
  final bool isValid;
  final IdentifierType type;
  final String message;

  const ValidationResult({
    required this.isValid,
    required this.type,
    required this.message,
  });
}

/// Result of password validation
class PasswordValidationResult {
  final bool isValid;
  final PasswordStrength strength;
  final String message;

  const PasswordValidationResult({
    required this.isValid,
    required this.strength,
    required this.message,
  });
}
