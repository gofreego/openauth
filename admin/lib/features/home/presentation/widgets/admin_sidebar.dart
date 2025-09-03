import 'package:flutter/material.dart';
import 'compact_user_profile.dart';
import '../../../../shared/shared.dart';

enum NavigationSection {
  dashboard,
  users,
  permissions,
  groups,
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
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const AppLogo.medium(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'OpenAuth Admin',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
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
            child: CompactUserProfile(
              onTap: () => onSectionChanged(NavigationSection.profile),
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
        selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onTap: () => onSectionChanged(section),
      ),
    );
  }
}
