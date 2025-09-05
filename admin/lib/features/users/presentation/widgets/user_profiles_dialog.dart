import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/shared/widgets/info_row_with_copy.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart' as pb;
import '../bloc/user_profiles_bloc.dart';
import '../bloc/user_profiles_state.dart';

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
      context.read<UserProfilesBloc>().add(
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

    return BlocListener<UserProfilesBloc, UserProfilesState>(
      listener: (context, state) {
        if (state is UserProfileDeleted) {
          ToastUtils.showSuccess(state.message);
          // Reload profiles after deletion
          context.read<UserProfilesBloc>().add(
            pb.ListUserProfilesRequest(
              userUuid: widget.user.uuid,
              limit: 50,
              offset: 0,
            ),
          );
        } else if (state is UserProfilesError) {
          ToastUtils.showError('Error: ${state.message}');
        } else if (state is UserProfileCreated) {
          ToastUtils.showSuccess(state.message);
          // Reload profiles after creation
          context.read<UserProfilesBloc>().add(
            pb.ListUserProfilesRequest(
              userUuid: widget.user.uuid,
              limit: 50,
              offset: 0,
            ),
          );
        } else if (state is UserProfileUpdated) {
          ToastUtils.showSuccess(state.message);
          // Reload profiles after update
          context.read<UserProfilesBloc>().add(
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
            maxWidth: 800,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: BlocBuilder<UserProfilesBloc, UserProfilesState>(
            builder: (context, state) {
              if (state is UserProfilesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is UserProfilesLoaded) {
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

              if (state is UserProfilesError) {
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
      builder: (context) => BlocProvider.value(
        value: context.read<UserProfilesBloc>(),
        child: CreateEditProfileDialog(
          userUuid: widget.user.uuid,
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, pb.UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<UserProfilesBloc>(),
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
              context.read<UserProfilesBloc>().add(
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

// Placeholder for the create/edit profile dialog
class CreateEditProfileDialog extends StatefulWidget {
  final String userUuid;
  final pb.UserProfile? profile;

  const CreateEditProfileDialog({
    super.key,
    required this.userUuid,
    this.profile,
  });

  @override
  State<CreateEditProfileDialog> createState() => _CreateEditProfileDialogState();
}

class _CreateEditProfileDialogState extends State<CreateEditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _profileNameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _displayNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _avatarUrlController;
  late final TextEditingController _countryController;
  late final TextEditingController _cityController;
  late final TextEditingController _timezoneController;
  late final TextEditingController _localeController;
  late final TextEditingController _websiteUrlController;

  bool get isEditing => widget.profile != null;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _profileNameController = TextEditingController(text: profile?.profileName ?? '');
    _firstNameController = TextEditingController(text: profile?.firstName ?? '');
    _lastNameController = TextEditingController(text: profile?.lastName ?? '');
    _displayNameController = TextEditingController(text: profile?.displayName ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _avatarUrlController = TextEditingController(text: profile?.avatarUrl ?? '');
    _countryController = TextEditingController(text: profile?.country ?? '');
    _cityController = TextEditingController(text: profile?.city ?? '');
    _timezoneController = TextEditingController(text: profile?.timezone ?? '');
    _localeController = TextEditingController(text: profile?.locale ?? '');
    _websiteUrlController = TextEditingController(text: profile?.websiteUrl ?? '');
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();
    _avatarUrlController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _timezoneController.dispose();
    _localeController.dispose();
    _websiteUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Profile' : 'Create Profile'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _profileNameController,
                  decoration: const InputDecoration(
                    labelText: 'Profile Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Profile name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.display_settings_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _avatarUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Avatar URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _countryController,
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _timezoneController,
                        decoration: const InputDecoration(
                          labelText: 'Timezone',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _localeController,
                        decoration: const InputDecoration(
                          labelText: 'Locale',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.language_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _websiteUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Website URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.web_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        BlocBuilder<UserProfilesBloc, UserProfilesState>(
          builder: (context, state) {
            final isLoading = state is UserProfileCreating || state is UserProfileUpdating;
            return FilledButton(
              onPressed: isLoading ? null : _handleSave,
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Update' : 'Create'),
            );
          },
        ),
      ],
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (isEditing) {
        context.read<UserProfilesBloc>().add(
          pb.UpdateProfileRequest(
            profileUuid: widget.profile!.uuid,
            profileName: _profileNameController.text.trim().isNotEmpty 
                ? _profileNameController.text.trim() 
                : null,
            firstName: _firstNameController.text.trim().isNotEmpty 
                ? _firstNameController.text.trim() 
                : null,
            lastName: _lastNameController.text.trim().isNotEmpty 
                ? _lastNameController.text.trim() 
                : null,
            displayName: _displayNameController.text.trim().isNotEmpty 
                ? _displayNameController.text.trim() 
                : null,
            bio: _bioController.text.trim().isNotEmpty 
                ? _bioController.text.trim() 
                : null,
            avatarUrl: _avatarUrlController.text.trim().isNotEmpty 
                ? _avatarUrlController.text.trim() 
                : null,
            country: _countryController.text.trim().isNotEmpty 
                ? _countryController.text.trim() 
                : null,
            city: _cityController.text.trim().isNotEmpty 
                ? _cityController.text.trim() 
                : null,
            timezone: _timezoneController.text.trim().isNotEmpty 
                ? _timezoneController.text.trim() 
                : null,
            locale: _localeController.text.trim().isNotEmpty 
                ? _localeController.text.trim() 
                : null,
            websiteUrl: _websiteUrlController.text.trim().isNotEmpty 
                ? _websiteUrlController.text.trim() 
                : null,
          ),
        );
      } else {
        context.read<UserProfilesBloc>().add(
          pb.CreateProfileRequest(
            userUuid: widget.userUuid,
            profileName: _profileNameController.text.trim().isNotEmpty 
                ? _profileNameController.text.trim() 
                : null,
            firstName: _firstNameController.text.trim().isNotEmpty 
                ? _firstNameController.text.trim() 
                : null,
            lastName: _lastNameController.text.trim().isNotEmpty 
                ? _lastNameController.text.trim() 
                : null,
            displayName: _displayNameController.text.trim().isNotEmpty 
                ? _displayNameController.text.trim() 
                : null,
            bio: _bioController.text.trim().isNotEmpty 
                ? _bioController.text.trim() 
                : null,
            avatarUrl: _avatarUrlController.text.trim().isNotEmpty 
                ? _avatarUrlController.text.trim() 
                : null,
            country: _countryController.text.trim().isNotEmpty 
                ? _countryController.text.trim() 
                : null,
            city: _cityController.text.trim().isNotEmpty 
                ? _cityController.text.trim() 
                : null,
            timezone: _timezoneController.text.trim().isNotEmpty 
                ? _timezoneController.text.trim() 
                : null,
            locale: _localeController.text.trim().isNotEmpty 
                ? _localeController.text.trim() 
                : null,
            websiteUrl: _websiteUrlController.text.trim().isNotEmpty 
                ? _websiteUrlController.text.trim() 
                : null,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }
}
