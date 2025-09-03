import 'package:flutter/material.dart';
import 'app_colors.dart';

// Light theme for the application
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryDark, // Use darker primary for better contrast in light mode
    onPrimary: AppColors.lightOnPrimary,
    primaryContainer: AppColors.primaryContainer, // Darker container for better contrast
    onPrimaryContainer: AppColors.lightOnPrimary,
    secondary: AppColors.lightSurfaceVariant, // Light surface variant
    onSecondary: AppColors.lightOnBackground, // Dark text on light secondary
    secondaryContainer: AppColors.accent, // Accent color
    onSecondaryContainer: AppColors.lightOnPrimary,
    tertiary: AppColors.accent, // Accent color
    onTertiary: AppColors.lightOnPrimary,
    error: AppColors.error, // Error color
    onError: AppColors.lightOnPrimary,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface, // Dark text on light surface
    surfaceContainerHighest: AppColors.lightSurfaceVariant, // Light surface variant
    onSurfaceVariant: AppColors.textSecondary, // Secondary text color
    outline: AppColors.borderLight, // Light border color
    shadow: AppColors.shadowLight,
    inverseSurface: AppColors.lightOnBackground,
    onInverseSurface: AppColors.lightBackground,
    inversePrimary: AppColors.primary, // Light primary for inverse
    surfaceTint: AppColors.primaryDark, // Dark primary for surface tint
  ),
  
  // Text Theme
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.lightOnBackground),
    displayMedium: TextStyle(color: AppColors.lightOnBackground),
    displaySmall: TextStyle(color: AppColors.lightOnBackground),
    headlineLarge: TextStyle(color: AppColors.lightOnBackground),
    headlineMedium: TextStyle(color: AppColors.lightOnBackground),
    headlineSmall: TextStyle(color: AppColors.lightOnBackground),
    titleLarge: TextStyle(color: AppColors.lightOnBackground),
    titleMedium: TextStyle(color: AppColors.lightOnBackground),
    titleSmall: TextStyle(color: AppColors.lightOnBackground),
    bodyLarge: TextStyle(color: AppColors.lightOnBackground),
    bodyMedium: TextStyle(color: AppColors.lightOnBackground),
    bodySmall: TextStyle(color: AppColors.textSecondary),
    labelLarge: TextStyle(color: AppColors.lightOnBackground),
    labelMedium: TextStyle(color: AppColors.textSecondary),
    labelSmall: TextStyle(color: AppColors.textMuted),
  ),
  
  // Card Theme
  cardTheme: CardThemeData(
    color: AppColors.lightSurface,
    elevation: 1,
    shadowColor: AppColors.shadowLightTransparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: AppColors.borderLightTransparent,
        width: 1,
      ),
    ),
    margin: const EdgeInsets.all(8),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.lightOnPrimary,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      shadowColor: AppColors.primaryDarkTransparent,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryDark,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: const BorderSide(color: AppColors.primaryDark, width: 1.5),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryDark,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightSurfaceVariant,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.error, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: const TextStyle(color: AppColors.textMuted),
    errorStyle: const TextStyle(color: AppColors.error),
  ),

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.lightOnBackground,
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: AppColors.lightOnBackground,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: AppColors.lightOnBackground,
      size: 24,
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.primaryDark,
      size: 24,
    ),
  ),
  
  // Drawer Theme
  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColors.lightBackground,
    elevation: 1,
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryDark,
    foregroundColor: AppColors.lightOnPrimary,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // Tab Bar Theme
  tabBarTheme: const TabBarThemeData(
    labelColor: AppColors.primaryDark,
    unselectedLabelColor: AppColors.textSecondary,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppColors.primaryDark,
          width: 2.0,
        ),
      ),
    ),
  ),

  // Dialog Theme
  dialogTheme: const DialogThemeData(
    backgroundColor: AppColors.lightSurface,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightBackground,
    selectedItemColor: AppColors.primaryDark,
    unselectedItemColor: AppColors.textSecondary,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
    unselectedLabelStyle: TextStyle(fontSize: 12),
  ),
  
  // Divider Theme
  dividerTheme: const DividerThemeData(
    color: AppColors.borderLight,
    thickness: 1,
    space: 1,
  ),
  
    // Checkbox Theme
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryDark;
      }
      return null;
    }),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  ),
  
  // Switch Theme
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryDark;
      }
      return AppColors.lightOnPrimary;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryTransparent;
      }
      return AppColors.textMutedTransparent;
    }),
  ),
);
