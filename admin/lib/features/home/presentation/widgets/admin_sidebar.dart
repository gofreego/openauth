import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import 'compact_user_profile.dart';
import '../../../../shared/shared.dart';

enum NavigationSection {
  dashboard,
  users,
  permissions,
  groups,
  sessions,
  settings,
  profile,
}

class AdminSidebar extends StatelessWidget {
  final NavigationSection currentSection;
  final Function(NavigationSection) onSectionChanged;

  const AdminSidebar({
    super.key,
    required this.currentSection,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 280,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Header with logo
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const AppLogo.medium(color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'OpenAuth Admin',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: [
                _buildNavigationItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  title: 'Dashboard',
                  section: NavigationSection.dashboard,
                ),
                const SizedBox(height: 8),
                
                // Management section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'MANAGEMENT',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.people_outline,
                  selectedIcon: Icons.people,
                  title: 'Users',
                  section: NavigationSection.users,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.security_outlined,
                  selectedIcon: Icons.security,
                  title: 'Permissions',
                  section: NavigationSection.permissions,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.group_outlined,
                  selectedIcon: Icons.group,
                  title: 'Groups',
                  section: NavigationSection.groups,
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.access_time_outlined,
                  selectedIcon: Icons.access_time,
                  title: 'Sessions',
                  section: NavigationSection.sessions,
                ),
                const SizedBox(height: 8),
                
                // System section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'SYSTEM',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  title: 'Settings',
                  section: NavigationSection.settings,
                ),
              ],
            ),
          ),

          // Login details section at bottom
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompactUserProfile(
                  onTap: () => onSectionChanged(NavigationSection.profile),
                ),
                const SizedBox(height: 16),
                
                // Sign out button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _handleSignOut(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required NavigationSection section,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentSection == section;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: ListTile(
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected 
            ? theme.colorScheme.primary 
            : theme.colorScheme.onSurfaceVariant,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected 
              ? theme.colorScheme.primary 
              : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedColor: theme.colorScheme.primary,
        selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onTap: () => onSectionChanged(section),
      ),
    );
  }

  void _handleSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
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
    );
    
    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const AuthSignOutRequested());
    }
  }
}
