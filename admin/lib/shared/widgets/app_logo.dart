import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A reusable widget for displaying the OpenAuth logo
class AppLogo extends StatelessWidget {
  /// The size of the logo (width and height)
  final double size;
  
  /// Optional color to apply to the logo
  final Color? color;
  
  /// Whether to show the logo with a circular background
  final bool withBackground;
  
  /// Background color when [withBackground] is true
  final Color? backgroundColor;

  const AppLogo({
    super.key,
    this.size = 40.0,
    this.color,
    this.withBackground = false,
    this.backgroundColor,
  });

  /// Small logo variant (24x24)
  const AppLogo.small({
    super.key,
    this.color,
    this.withBackground = false,
    this.backgroundColor,
  }) : size = 24.0;

  /// Medium logo variant (40x40)
  const AppLogo.medium({
    super.key,
    this.color,
    this.withBackground = false,
    this.backgroundColor,
  }) : size = 40.0;

  /// Large logo variant (64x64)
  const AppLogo.large({
    super.key,
    this.color,
    this.withBackground = false,
    this.backgroundColor,
  }) : size = 64.0;

  /// Extra large logo variant (128x128)
  const AppLogo.extraLarge({
    super.key,
    this.color,
    this.withBackground = false,
    this.backgroundColor,
  }) : size = 128.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget logoSvg = SvgPicture.asset(
      'assets/images/logo.svg',
      width: size,
      height: size,
      colorFilter: color != null 
        ? ColorFilter.mode(color!, BlendMode.srcIn)
        : null,
      semanticsLabel: 'OpenAuth Logo',
    );

    if (withBackground) {
      return Container(
        width: size + 16,
        height: size + 16,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Center(child: logoSvg),
      );
    }

    return logoSvg;
  }
}
