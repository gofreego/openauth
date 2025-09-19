import 'package:flutter/material.dart';
import 'package:openauth/shared/utils/utility_functions.dart';

class CustomAvatar extends StatelessWidget {

  final String imageUrl;
  final String name;
  final double radius;

  const CustomAvatar({super.key, required this.imageUrl, required this.name, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      return  ClipOval(
            child: Image.network(imageUrl,
            height: radius * 2,
            width: radius * 2,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return InitialsAvatar(name: name, radius: radius);
              },
              errorBuilder: (_, __, ___) {
                // Fallback to initials if image fails to load
                return InitialsAvatar(name: name, radius: radius);
              },
            ),
          );
    }
    // Fallback to initials avatar
    return InitialsAvatar(name: name, radius: radius);
  }
}


class InitialsAvatar extends StatelessWidget {
  
  final String name;
  final double radius;
  
  const InitialsAvatar({super.key, required this.name, this.radius = 20});
  
  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primary,
      child: Text(
        UtilityFunctions.getInitials(name),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.7, // Scale font size based on radius
        ),
      ),
    );
  }
}