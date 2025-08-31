import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/app_bloc.dart';
import '../../../../core/bloc/app_state.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../shared/shared.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initialSection});

  final String? initialSection;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const AppLogo.medium(),
                const SizedBox(width: 12),
                Text(
                  'OpenAuth Admin',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            backgroundColor: theme.colorScheme.surface,
            elevation: 1,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle),
                onSelected: (value) {
                  switch (value) {
                    case 'profile':
                      _showProfile();
                      break;
                    case 'settings':
                      _showSettings();
                      break;
                    case 'logout':
                      _handleSignOut();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Sign Out'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                // Large logo display
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
                const SizedBox(height: 48),
                // Dashboard cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.2,
                    children: [
                      _buildDashboardCard(
                        context: context,
                        theme: theme,
                        icon: Icons.people_outline,
                        title: 'Users',
                        description: 'Manage user accounts and profiles',
                        onTap: _navigateToUsers,
                      ),
                      _buildDashboardCard(
                        context: context,
                        theme: theme,
                        icon: Icons.security_outlined,
                        title: 'Permissions',
                        description: 'Configure access control and permissions',
                        onTap: _navigateToPermissions,
                      ),
                      _buildDashboardCard(
                        context: context,
                        theme: theme,
                        icon: Icons.group_outlined,
                        title: 'Groups',
                        description: 'Organize users into groups',
                        onTap: _navigateToGroups,
                      ),
                      _buildDashboardCard(
                        context: context,
                        theme: theme,
                        icon: Icons.session_timeout_outlined,
                        title: 'Sessions',
                        description: 'Monitor active user sessions',
                        onTap: _navigateToSessions,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToUsers() {
    // TODO: Navigate to users page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Users page coming soon')),
    );
  }

  void _navigateToPermissions() {
    // TODO: Navigate to permissions page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permissions page coming soon')),
    );
  }

  void _navigateToGroups() {
    // TODO: Navigate to groups page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Groups page coming soon')),
    );
  }

  void _navigateToSessions() {
    // TODO: Navigate to sessions page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sessions page coming soon')),
    );
  }

  void _showProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile page coming soon')),
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings page coming soon')),
    );
  }

  void _handleSignOut() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        context.read<AuthBloc>().add(const AuthSignOutRequested());
      }
    });
  }
}
