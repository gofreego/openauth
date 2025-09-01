import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// A compact user profile widget that shows only avatar and username
class CompactUserProfile extends StatelessWidget {
  final VoidCallback? onTap;

  const CompactUserProfile({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const SizedBox.shrink();
        }

        final user = state.session.user;
        // TODO: Profile is not part of SignInResponse, need to fetch separately
        const profile = null; // state.session.profile;
        
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                _buildAvatar(context, user.username, profile),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getDisplayName(user, profile),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (user.username.isNotEmpty)
                        Text(
                          '@${user.username}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(BuildContext context, String username, dynamic profile) {
    final theme = Theme.of(context);
    
    // Check if profile has an avatar URL
    String? avatarUrl;
    if (profile != null && profile.avatarUrl.isNotEmpty) {
      avatarUrl = profile.avatarUrl;
    }
    
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl),
        onBackgroundImageError: (_, __) {
          // Fallback to initials if image fails to load
        },
        child: null,
      );
    }
    
    // Fallback to initials avatar
    final initials = _getInitials(username);
    return CircleAvatar(
      radius: 20,
      backgroundColor: theme.colorScheme.primary,
      child: Text(
        initials,
        style: theme.textTheme.bodyMedium?.copyWith(
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

  String _getInitials(String username) {
    if (username.isEmpty) return 'U';
    
    final parts = username.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    
    return username.substring(0, 1).toUpperCase();
  }
}
