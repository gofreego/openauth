import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/dashboard_welcome.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.dashboard,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Dashboard',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Overview of your OpenAuth system',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Total Users',
                  value: '1,234',
                  icon: Icons.people,
                  color: Colors.blue,
                  onTap: () {
                    // TODO: Navigate to users page
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Active Sessions',
                  value: '89',
                  icon: Icons.access_time,
                  color: Colors.green,
                  onTap: () {
                    // TODO: Navigate to sessions page
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Permissions',
                  value: '45',
                  icon: Icons.security,
                  color: Colors.orange,
                  onTap: () {
                    // TODO: Navigate to permissions page
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Groups',
                  value: '12',
                  icon: Icons.group,
                  color: Colors.purple,
                  onTap: () {
                    // TODO: Navigate to groups page
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Welcome section
          Expanded(
            child: DashboardWelcome(
              onAddUser: () {
                // TODO: Navigate to add user page
              },
              onManagePermissions: () {
                // TODO: Navigate to permissions page
              },
            ),
          ),
        ],
      ),
    );
  }
}
