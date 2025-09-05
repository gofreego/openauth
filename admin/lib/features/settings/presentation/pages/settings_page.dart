import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../../core/bloc/theme_bloc.dart';
import '../../../../core/bloc/theme_event.dart';
import '../../../../core/bloc/theme_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                OutlinedButton.icon(
                  onPressed: () => _handleSignOut(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                  ),
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

            // Profile Section
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is! AuthAuthenticated) {
                  return const SizedBox.shrink();
                }

                final user = state.session.user;
                // TODO: Profile is not part of SignInResponse, need to fetch separately
                const profile = null; // state.session.profile;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Information Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _buildAvatar(context, user),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (user.username.isNotEmpty)
                                        Text(
                                          '@${user.username}',
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      if (user.email.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          user.email,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 24),
                            
                            // User Details
                            _buildInfoSection(
                              context,
                              'Account Information',
                              [
                                if (user.email.isNotEmpty)
                                  _InfoItem('Email', user.email, 
                                    trailing: user.emailVerified 
                                      ? const Icon(Icons.verified, color: Colors.green, size: 20)
                                      : const Icon(Icons.warning, color: Colors.orange, size: 20)
                                  ),
                                if (user.phone.isNotEmpty)
                                  _InfoItem('Phone', user.phone,
                                    trailing: user.phoneVerified 
                                      ? const Icon(Icons.verified, color: Colors.green, size: 20)
                                      : const Icon(Icons.warning, color: Colors.orange, size: 20)
                                  ),
                                _InfoItem('Account Status', user.isActive ? 'Active' : 'Inactive'),
                                if (user.lastLoginAt > 0)
                                  _InfoItem('Last Login', _formatDateTime(user.lastLoginAt.toInt())),
                              ],
                            ),
                            
                            if (profile != null && (profile.firstName.isNotEmpty || profile.lastName.isNotEmpty || profile.bio.isNotEmpty)) ...[
                              const SizedBox(height: 32),
                              _buildInfoSection(
                                context,
                                'Profile Information',
                                [
                                  if (profile.firstName.isNotEmpty)
                                    _InfoItem('First Name', profile.firstName),
                                  if (profile.lastName.isNotEmpty)
                                    _InfoItem('Last Name', profile.lastName),
                                  if (profile.bio.isNotEmpty)
                                    _InfoItem('Bio', profile.bio),
                                  if (profile.country.isNotEmpty)
                                    _InfoItem('Country', profile.country),
                                  if (profile.city.isNotEmpty)
                                    _InfoItem('City', profile.city),
                                  if (profile.timezone.isNotEmpty)
                                    _InfoItem('Timezone', profile.timezone),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                );
              },
            ),

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
    ToastUtils.showInfo('This feature will be implemented in a future update');
  }

  Widget _buildAvatar(BuildContext context, User user) {
    final theme = Theme.of(context);
    
    return CircleAvatar(
      radius: 40,
      backgroundImage: NetworkImage(user.avatarUrl),
      onBackgroundImageError: (_, __) {
       Text(
      UtilityFunctions.getInitials(user.name),
      style: theme.textTheme.headlineSmall?.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
      },
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<_InfoItem> items) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  item.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  item.value,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              if (item.trailing != null) item.trailing!,
            ],
          ),
        )),
      ],
    );
  }

  String _formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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

class _InfoItem {
  final String label;
  final String value;
  final Widget? trailing;

  _InfoItem(this.label, this.value, {this.trailing});
}
