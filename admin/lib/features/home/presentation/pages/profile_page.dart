import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/widgets/auth_session_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(
              child: Text('Not authenticated'),
            );
          }

          final user = state.session.user;
          final profile = state.session.profile;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Header
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Profile',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your account information and security settings',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // User Information Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildAvatar(context, user, profile),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getDisplayName(user, profile),
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
                            FilledButton.icon(
                              onPressed: () {
                                // TODO: Implement edit profile
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Edit profile functionality coming soon'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Profile'),
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
                        
                        if (profile.firstName.isNotEmpty || profile.lastName.isNotEmpty || profile.bio.isNotEmpty) ...[
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

                const SizedBox(height: 24),

                // Session Security Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session & Security',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const AuthSessionInfo(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Account Actions Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Actions',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _handleSignOut(context),
                            icon: const Icon(Icons.logout),
                            label: const Text('Sign Out'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                              side: BorderSide(color: theme.colorScheme.error),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, dynamic user, dynamic profile) {
    final theme = Theme.of(context);
    
    // Check if profile has an avatar URL
    String? avatarUrl;
    if (profile != null && profile.avatarUrl.isNotEmpty) {
      avatarUrl = profile.avatarUrl;
    }
    
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(avatarUrl),
        onBackgroundImageError: (_, __) {
          // Fallback to initials if image fails to load
        },
      );
    }
    
    // Fallback to initials avatar
    final initials = _getInitials(_getDisplayName(user, profile));
    return CircleAvatar(
      radius: 40,
      backgroundColor: theme.colorScheme.primary,
      child: Text(
        initials,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getDisplayName(dynamic user, dynamic profile) {
    // Try to get display name from profile first
    if (profile != null) {
      if (profile.displayName.isNotEmpty) {
        return profile.displayName;
      }
      if (profile.firstName.isNotEmpty) {
        String name = profile.firstName;
        if (profile.lastName.isNotEmpty) {
          name += ' ${profile.lastName}';
        }
        return name;
      }
    }
    
    // Fallback to username or email
    if (user.username.isNotEmpty) {
      return user.username;
    }
    if (user.email.isNotEmpty) {
      return user.email;
    }
    
    return 'User';
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    
    return name.substring(0, 1).toUpperCase();
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
