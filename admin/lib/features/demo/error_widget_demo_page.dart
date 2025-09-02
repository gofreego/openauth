import 'package:flutter/material.dart';
import '../../../core/errors/failures.dart';
import '../../../shared/widgets/error_widget.dart' as shared;

/// Demo page showing different ErrorWidget usage patterns
class ErrorWidgetDemoPage extends StatefulWidget {
  const ErrorWidgetDemoPage({super.key});

  @override
  State<ErrorWidgetDemoPage> createState() => _ErrorWidgetDemoPageState();
}

class _ErrorWidgetDemoPageState extends State<ErrorWidgetDemoPage> {
  int _selectedFailureIndex = 0;

  final List<Failure> _sampleFailures = [
    const NetworkFailure(message: 'Unable to connect to the server. Please check your internet connection.'),
    const ServerFailure(message: 'Internal server error occurred. Please try again later.'),
    const CacheFailure(message: 'Failed to load data from local storage.'),
    const ValidationFailure(message: 'Please enter a valid email address.'),
    const AuthenticationFailure(message: 'Your session has expired. Please log in again.'),
    const ServiceUnavailableFailure(message: 'The service is temporarily unavailable for maintenance.'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Widget Demo'),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Error Widget Usage Examples',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Failure Type Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Failure Type:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        _sampleFailures.length,
                        (index) => ChoiceChip(
                          label: Text(_getFailureName(_sampleFailures[index])),
                          selected: _selectedFailureIndex == index,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFailureIndex = index;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Full-size ErrorWidget Example
            Text(
              '1. Full-size ErrorWidget',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: SizedBox(
                height: 400,
                child: shared.ErrorWidget(
                  failure: _sampleFailures[_selectedFailureIndex],
                  onRetry: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Retry action triggered!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Compact ErrorWidget Example
            Text(
              '2. Compact ErrorWidget',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            shared.CompactErrorWidget(
              failure: _sampleFailures[_selectedFailureIndex],
              onRetry: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Compact retry action triggered!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // ErrorWidget without retry button
            Text(
              '3. ErrorWidget without Retry Button',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: SizedBox(
                height: 300,
                child: shared.ErrorWidget(
                  failure: _sampleFailures[_selectedFailureIndex],
                  showRetryButton: false,
                  customTitle: 'Custom Error Title',
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Error SnackBar Example
            Text(
              '4. Error SnackBar',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  shared.ErrorSnackBar.show(
                    context,
                    _sampleFailures[_selectedFailureIndex],
                    onRetry: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('SnackBar retry action triggered!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
                child: const Text('Show Error SnackBar'),
              ),
            ),
            const SizedBox(height: 32),

            // Usage Code Example
            Text(
              '5. Usage Examples',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Code Examples:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '''// In BlocBuilder for full-page errors
if (state is ErrorState) {
  return ErrorWidget(
    failure: state.failure,
    onRetry: () => bloc.add(RetryEvent()),
  );
}

// For inline/compact errors
CompactErrorWidget(
  failure: failure,
  onRetry: () => performRetry(),
)

// For temporary notifications
ErrorSnackBar.show(
  context,
  failure,
  onRetry: () => performRetry(),
);''',
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getFailureName(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Network';
      case ServerFailure:
        return 'Server';
      case CacheFailure:
        return 'Cache';
      case ValidationFailure:
        return 'Validation';
      case AuthenticationFailure:
        return 'Auth';
      case ServiceUnavailableFailure:
        return 'Service Unavailable';
      default:
        return 'Unknown';
    }
  }
}
