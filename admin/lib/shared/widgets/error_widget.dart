import 'package:flutter/material.dart';
import '../../core/errors/failures.dart';

/// A common error widget that handles all types of failures
class ErrorWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;
  final String? customTitle;
  final Widget? customIcon;
  final bool showRetryButton;
  final EdgeInsetsGeometry? padding;

  const ErrorWidget({
    super.key,
    required this.failure,
    this.onRetry,
    this.customTitle,
    this.customIcon,
    this.showRetryButton = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: padding ?? const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Error Icon
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _getErrorColor(colorScheme).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: customIcon ?? Icon(
              _getErrorIcon(),
              size: 64,
              color: _getErrorColor(colorScheme),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Error Title
          Text(
            customTitle ?? _getErrorTitle(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          // Error Message
          Text(
            failure.message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 32),
          
          // Retry Button
          if (showRetryButton && onRetry != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Get appropriate icon based on failure type
  IconData _getErrorIcon() {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return Icons.wifi_off;
      case ServerFailure _:
        return Icons.dns;
      case CacheFailure _:
        return Icons.storage;
      case ValidationFailure _:
        return Icons.error_outline;
      case AuthenticationFailure _:
        return Icons.lock;
      case ServiceUnavailableFailure _:
        return Icons.cloud_off;
      default:
        return Icons.error;
    }
  }

  /// Get appropriate title based on failure type
  String _getErrorTitle() {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return 'Connection Problem';
      case ServerFailure _:
        return 'Server Error';
      case CacheFailure _:
        return 'Storage Error';
      case ValidationFailure _:
        return 'Invalid Input';
      case AuthenticationFailure _:
        return 'Authentication Required';
      case ServiceUnavailableFailure _:
        return 'Service Unavailable';
      default:
        return 'Something Went Wrong';
    }
  }

  /// Get appropriate color based on failure type
  Color _getErrorColor(ColorScheme colorScheme) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return Colors.orange;
      case ServerFailure _:
        return colorScheme.error;
      case CacheFailure _:
        return Colors.purple;
      case ValidationFailure _:
        return Colors.amber;
      case AuthenticationFailure _:
        return Colors.red;
      case ServiceUnavailableFailure _:
        return Colors.grey;
      default:
        return colorScheme.error;
    }
  }
}

/// A compact error widget for inline usage
class CompactErrorWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const CompactErrorWidget({
    super.key,
    required this.failure,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              failure.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 12),
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              color: colorScheme.primary,
              iconSize: 20,
            ),
          ],
        ],
      ),
    );
  }
}

/// An error snackbar helper for showing errors as snackbars
class ErrorSnackBar {
  static void show(
    BuildContext context,
    Failure failure, {
    VoidCallback? onRetry,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.onError,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                failure.message,
                style: TextStyle(color: colorScheme.onError),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.error,
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: colorScheme.onError,
                onPressed: onRetry,
              )
            : null,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
