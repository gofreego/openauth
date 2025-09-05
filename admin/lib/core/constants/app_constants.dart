import 'package:flutter/material.dart';

/// Class for storing app colors
class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF7C3AED);
  static const Color primaryDark = Color(0xFF5B21B6);
  static const Color primaryLight = Color(0xFFA855F7);
  
  // Secondary Colors
  static const Color secondaryColor = Color(0xFFF8FAFC);
  static const Color accentColor = Color(0xFF06B6D4);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  
  // Utility Colors
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF099940);  
  static const Color backgroundColor = Color(0xFFFFFFFF);
  
  // Dark mode background colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryLight],
  );
  
  // Shadows
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  );
  
  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 6,
    offset: Offset(0, 4),
    spreadRadius: -1,
  );
  
  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 15,
    offset: Offset(0, 10),
    spreadRadius: -3,
  );
  
  static const BoxShadow shadowXl = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 25,
    offset: Offset(0, 20),
    spreadRadius: -5,
  );
}

/// App Image Assets
class AppImages {
  static const String logo = 'assets/images/logo.png';
}

/// App Timing Constants
class AppTimingConstants {
  // Splash Screen
  static const Duration splashScreenMinDuration = Duration(milliseconds: 3000);
}

/// Pagination Constants
class PaginationConstants {
  // Default page sizes
  static const int defaultPageLimit = 20;
  static const int smallPageLimit = 10;
  static const int largePageLimit = 50;
}
