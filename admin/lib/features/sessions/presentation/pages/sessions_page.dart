import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as user_pb;
import '../../../users/presentation/bloc/users_bloc.dart';
import '../../../users/presentation/bloc/users_state.dart';
import '../../../users/presentation/bloc/users_event.dart';
import '../../../users/domain/extensions/user_extensions.dart';
import '../widgets/user_sessions_dialog.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

class SessionsPage extends StatefulWidget {
  final VoidCallback? onBackToDashboard;

  const SessionsPage({
    super.key,
    this.onBackToDashboard,
  });

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load users when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersBloc>().add(const LoadUsersEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              if (widget.onBackToDashboard != null) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: widget.onBackToDashboard,
                  tooltip: 'Back to Dashboard',
                ),
                const SizedBox(width: 16),
              ],
              Text(
                'Session Management',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Monitor and manage active user sessions across the system',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),

          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search users...',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                if (value.isNotEmpty) {
                  context.read<UsersBloc>().add(SearchUsersEvent(value));
                } else {
                  context.read<UsersBloc>().add(const LoadUsersEvent());
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // Users list with sessions
          Expanded(
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UsersLoaded) {
                  return _buildUsersList(state.users);
                } else if (state is UsersError) {
                  return shared.ErrorWidget(
                    failure: state.failure,
                    onRetry: () {
                      context.read<UsersBloc>().add(const LoadUsersEvent());
                    },
                  );
                }
                
                return const Center(
                  child: Text('Load users to manage sessions'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List<user_pb.User> users) {
    final filteredUsers = _searchQuery.isEmpty 
        ? users 
        : users.where((user) {
            return user.displayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   user.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   user.email.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

    if (filteredUsers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('User', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Last Login', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 120, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          
          // Users list
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                final theme = Theme.of(context);
                final isEven = index % 2 == 0;
                
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isEven ? null : theme.colorScheme.surface,
                  ),
                  child: Row(
                    children: [
                      // User info
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.colorScheme.primary,
                              backgroundImage: user.avatarUrl.isNotEmpty 
                                  ? NetworkImage(user.avatarUrl) 
                                  : null,
                              child: user.avatarUrl.isEmpty 
                                  ? Text(
                                      _getInitials(user),
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                    user.displayName,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '@${user.username}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Email
                      Expanded(
                        flex: 2,
                        child: Text(
                          user.email,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Status
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: user.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.isActive ? 'Active' : 'Inactive',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: user.isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      
                      // Last login
                      Expanded(
                        flex: 2,
                        child: Text(
                          user.lastLoginFormatted,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Actions
                      SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.schedule_outlined, size: 16),
                              label: const Text('Sessions'),
                              onPressed: () => _showUserSessionsDialog(user),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUserSessionsDialog(user_pb.User user) {
    showDialog(
      context: context,
      builder: (context) => UserSessionsDialog(user: user),
    );
  }

  String _getInitials(user_pb.User user) {
    final name = user.displayName;
    if (name.isEmpty) return user.username.isNotEmpty ? user.username[0].toUpperCase() : '?';
    
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
