import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/profiles/data/profile_repository.dart';
import 'package:openauth/shared/shared.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../../config/dependency_injection/service_locator.dart';
import '../bloc/profiles_bloc.dart';
import '../bloc/profiles_state.dart';
import 'create_edit_profile_dialog.dart';
import 'profile_card.dart';

class UserProfilesDialog extends StatefulWidget {
  final pb.User user;

  const UserProfilesDialog({
    super.key,
    required this.user,
  });
  static void show(
    BuildContext context,
    pb.User user,
  ) {
    showDialog(
      context: context,
      builder: (context) => UserProfilesDialog(user: user),
    );
  }

  @override
  State<UserProfilesDialog> createState() => _UserProfilesDialogState();
}

class _UserProfilesDialogState extends State<UserProfilesDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilesBloc(
      repository: serviceLocator<ProfileRepository>(),
    ),
      child: _UserProfilesDialogContent(user: widget.user),
    );
  }
}

class _UserProfilesDialogContent extends StatefulWidget {
  final pb.User user;

  const _UserProfilesDialogContent({
    required this.user,
  });

  @override
  State<_UserProfilesDialogContent> createState() =>
      _UserProfilesDialogContentState();
}

class _UserProfilesDialogContentState
    extends State<_UserProfilesDialogContent> {
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

    return AlertDialog(
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
                minWidth: 700,
                maxWidth: 1000,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: BlocBuilder<ProfilesBloc, ProfilesState>(
                buildWhen: (previous, current) =>
                    current is ProfilesLoading ||
                    current is ProfilesLoaded ||
                    current is ProfilesListError,
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
                            ...state.profiles.map((profile) => ProfileCard(
                                  profile: profile,
                                  onProfileAction: _handleProfileAction,
                                )),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is ProfilesListError) {
                    return  Center(
                        child: CustomErrorWidget(failure: state.failure,
                          onRetry: () {
                                context.read<ProfilesBloc>().add(
                                      pb.ListUserProfilesRequest(
                                        userUuid: widget.user.uuid,
                                        limit: 50,
                                        offset: 0,
                                      ),
                                    );
                              },
                        ),);
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
          );
  }

  void _handleProfileAction(String action, pb.UserProfile profile) {
    switch (action) {
      case 'view':
        _showViewProfileDialog(context, profile);
        break;
      case 'edit':
        _showEditProfileDialog(context, profile);
        break;
      case 'delete':
        _showDeleteProfileDialog(context, profile);
        break;
    }
  }

  void _showCreateProfileDialog(BuildContext context) {
    final mainProfilesBloc = context.read<ProfilesBloc>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => serviceLocator<ProfilesBloc>(),
        child: BlocListener<ProfilesBloc, ProfilesState>(
          listener: (context, state) {
            if (state is ProfileCreated || state is ProfileUpdated) {
             mainProfilesBloc.add(
                pb.ListUserProfilesRequest(
                  userUuid: widget.user.uuid,
                  limit: 50,
                  offset: 0,
                ),
              );
            }
          },
          child: Builder(
            builder: (context) => CreateEditProfileDialog(
              userUuid: widget.user.uuid,
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, pb.UserProfile profile) {
    final mainProfilesBloc = context.read<ProfilesBloc>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => serviceLocator<ProfilesBloc>(),
        child: BlocListener<ProfilesBloc, ProfilesState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              Navigator.of(context).pop();
              // Reload profiles in the main dialog
              mainProfilesBloc.add(
                pb.ListUserProfilesRequest(
                  userUuid: widget.user.uuid,
                  limit: 50,
                  offset: 0,
                ),
              );
            }
          },
          child: Builder(
            builder: (context) => CreateEditProfileDialog(
              userUuid: widget.user.uuid,
              profile: profile,
            ),
          ),
        ),
      ),
    );
  }

  void _showViewProfileDialog(BuildContext context, pb.UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => serviceLocator<ProfilesBloc>(),
        child: CreateEditProfileDialog(
          userUuid: widget.user.uuid,
          profile: profile,
          isViewMode: true,
        ),
      ),
    );
  }

  void _showDeleteProfileDialog(BuildContext context, pb.UserProfile profile) {
    final mainProfilesBloc = context.read<ProfilesBloc>();
    final currentState = mainProfilesBloc.state;

    // Check if this is the last profile
    final isLastProfile =
        currentState is ProfilesLoaded && currentState.profiles.length == 1;

    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => serviceLocator<ProfilesBloc>(),
        child: BlocListener<ProfilesBloc, ProfilesState>(
          listener: (context, state) {
            if (state is ProfileDeleteError) {
              ToastUtils.showError('Failed to delete profile: ${state.message}');
            }
            if (state is ProfileDeleted) {
              Navigator.of(context).pop();
              // Reload profiles in the main dialog
              mainProfilesBloc.add(
                pb.ListUserProfilesRequest(
                  userUuid: widget.user.uuid,
                  limit: 50,
                  offset: 0,
                ),
              );
            }
          },
          child: Builder(
            builder: (context) => AlertDialog(
              title: const Text('Delete Profile'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to delete the profile "${profile.displayName.isNotEmpty ? profile.displayName : profile.profileName}"?',
                  ),
                  if (isLastProfile) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        border: Border.all(color: Colors.orange.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber,
                              color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This is the last profile. Some systems may not allow deletion of the last profile.',
                              style: TextStyle(color: Colors.orange.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    'This action cannot be undone.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    var bloc =context.read<ProfilesBloc>();
                    bloc.add(
                          pb.DeleteProfileRequest(profileUuid: profile.uuid),
                        );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red
                  ),
                  child: const Text('Delete', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
