import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/theme_bloc.dart';
import '../../../../core/bloc/theme_event.dart';
import '../../../../core/bloc/theme_state.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback? onBackToDashboard;

  const SettingsPage({
    super.key,
    this.onBackToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Settings',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (onBackToDashboard != null)
                  TextButton.icon(
                    onPressed: onBackToDashboard,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Dashboard'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Configure your preferences and system settings',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Settings Sections
            _buildSettingsSection(
              context: context,
              title: 'Appearance',
              icon: Icons.palette_outlined,
              children: [
                _buildThemeToggle(context),
              ],
            ),
            
            const SizedBox(height: 32),
            
            _buildSettingsSection(
              context: context,
              title: 'Security',
              icon: Icons.security_outlined,
              children: [
                _buildSecuritySetting(
                  context: context,
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add an extra layer of security to your account',
                  icon: Icons.verified_user_outlined,
                  isEnabled: true,
                  onChanged: (value) {
                    // Handle 2FA toggle
                    _showFeatureNotImplemented(context);
                  },
                ),
                const SizedBox(height: 16),
                _buildSecuritySetting(
                  context: context,
                  title: 'Session Timeout',
                  subtitle: 'Automatically log out after 30 minutes of inactivity',
                  icon: Icons.timer_outlined,
                  isEnabled: false,
                  onChanged: (value) {
                    // Handle session timeout toggle
                    _showFeatureNotImplemented(context);
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            _buildSettingsSection(
              context: context,
              title: 'Notifications',
              icon: Icons.notifications_outlined,
              children: [
                _buildNotificationSetting(
                  context: context,
                  title: 'Email Notifications',
                  subtitle: 'Receive email alerts for important events',
                  isEnabled: true,
                  onChanged: (value) {
                    _showFeatureNotImplemented(context);
                  },
                ),
                const SizedBox(height: 16),
                _buildNotificationSetting(
                  context: context,
                  title: 'Push Notifications',
                  subtitle: 'Get notified instantly about system events',
                  isEnabled: false,
                  onChanged: (value) {
                    _showFeatureNotImplemented(context);
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            _buildSettingsSection(
              context: context,
              title: 'System',
              icon: Icons.settings_outlined,
              children: [
                _buildSystemSetting(
                  context: context,
                  title: 'Export Data',
                  subtitle: 'Download your data in CSV format',
                  icon: Icons.download_outlined,
                  onTap: () {
                    _showFeatureNotImplemented(context);
                  },
                ),
                const SizedBox(height: 16),
                _buildSystemSetting(
                  context: context,
                  title: 'Backup Settings',
                  subtitle: 'Configure automatic backup preferences',
                  icon: Icons.backup_outlined,
                  onTap: () {
                    _showFeatureNotImplemented(context);
                  },
                ),
                const SizedBox(height: 16),
                _buildSystemSetting(
                  context: context,
                  title: 'API Configuration',
                  subtitle: 'Manage API keys and integration settings',
                  icon: Icons.api_outlined,
                  onTap: () {
                    _showFeatureNotImplemented(context);
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            _buildSettingsSection(
              context: context,
              title: 'About',
              icon: Icons.info_outlined,
              children: [
                _buildAboutSetting(
                  context: context,
                  title: 'Version',
                  subtitle: '1.0.0',
                  icon: Icons.code_outlined,
                ),
                const SizedBox(height: 16),
                _buildAboutSetting(
                  context: context,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  icon: Icons.privacy_tip_outlined,
                  onTap: () {
                    _showFeatureNotImplemented(context);
                  },
                ),
                const SizedBox(height: 16),
                _buildAboutSetting(
                  context: context,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms of service',
                  icon: Icons.description_outlined,
                  onTap: () {
                    _showFeatureNotImplemented(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        IconData icon;
        String title;
        String subtitle;
        
        if (state is ThemeLight) {
          icon = Icons.light_mode;
          title = 'Light Mode';
          subtitle = 'App will use light theme';
        } else if (state is ThemeDark) {
          icon = Icons.dark_mode;
          title = 'Dark Mode';
          subtitle = 'App will use dark theme';
        } else {
          icon = Icons.brightness_auto;
          title = 'System Mode';
          subtitle = 'App will follow system preference';
        }

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.onPrimaryContainer,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getThemeButtonText(state),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          onTap: () {
            context.read<ThemeBloc>().add(const ThemeChanged());
          },
        );
      },
    );
  }

  String _getThemeButtonText(ThemeState state) {
    if (state is ThemeLight) return 'Light';
    if (state is ThemeDark) return 'Dark';
    return 'System';
  }

  Widget _buildSecuritySetting({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: isEnabled,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNotificationSetting({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isEnabled ? Icons.notifications : Icons.notifications_off,
          color: theme.colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: isEnabled,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSystemSetting({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  Widget _buildAboutSetting({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            )
          : null,
      onTap: onTap,
    );
  }

  void _showFeatureNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('This feature will be implemented in a future update'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
