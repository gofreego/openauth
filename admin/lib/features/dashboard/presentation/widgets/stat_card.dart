import 'package:flutter/material.dart';

/// A reusable stat card widget for displaying dashboard metrics
class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool shouldAnimate;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
    this.shouldAnimate = false,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;
  
  String? _previousValue;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Runner-style slide animation from right to left
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    
    // Fade animation for smooth transition
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: widget.color,
      end: widget.color.withValues(alpha: 0.9),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(StatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Only animate if the value actually changed and we're told to animate
    if (widget.shouldAnimate && 
        widget.value != _previousValue && 
        _previousValue != null) {
      // Reset and start the runner animation
      _animationController.reset();
      _animationController.forward();
    }
    
    _previousValue = widget.value;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Card(
          elevation: _animationController.isAnimating ? 4 : 2,
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
                            color: _colorAnimation.value ?? widget.color,
                            size: iconSize,
                          ),
                        ],
                      ),
                      SizedBox(height: 16 * scaleFactor),
                      Flexible(
                        child: Center(
                          child: ClipRect(
                            child: SlideTransition(
                              position: widget.shouldAnimate ? _slideAnimation : 
                                        const AlwaysStoppedAnimation(Offset.zero),
                              child: FadeTransition(
                                opacity: widget.shouldAnimate ? _fadeAnimation :
                                          const AlwaysStoppedAnimation(1.0),
                                child: AnimatedSwitcher(
                                  duration: widget.shouldAnimate 
                                      ? const Duration(milliseconds: 400)
                                      : Duration.zero,
                                  transitionBuilder: (child, animation) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.5, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    widget.value,
                                    key: ValueKey(widget.value),
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _colorAnimation.value ?? widget.color,
                                      fontSize: numberSize,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
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
      },
    );
  }
}
