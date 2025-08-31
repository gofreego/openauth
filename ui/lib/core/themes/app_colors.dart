import 'package:flutter/material.dart';

/// Application color constants
class AppColors {
  // Primary color variants
  static const Color primary = Color(0xFFB794F6);
  static const Color primaryDark = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFFD6BCFA);
  static const Color primaryContainer = Color(0xFF9333EA); // Darker container for light theme
  
  // Dark theme specific colors - improved for readability
  static const Color darkBackground = Color(0xFF1A202C); // Lighter, warmer dark background
  static const Color darkSurface = Color(0xFF2D3748); // Lighter surface for better contrast
  static const Color darkSurfaceVariant = Color(0xFF4A5568); // Softer variant
  static const Color darkOnBackground = Color(0xFFF7FAFC); // Softer white for less strain
  static const Color darkOnSurface = Color(0xFFF7FAFC); // Softer white for surfaces
  static const Color darkOnPrimary = Color(0xFF1A202C);
  
  // Light theme specific colors
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceVariant = Color(0xFFF8FAFC);
  static const Color lightOnBackground = Color(0xFF1E293B);
  static const Color lightOnSurface = Color(0xFF1E293B);
  static const Color lightOnPrimary = Colors.white;
  
  // Semantic colors
  static const Color accent = Color(0xFF06B6D4);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF099940);
  static const Color warning = Color(0xFFF59E0B);
  
  // Text colors - improved for better readability
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFFA0AEC0); // Slightly lighter for better readability
  static const Color textLight = Color(0xFFE2E8F0); // More readable light text
  
  // Border and outline colors - softer for dark theme
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF718096); // Lighter, more subtle borders
  static const Color outline = Color(0xFF718096);
  
  // Shadow colors
  static const Color shadowLight = Colors.black;
  static const Color shadowDark = Colors.black;
  
  // Common transparent colors
  static Color get primaryTransparent => primary.withOpacity(0.5);
  static Color get primaryLightTransparent => primaryLight.withOpacity(0.5);
  static Color get primaryDarkTransparent => primaryDark.withOpacity(0.3);
  static Color get textMutedTransparent => textMuted.withOpacity(0.3);
  static Color get borderDarkTransparent => borderDark.withOpacity(0.3);
  static Color get borderLightTransparent => borderLight.withOpacity(0.5);
  static Color get shadowTransparent => Colors.black.withOpacity(0.3);
  static Color get shadowLightTransparent => Colors.black.withOpacity(0.05);
}
