import 'package:flutter/material.dart';
import 'app_colors.dart';

// Dark theme for the application
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary, // Lighter purple for better readability in dark mode
    onPrimary: AppColors.darkOnPrimary, // Dark text on light primary
    primaryContainer: AppColors.primaryDark, // Original purple for containers
    onPrimaryContainer: AppColors.darkOnBackground,
    secondary: AppColors.darkSurface, // Dark variant of secondary color
    onSecondary: AppColors.darkOnBackground,
    secondaryContainer: AppColors.accent, // --accent-color
    onSecondaryContainer: AppColors.darkOnBackground,
    tertiary: AppColors.accent, // --accent-color
    onTertiary: AppColors.darkOnBackground,
    error: AppColors.error, // --error-color
    onError: AppColors.darkOnBackground,
    surface: AppColors.darkSurface, // Dark surface
    onSurface: AppColors.darkOnSurface,
    surfaceContainerHighest: AppColors.darkSurfaceVariant, // Darker variant of surface
    onSurfaceVariant: AppColors.textLight,
    outline: AppColors.borderDark, // Darker border color
    shadow: AppColors.shadowDark,
    inverseSurface: AppColors.lightBackground,
    onInverseSurface: AppColors.darkBackground,
    inversePrimary: AppColors.primaryLight, // More readable light purple
    surfaceTint: AppColors.primary, // More readable purple
  ),
  
  // Text Theme - improved for readability
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 64,
      fontWeight: FontWeight.w300,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 48,
      fontWeight: FontWeight.w400,
      height: 1.3,
    ),
    displaySmall: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 40,
      fontWeight: FontWeight.w500,
      height: 1.3,
    ),
    headlineLarge: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 36,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    headlineMedium: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    headlineSmall: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 26,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleLarge: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.5,
    ),
    titleMedium: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    titleSmall: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
    ),
    bodyLarge: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.6,
    ),
    bodyMedium: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
    ),
    bodySmall: TextStyle(
      color: AppColors.textLight,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      color: AppColors.textLight,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      color: AppColors.textMuted,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
  ),
  
  // Card Theme - improved for readability
  cardTheme: CardTheme(
    color: AppColors.darkSurface,
    elevation: 1,
    shadowColor: AppColors.shadowTransparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: AppColors.borderDarkTransparent,
        width: 0.5,
      ),
    ),
    margin: const EdgeInsets.all(12),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary, // Better readable primary color
      foregroundColor: AppColors.darkOnPrimary, // Dark text for better contrast
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      shadowColor: AppColors.primaryTransparent,
      textStyle: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryLight, // Even lighter primary for better visibility
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
      textStyle: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    ),
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryLight, // Lighter primary for better readability
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurfaceVariant, // Dark input background
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 2), // More readable primary
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.error, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    hintStyle: const TextStyle(color: AppColors.textMuted),
    errorStyle: const TextStyle(color: AppColors.error),
  ),

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.darkOnBackground,
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: AppColors.darkOnBackground,
      fontSize: 26,
      fontWeight: FontWeight.bold,
      height: 1.3,
    ),
    iconTheme: IconThemeData(
      color: AppColors.darkOnBackground,
      size: 24,
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.primaryLight, // More readable primary for app bar actions
      size: 24,
    ),
  ),
  
  // Drawer Theme
  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColors.darkBackground,
    elevation: 1,
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary, // More readable primary
    foregroundColor: AppColors.darkOnPrimary, // Dark text for better contrast
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // Tab Bar Theme
  tabBarTheme: const TabBarTheme(
    labelColor: AppColors.primaryLight, // More readable primary
    unselectedLabelColor: AppColors.textLight,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppColors.primaryLight, // More readable primary
          width: 2.0,
        ),
      ),
    ),
  ),

  // Dialog Theme
  dialogTheme: const DialogTheme(
    backgroundColor: AppColors.darkSurface,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkBackground,
    selectedItemColor: AppColors.primaryLight, // More readable primary
    unselectedItemColor: AppColors.textLight,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, height: 1.3),
    unselectedLabelStyle: TextStyle(fontSize: 13, height: 1.3),
  ),
  
  // Divider Theme
  dividerTheme: const DividerThemeData(
    color: AppColors.borderDark,
    thickness: 1,
    space: 1,
  ),
  
  // Checkbox Theme
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary; // More readable primary
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
        return AppColors.primary; // More readable primary
      }
      return AppColors.darkOnBackground;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryLightTransparent; // Lighter track color
      }
      return AppColors.textMutedTransparent;
    }),
  ),
);
