import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/shared/widgets/info_row_with_copy.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../../config/dependency_injection/service_locator.dart';
import '../bloc/profiles_bloc.dart';
import '../bloc/profiles_state.dart';
import 'create_edit_profile_dialog.dart';

class UserProfilesDialog extends StatefulWidget {
  final pb.User user;

  const UserProfilesDialog({
    super.key,
    required this.user,
  });

  @override
  State<UserProfilesDialog> createState() => _UserProfilesDialogState();
}

class _UserProfilesDialogState extends State<UserProfilesDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfilesBloc>().add(
        pb.ListUserProfilesRequest(
          userUuid: widget.user.uuid,
          limit: 50,
          offset: 0,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ProfilesBloc, ProfilesState>(
      listener: (context, state) {
        if (state is ProfileDeleted) {
          ToastUtils.showSuccess(state.message);
          // Reload profiles after deletion
          context.read<ProfilesBloc>().add(
            pb.ListUserProfilesRequest(
              userUuid: widget.user.uuid,
              limit: 50,
              offset: 0,
            ),
          );
        } else if (state is ProfilesError) {
          ToastUtils.showError('Error: ${state.message}');
        } else if (state is ProfileCreated) {
          ToastUtils.showSuccess(state.message);
          // Reload profiles after creation
          context.read<ProfilesBloc>().add(
            pb.ListUserProfilesRequest(
              userUuid: widget.user.uuid,
              limit: 50,
              offset: 0,
            ),
          );
        } else if (state is ProfileUpdated) {
          ToastUtils.showSuccess(state.message);
          // Reload profiles after update
          context.read<ProfilesBloc>().add(
            pb.ListUserProfilesRequest(
              userUuid: widget.user.uuid,
              limit: 50,
              offset: 0,
            ),
          );
        }
      },
      child: AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary,
              backgroundImage: widget.user.avatarUrl.isNotEmpty
                  ? NetworkImage(widget.user.avatarUrl)
                  : null,
              child: widget.user.avatarUrl.isEmpty
                  ? Text(
                      UtilityFunctions.getInitials(widget.user.name),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'User Profiles',
                    style: theme.textTheme.headlineSmall,
                  ),
                  Text(
                    '${widget.user.name} (@${widget.user.username})',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1000,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: BlocBuilder<ProfilesBloc, ProfilesState>(
            builder: (context, state) {
              if (state is ProfilesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ProfilesLoaded) {
                if (state.profiles.isEmpty) {
                  return SizedBox(
                    width: 600,
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No profiles found',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This user has no profiles yet.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SizedBox(
                  width: 700,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${state.profiles.length} profile${state.profiles.length == 1 ? '' : 's'} found',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...state.profiles.map((profile) => _buildProfileCard(context, profile)),
                      ],
                    ),
                  ),
                );
              }

              if (state is ProfilesError) {
                return SizedBox(
                  width: 600,
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading profiles',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.red[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox(
                width: 600,
                height: 300,
                child: Center(
                  child: Text('Unknown state'),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showCreateProfileDialog(context),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Profile'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, pb.UserProfile profile) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  backgroundImage: profile.avatarUrl.isNotEmpty 
                      ? NetworkImage(profile.avatarUrl)
                      : null,
                  child: profile.avatarUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          color: theme.colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.displayName.isNotEmpty 
                            ? profile.displayName 
                            : profile.profileName.isNotEmpty 
                                ? profile.profileName 
                                : 'Unnamed Profile',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (profile.profileName.isNotEmpty && profile.displayName.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          profile.profileName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleProfileAction(value, profile),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
            if (profile.bio.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                profile.bio,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                if (profile.firstName.isNotEmpty || profile.lastName.isNotEmpty)
                  InfoRowWithCopy(
                    label: 'Name',
                    value: '${profile.firstName} ${profile.lastName}'.trim(),
                  ),
                if (profile.country.isNotEmpty)
                  InfoRowWithCopy(
                    label: 'Country',
                    value: profile.country,
                  ),
                if (profile.city.isNotEmpty)
                  InfoRowWithCopy(
                    label: 'City',
                    value: profile.city,
                  ),
                if (profile.timezone.isNotEmpty)
                  InfoRowWithCopy(
                    label: 'Timezone',
                    value: profile.timezone,
                  ),
                if (profile.locale.isNotEmpty)
                  InfoRowWithCopy(
                    label: 'Locale',
                    value: profile.locale,
                  ),
                if (profile.websiteUrl.isNotEmpty)
                  InfoRowWithCopy(
                    label: 'Website',
                    value: profile.websiteUrl,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Created ${UtilityFunctions.formatDateInWords(profile.createdAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                if (profile.updatedAt != profile.createdAt) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Updated ${UtilityFunctions.formatDateInWords(profile.updatedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleProfileAction(String action, pb.UserProfile profile) {
    switch (action) {
      case 'edit':
        _showEditProfileDialog(context, profile);
        break;
      case 'delete':
        _showDeleteProfileDialog(context, profile);
        break;
    }
  }

  void _showCreateProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => serviceLocator<ProfilesBloc>(),
        child: CreateEditProfileDialog(
          userUuid: widget.user.uuid,
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, pb.UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => serviceLocator<ProfilesBloc>(),
        child: CreateEditProfileDialog(
          userUuid: widget.user.uuid,
          profile: profile,
        ),
      ),
    );
  }

  void _showDeleteProfileDialog(BuildContext context, pb.UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text(
          'Are you sure you want to delete the profile "${profile.displayName.isNotEmpty ? profile.displayName : profile.profileName}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ProfilesBloc>().add(
                pb.DeleteProfileRequest(profileUuid: profile.uuid),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
