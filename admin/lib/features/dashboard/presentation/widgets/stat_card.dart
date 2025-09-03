import 'package:flutter/material.dart';

/// A reusable stat card widget for displaying dashboard metrics
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate scaling factors based on available space
            final minDimension = constraints.smallest.shortestSide;
            final scaleFactor = (minDimension / 200).clamp(0.5, 2.0);
            
            // Dynamic sizes based on scale factor
            final iconSize = (24 * scaleFactor).clamp(20, 48).toDouble();
            final numberSize = (72 * scaleFactor).clamp(54, 150).toDouble();
            final titleSize = (20 * scaleFactor).clamp(18, 32).toDouble();
            final padding = (20 * scaleFactor).clamp(16, 32).toDouble();
            
            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: color,
                        size: iconSize,
                      ),
                    ],
                  ),
                  SizedBox(height: 16 * scaleFactor),
                  Flexible(
                    child: Center(
                      child: Text(
                        value,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: numberSize,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(height: 8 * scaleFactor),
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: titleSize,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
