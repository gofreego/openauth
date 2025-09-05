import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/shared/widgets/info_row_with_copy.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';
import '../../../../shared/shared.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_state.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

class EditUserDialog extends StatefulWidget {
  final pb.User user;
  final VoidCallback? onUserUpdated;
  final Function(String action, pb.User user, BuildContext context)?
      onUserAction;
  final bool isViewMode;

  const EditUserDialog({
    super.key,
    required this.user,
    this.onUserUpdated,
    this.onUserAction,
    this.isViewMode = false,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nameController;
  late final TextEditingController _avatarUrlController;
  late bool _isActive;
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _nameController = TextEditingController(text: widget.user.name);
    _avatarUrlController = TextEditingController(text: widget.user.avatarUrl);
    _isActive = widget.user.isActive;
    _isEditMode = !widget.isViewMode;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  /// Check if the current user is the admin user
  bool _isAdminUser() {
    return widget.user.username.toLowerCase() == 'admin';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          setState(() {
            _isEditMode = false;
            // Update controllers with new values
            _usernameController.text = state.user.username;
            _emailController.text = state.user.email;
            _phoneController.text = state.user.phone;
            _nameController.text = state.user.name;
            _avatarUrlController.text = state.user.avatarUrl;
            _isActive = state.user.isActive;
          });
          widget.onUserUpdated?.call();
          ToastUtils.showSuccess(
              'User ${state.user.username} updated successfully');
        } else if (state is UsersError) {
          ToastUtils.showError('Error: ${state.message}');
        }
      },
      child: AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
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
                  Text(_isEditMode ? 'Edit User' : 'User Details',
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text(
                    widget.user.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            maxWidth: 600,
            maxHeight: MediaQuery.of(context).size.height *
                0.8, // Use 80% of screen height
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    readOnly: !_isEditMode,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.badge_outlined),
                      helperText:
                          _isEditMode ? 'The name shown to other users' : null,
                      filled: !_isEditMode,
                      fillColor: !_isEditMode ? Colors.grey[100] : null,
                    ),
                    validator: _isEditMode
                        ? (value) {
                            if (value != null &&
                                value.trim().isNotEmpty &&
                                value.trim().length < 3) {
                              return 'Display name must be at least 3 characters';
                            }
                            return null;
                          }
                        : null,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Tooltip(
                    message: _isAdminUser() && _isEditMode
                        ? 'Admin username cannot be changed'
                        : '',
                    child: TextFormField(
                      controller: _usernameController,
                      readOnly: !_isEditMode || _isAdminUser(),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: !_isEditMode || _isAdminUser(),
                        fillColor: (!_isEditMode || _isAdminUser())
                            ? Colors.grey[100]
                            : null,
                      ),
                      validator: _isEditMode && !_isAdminUser()
                          ? (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username is required';
                              }
                              if (value.length < 3) {
                                return 'Username must be at least 3 characters';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    readOnly: !_isEditMode,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: !_isEditMode,
                      fillColor: !_isEditMode ? Colors.grey[100] : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: _isEditMode
                        ? (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    readOnly: !_isEditMode,
                    decoration: InputDecoration(
                      labelText: 'Phone (optional)',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.phone_outlined),
                      filled: !_isEditMode,
                      fillColor: !_isEditMode ? Colors.grey[100] : null,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: _isEditMode
                        ? (value) {
                            if (value != null && value.isNotEmpty) {
                              if (!RegExp(r'^\+?[\d\s\-\(\)]+$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                            }
                            return null;
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _avatarUrlController,
                    readOnly: !_isEditMode,
                    decoration: InputDecoration(
                      labelText: 'Avatar URL (optional)',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.image_outlined),
                      helperText: _isEditMode
                          ? 'URL to the user\'s profile picture'
                          : null,
                      filled: !_isEditMode,
                      fillColor: !_isEditMode ? Colors.grey[100] : null,
                      suffixIcon: _avatarUrlController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () => _showAvatarPreview(),
                              tooltip: 'Preview avatar',
                            )
                          : null,
                    ),
                    keyboardType: TextInputType.url,
                    onChanged: _isEditMode
                        ? (value) {
                            setState(
                                () {}); // Rebuild to show/hide preview button
                          }
                        : null,
                    validator: _isEditMode
                        ? (value) {
                            if (value != null && value.isNotEmpty) {
                              final uri = Uri.tryParse(value);
                              if (uri == null || !uri.hasAbsolutePath) {
                                return 'Please enter a valid URL';
                              }
                            }
                            return null;
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // User info card - only show in view mode
                  if (!_isEditMode) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                'User Information',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          InfoRowWithCopy(
                            label: 'ID',
                            value: widget.user.id.toString(),
                            copy: true,
                          ),
                          InfoRowWithCopy(
                            label: 'UUID',
                            value: widget.user.uuid,
                            copy: true,
                          ),
                          InfoRowWithCopy(
                            label: 'Created',
                            value: UtilityFunctions.formatDate(
                                widget.user.createdAt),
                          ),
                          InfoRowWithCopy(
                            label: 'Last Login',
                            value: UtilityFunctions.formatDateInWords(
                                widget.user.lastLoginAt),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!_isEditMode) ...[
                      // Action buttons in view mode
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => widget.onUserAction
                                ?.call('permissions', widget.user, context),
                            icon: const Icon(Icons.security_outlined, size: 16),
                            label: const Text('Permissions'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => widget.onUserAction
                                ?.call('groups', widget.user, context),
                            icon: const Icon(Icons.group_outlined, size: 16),
                            label: const Text('Groups'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => widget.onUserAction
                                ?.call('sessions', widget.user, context),
                            icon: const Icon(Icons.schedule_outlined, size: 16),
                            label: const Text('Sessions'),
                          ),
                          Tooltip(
                            message: _isAdminUser()
                                ? 'Admin user cannot be deactivated'
                                : '',
                            child: OutlinedButton.icon(
                              onPressed: _isAdminUser()
                                  ? null
                                  : () => widget.onUserAction?.call(
                                      widget.user.isActive
                                          ? 'deactivate'
                                          : 'activate',
                                      widget.user,
                                      context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.orange),
                                foregroundColor: Colors.orange,
                              ),
                              icon: Icon(
                                widget.user.isActive
                                    ? Icons.block_outlined
                                    : Icons.check_circle_outline,
                                size: 16,
                              ),
                              label: Text(widget.user.isActive
                                  ? 'Deactivate'
                                  : 'Activate'),
                            ),
                          ),
                          Tooltip(
                            message: _isAdminUser()
                                ? 'Admin user cannot be deleted'
                                : '',
                            child: OutlinedButton.icon(
                              onPressed: _isAdminUser()
                                  ? null
                                  : () {
                                      widget.onUserAction?.call(
                                          'delete', widget.user, context);
                                    },
                              icon: const Icon(Icons.delete_outline,
                                  size: 16, color: Colors.red),
                              label: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          if (!_isEditMode)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isEditMode = true;
                });
              },
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (_isEditMode) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditMode = false;
                  // Reset form to original values
                  _usernameController.text = widget.user.username;
                  _emailController.text = widget.user.email;
                  _phoneController.text = widget.user.phone;
                  _nameController.text = widget.user.name;
                  _avatarUrlController.text = widget.user.avatarUrl;
                  _isActive = widget.user.isActive;
                });
              },
              child: const Text('Cancel'),
            ),
            BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                final isUpdating = state is UserUpdating;
                return FilledButton(
                  onPressed: isUpdating ? null : _handleUpdateUser,
                  child: isUpdating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Update User'),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _handleUpdateUser() {
    if (_formKey.currentState!.validate()) {
      final hasChanges =
          _usernameController.text.trim() != widget.user.username ||
              _emailController.text.trim() != widget.user.email ||
              _phoneController.text.trim() != widget.user.phone ||
              _nameController.text.trim() != widget.user.name ||
              _avatarUrlController.text.trim() != widget.user.avatarUrl ||
              _isActive != widget.user.isActive;

      if (!hasChanges) {
        ToastUtils.showInfo('No changes detected');
        return;
      }

      if (mounted) {
        final bloc = context.read<UsersBloc>();
        if (!bloc.isClosed) {
          bloc.add(UpdateUserRequest(
            uuid: widget.user.uuid,
            username: _usernameController.text.trim() != widget.user.username
                ? _usernameController.text.trim()
                : null,
            email: _emailController.text.trim() != widget.user.email
                ? _emailController.text.trim()
                : null,
            phone: _phoneController.text.trim() != widget.user.phone
                ? _phoneController.text.trim()
                : null,
            name: _nameController.text.trim() != widget.user.name
                ? _nameController.text.trim()
                : null,
            avatarUrl: _avatarUrlController.text.trim() != widget.user.avatarUrl
                ? _avatarUrlController.text.trim()
                : null,
            isActive: _isActive != widget.user.isActive ? _isActive : null,
          ));
        }
      }
    }
  }

  void _showAvatarPreview() {
    final url = _avatarUrlController.text.trim();
    if (url.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Avatar Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(url),
              onBackgroundImageError: (_, __) {
                // Error loading image
              },
              child: null,
            ),
            const SizedBox(height: 16),
            Text(
              'This is how the avatar will appear',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
