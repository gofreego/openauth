import 'package:flutter/material.dart';
import '../../../../shared/shared.dart';

/// A welcome section widget for the dashboard
class DashboardWelcome extends StatelessWidget {
  final VoidCallback? onAddUser;
  final VoidCallback? onManagePermissions;

  const DashboardWelcome({
    super.key,
    this.onAddUser,
    this.onManagePermissions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLogo.extraLarge(withBackground: true),
          const SizedBox(height: 24),
          Text(
            'Welcome to OpenAuth',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Authentication & Authorization Management System',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Quick actions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: onAddUser,
                icon: const Icon(Icons.person_add),
                label: const Text('Add User'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: onManagePermissions,
                icon: const Icon(Icons.security),
                label: const Text('Manage Permissions'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
