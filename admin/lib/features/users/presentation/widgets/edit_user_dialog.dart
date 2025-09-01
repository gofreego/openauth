import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';
import '../../domain/entities/user.dart';

class EditUserDialog extends StatefulWidget {
  final UserEntity user;
  final VoidCallback? onUserUpdated;

  const EditUserDialog({
    super.key,
    required this.user,
    this.onUserUpdated,
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

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _nameController = TextEditingController(text: widget.user.displayName);
    _avatarUrlController = TextEditingController(text: widget.user.avatarUrl);
    _isActive = widget.user.isActive;
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          Navigator.of(context).pop();
          widget.onUserUpdated?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User ${state.user.username} updated successfully')),
          );
        } else if (state is UsersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
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
                      widget.user.displayName.isNotEmpty 
                          ? widget.user.displayName[0].toUpperCase()
                          : widget.user.username[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Edit User', style: Theme.of(context).textTheme.headlineSmall),
                  Text(
                    widget.user.displayName.isNotEmpty 
                        ? widget.user.displayName 
                        : widget.user.username,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username is required';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge_outlined),
                    helperText: 'The name shown to other users',
                  ),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty && value.trim().length < 2) {
                      return 'Display name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _avatarUrlController,
                  decoration: InputDecoration(
                    labelText: 'Avatar URL (optional)',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.image_outlined),
                    helperText: 'URL to the user\'s profile picture',
                    suffixIcon: _avatarUrlController.text.isNotEmpty 
                        ? IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () => _showAvatarPreview(),
                            tooltip: 'Preview avatar',
                          )
                        : null,
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    setState(() {}); // Rebuild to show/hide preview button
                  },
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final uri = Uri.tryParse(value);
                      if (uri == null || !uri.hasAbsolutePath) {
                        return 'Please enter a valid URL';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Switch(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Status',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            _isActive ? 'User is active and can log in' : 'User is inactive and cannot log in',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // User info card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'User Information',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('UUID', widget.user.uuid),
                      _buildInfoRow('Created', widget.user.formattedCreatedAt),
                      _buildInfoRow('Last Login', widget.user.lastLoginFormatted),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _handleUpdateUser() {
    if (_formKey.currentState!.validate()) {
      final hasChanges = _usernameController.text.trim() != widget.user.username ||
          _emailController.text.trim() != widget.user.email ||
          _phoneController.text.trim() != widget.user.phone ||
          _nameController.text.trim() != widget.user.displayName ||
          _avatarUrlController.text.trim() != widget.user.avatarUrl ||
          _isActive != widget.user.isActive;

      if (!hasChanges) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes detected')),
        );
        return;
      }

      if (mounted) {
        final bloc = context.read<UsersBloc>();
        if (!bloc.isClosed) {
          bloc.add(UpdateUserEvent(
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
            name: _nameController.text.trim() != widget.user.displayName 
                ? _nameController.text.trim() 
                : null,
            avatarUrl: _avatarUrlController.text.trim() != widget.user.avatarUrl 
                ? _avatarUrlController.text.trim() 
                : null,
            isActive: _isActive != widget.user.isActive 
                ? _isActive 
                : null,
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
