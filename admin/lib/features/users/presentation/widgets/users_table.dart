import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/shared.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_state.dart';
import 'user_row.dart';
import 'edit_user_dialog.dart';
import 'user_permissions_dialog.dart';
import 'user_groups_dialog.dart';
import 'user_profiles_dialog.dart';
import '../bloc/user_profiles_bloc.dart';
import '../../../sessions/presentation/widgets/user_sessions_dialog.dart';
import '../../../../config/dependency_injection/service_locator.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

class UsersTable extends StatelessWidget {
  final String searchQuery;

  const UsersTable({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'User',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Email',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Status',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Last Login',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // For actions
              ],
            ),
          ),
          
          // Table content
          Expanded(
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UsersError) {
                  return shared.ErrorWidget(
                    failure: state.failure,
                    onRetry: () {
                      context.read<UsersBloc>().add(ListUsersRequest(
                        limit: PaginationConstants.defaultPageLimit,
                        offset: 0,
                      ));
                    },
                  );
                } else if (state is UsersLoaded) {

                  if (state.users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No users found',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: state.users.length + (!state.hasReachedMax && state.users.isNotEmpty ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.users.length) {
                        // This is the load more button at the end of the list
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: OutlinedButton.icon(
                            onPressed: state.isLoadingMore 
                                ? null 
                                : () => _loadMoreUsers(context, state),
                            icon: state.isLoadingMore 
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.expand_more),
                            label: Text(state.isLoadingMore ? 'Loading...' : 'Load More'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
                            ),
                          ),
                        );
                      }
                      
                      final user = state.users[index];
                      return UserRow(
                        user: user,
                        index: index,
                        onUserAction: _handleUserAction,
                      );
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _loadMoreUsers(BuildContext context, UsersLoaded state) {
    final searchQuery = state.currentSearch?.isNotEmpty == true ? state.currentSearch : null;
    context.read<UsersBloc>().add(ListUsersRequest(
      limit: PaginationConstants.defaultPageLimit,
      offset: state.users.length,
      search: searchQuery,
    ));
  }

  void _handleUserAction(String action, pb.User user, BuildContext context) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user, context);
        break;
      case 'permissions':
        _showUserPermissionsDialog(user, context);
        break;
      case 'groups':
        _showUserGroupsDialog(user, context);
        break;
      case 'sessions':
        _showUserSessionsDialog(user, context);
        break;
      case 'profiles':
        _showUserProfilesDialog(user, context);
        break;
      case 'activate':
      case 'deactivate':
        _toggleUserActiveStatus(user, context);
        break;
      case 'delete':
        _showDeleteUserDialog(user, context);
        break;
    }
  }

  void _showDeleteUserDialog(pb.User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              final bloc = context.read<UsersBloc>();
              if (!bloc.isClosed) {
                bloc.add(DeleteUserRequest(uuid:user.uuid));
              }
              ToastUtils.showSuccess('${user.name} deleted successfully');
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

  void _showEditUserDialog(pb.User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<UsersBloc>(),
        child: EditUserDialog(
          user: user,
          onUserUpdated: () {
            // The BlocConsumer in the dialog will handle the success message
          },
          onUserAction: _handleUserAction,
        ),
      ),
    );
  }

  void _toggleUserActiveStatus(pb.User user, BuildContext context) {
    final newStatus = !user.isActive;
    final action = newStatus ? 'activate' : 'deactivate';
    final capitalizedAction = action[0].toUpperCase() + action.substring(1);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$capitalizedAction User'),
        content: Text('Are you sure you want to $action ? ${user.name} will${action == 'activate'?'':' not'} be able to log in!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              final bloc = context.read<UsersBloc>();
              if (!bloc.isClosed) {
                bloc.add(UpdateUserRequest(
                  uuid: user.uuid,
                  isActive: newStatus,
                ));
              }
              ToastUtils.showSuccess('${user.name} ${action}d successfully');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange),
              foregroundColor: Colors.orange,
            ),
            child: Text(capitalizedAction),
          ),
        ],
      ),
    );
  }

  void _showUserSessionsDialog(pb.User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UserSessionsDialog(user: user),
    );
  }

  void _showUserPermissionsDialog(pb.User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UserPermissionsDialog(user: user),
    );
  }

  void _showUserGroupsDialog(pb.User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UserGroupsDialog(user: user),
    );
  }

  void _showUserProfilesDialog(pb.User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => serviceLocator<UserProfilesBloc>(),
        child: UserProfilesDialog(user: user),
      ),
    );
  }
}
