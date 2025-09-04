import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/src/generated/openauth/v1/permissions.pbserver.dart';
import '../bloc/permissions_bloc.dart';
import '../widgets/permissions_header.dart';
import '../widgets/permissions_grid.dart';
import '../widgets/create_permission_dialog.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return _buildPermissionsContent();
  }

  Widget _buildPermissionsContent() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            PermissionsHeader(
              onAddPermission: _showCreatePermissionDialog,
            ),
            const SizedBox(height: 32),

            // Search and filters
            CustomSearchBar(
              showSearchIcon: true,
              onSearch: (query) {
                setState(() {
                  _searchQuery = query;
                });
                // Trigger search with new query, but only if bloc is still available
                if (mounted) {
                  final bloc = context.read<PermissionsBloc>();
                  if (!bloc.isClosed) {
                    // Use a small debounce to prevent too many requests while typing
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted && _searchQuery == query) {
                        bloc.add(ListPermissionsRequest(search: query));
                      }
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 24),

            // Permissions grid with API integration
            Expanded(
              child: BlocConsumer<PermissionsBloc, PermissionsState>(
                listener: (context, state) {
                  if (state is PermissionError) {
                    ToastUtils.showError(state.message);
                  } else if (state is PermissionCreated) {
                    ToastUtils.showSuccess('Permission created successfully');
                  } else if (state is PermissionUpdated) {
                    ToastUtils.showSuccess('Permission updated successfully');
                  } else if (state is PermissionDeleted) {
                    ToastUtils.showSuccess('Permission deleted successfully');
                  }
                },
                builder: (context, state) {
                  if (state is PermissionsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PermissionsLoaded) {
                    return PermissionsGrid(
                      permissions: state.permissions,
                      searchQuery: _searchQuery,
                      hasReachedMax: state.hasReachedMax,
                      isLoadingMore: state.isLoadingMore,
                      onLoadMore: () {
                        if (mounted) {
                          final bloc = context.read<PermissionsBloc>();
                          if (!bloc.isClosed) {
                            bloc.add(ListPermissionsRequest());
                          }
                        }
                      },
                    );
                  } else if (state is PermissionsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading permissions',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (mounted) {
                                final bloc = context.read<PermissionsBloc>();
                                if (!bloc.isClosed) {
                                  bloc.add(ListPermissionsRequest());
                                }
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  // Initial state or other states
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    void _showCreatePermissionDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PermissionsBloc>(),
        child: CreatePermissionDialog(
          onPermissionCreated: () {
            // The BlocConsumer above will handle the success message
          },
        ),
      ),
    );
  }
}
