import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'dart:math';

/// Utility class for device information and fingerprinting
class DeviceUtils {
  static const _characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static final _random = Random();

  /// Get device type based on platform
  static String getDeviceType() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isMacOS) {
      return 'macos';
    } else if (Platform.isWindows) {
      return 'windows';
    } else if (Platform.isLinux) {
      return 'linux';
    } else {
      return 'unknown';
    }
  }

  /// Generate a unique device ID for the current session
  static String generateDeviceId() {
    // Generate a 32-character unique identifier
    return List.generate(32, (index) => 
      _characters[_random.nextInt(_characters.length)]
    ).join();
  }

  /// Get device name with platform-specific details
  static String getDeviceName() {
    final deviceType = getDeviceType();
    
    switch (deviceType) {
      case 'web':
        return 'Web Browser';
      case 'android':
        return 'Android Device';
      case 'ios':
        return 'iOS Device';
      case 'macos':
        return 'macOS Device';
      case 'windows':
        return 'Windows Device';
      case 'linux':
        return 'Linux Device';
      default:
        return 'Unknown Device';
    }
  }

  /// Get platform-specific user agent string
  static String getUserAgent() {
    final deviceType = getDeviceType();
    final deviceName = getDeviceName();
    
    return 'OpenAuth-Admin/1.0.0 ($deviceName; $deviceType) Flutter/${kIsWeb ? 'Web' : 'Native'}';
  }

  /// Generate device fingerprint for security
  static Future<String> generateDeviceFingerprint() async {
    final deviceType = getDeviceType();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    // Create a fingerprint based on available device information
    final fingerprintData = [
      deviceType,
      kIsWeb ? 'web' : 'native',
      timestamp.toString(),
      generateDeviceId().substring(0, 8), // Random component
    ].join('|');
    
    // Simple hash-like transformation (in a real app, use proper hashing)
    return fingerprintData.hashCode.abs().toString();
  }

  /// Check if device supports biometric authentication
  static Future<bool> supportsBiometrics() async {
    // For web and desktop platforms, biometrics are not typically available
    if (kIsWeb || Platform.isLinux || Platform.isWindows) {
      return false;
    }
    
    // For mobile platforms, we'd typically use local_auth package
    // For now, return based on platform capability
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Get device security level
  static Future<String> getDeviceSecurityLevel() async {
    final supportsBio = await supportsBiometrics();
    final deviceType = getDeviceType();
    
    if (supportsBio && (deviceType == 'android' || deviceType == 'ios')) {
      return 'high'; // Mobile with biometric support
    } else if (deviceType == 'web') {
      return 'medium'; // Web browsers have moderate security
    } else {
      return 'standard'; // Desktop platforms
    }
  }

  /// Get current IP address (placeholder - in real app would use network APIs)
  static Future<String> getIPAddress() async {
    // In a real application, you would use packages like:
    // - connectivity_plus for network information
    // - http requests to IP detection services
    // For now, return a placeholder
    return '127.0.0.1';
  }

  /// Get device location (placeholder - in real app would use location services)
  static Future<String> getDeviceLocation() async {
    // In a real application, you would use packages like:
    // - geolocator for GPS location
    // - IP-based geolocation services
    // For now, return a placeholder
    return 'Unknown Location';
  }

  /// Create device session information
  static Future<Map<String, String>> createDeviceSession() async {
    final deviceId = generateDeviceId();
    final fingerprint = await generateDeviceFingerprint();
    final ipAddress = await getIPAddress();
    final location = await getDeviceLocation();
    
    return {
      'deviceId': deviceId,
      'deviceName': getDeviceName(),
      'deviceType': getDeviceType(),
      'userAgent': getUserAgent(),
      'fingerprint': fingerprint,
      'ipAddress': ipAddress,
      'location': location,
      'securityLevel': await getDeviceSecurityLevel(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
