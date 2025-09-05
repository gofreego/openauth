import 'package:flutter/material.dart';

/// An animated stat card widget that animates number changes
class AnimatedStatCard extends StatefulWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final Duration animationDuration;

  const AnimatedStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _animation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;
  int _previousValue = 0;
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.color,
      end: widget.color.withOpacity(0.7),
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _currentValue = widget.value;
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(AnimatedStatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.value != widget.value) {
      _previousValue = _currentValue;
      _currentValue = widget.value;
      
      _animationController.reset();
      _animationController.forward();
      
      // Add pulse effect when value changes
      _pulseController.forward().then((_) {
        _pulseController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: widget.onTap,
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
                        widget.icon,
                        color: widget.color,
                        size: iconSize,
                      ),
                    ],
                  ),
                  SizedBox(height: 16 * scaleFactor),
                  Flexible(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_animation, _pulseAnimation, _colorAnimation]),
                        builder: (context, child) {
                          // Interpolate between previous and current value
                          final animatedValue = (_previousValue + 
                              (_currentValue - _previousValue) * _animation.value).round();
                          
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Text(
                              animatedValue.toString(),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _colorAnimation.value ?? widget.color,
                                fontSize: numberSize,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8 * scaleFactor),
                  Text(
                    widget.title,
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
