import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Breakpoints for different screen sizes
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  // Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  // Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  // Check if sidebar should be shown (tablet and desktop)
  static bool shouldShowSidebar(BuildContext context) {
    return !isMobile(context);
  }

  // Check if bottom navigation should be shown (mobile only)
  static bool shouldShowBottomNavigation(BuildContext context) {
    return isMobile(context);
  }

  // Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  // Get responsive content width
  static double getContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (isMobile(context)) {
      return screenWidth;
    } else if (isTablet(context)) {
      return screenWidth * 0.9;
    } else {
      return screenWidth * 0.8;
    }
  }
}

// Helper extension for easier access to responsive utilities
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  bool get shouldShowSidebar => ResponsiveUtils.shouldShowSidebar(this);
  bool get shouldShowBottomNavigation => ResponsiveUtils.shouldShowBottomNavigation(this);
  EdgeInsets get responsivePadding => ResponsiveUtils.getResponsivePadding(this);
  double get contentWidth => ResponsiveUtils.getContentWidth(this);
}
