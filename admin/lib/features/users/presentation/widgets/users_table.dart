import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/users/presentation/widgets/delete_user_dialog.dart';
import 'package:openauth/features/users/presentation/widgets/toggle_user_status_dialog.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../../core/constants/app_constants.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_state.dart';
import 'user_row.dart';
import 'edit_user_dialog.dart';
import 'user_permissions_dialog.dart';
import 'user_groups_dialog.dart';
import '../../../sessions/presentation/widgets/user_sessions_dialog.dart';
import '../../../profile/presentation/widgets/user_profiles_dialog.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

class UsersTable extends StatelessWidget {

  const UsersTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
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
                              side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5)),
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
        EditUserDialog.show( context, user, _handleUserAction);
        break;
      case 'permissions':
        UserPermissionsDialog.show(context, user);
        break;
      case 'groups':
        UserGroupsDialog.show( context, user);
        break;
      case 'sessions':
        UserSessionsDialog.show(context, user);
        break;
      case 'profiles':
        UserProfilesDialog.show(context, user);
        break;
      case 'activate':
      case 'deactivate':
        ToggleUserStatusDialog.show(context, user);
        break;
      case 'delete':
        DeleteUserDialog.show(context, user);
        break;
    }
  }

 


 

 

  
}
