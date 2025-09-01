import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/permissions_bloc.dart';
import '../widgets/permissions_header.dart';
import '../widgets/permissions_search_bar.dart';
import '../widgets/permissions_grid_api.dart';
import '../widgets/create_permission_dialog_api.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  String _searchQuery = '';
  bool _showSystemOnly = false;
  bool _showCustomOnly = false;

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
            PermissionsSearchBar(
              searchQuery: _searchQuery,
              showSystemOnly: _showSystemOnly,
              showCustomOnly: _showCustomOnly,
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                // Trigger search with new query
                context.read<PermissionsBloc>().add(SearchPermissions(query));
              },
              onSystemFilterChanged: (value) {
                setState(() {
                  _showSystemOnly = value;
                });
              },
              onCustomFilterChanged: (value) {
                setState(() {
                  _showCustomOnly = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Permissions grid with API integration
            Expanded(
              child: BlocConsumer<PermissionsBloc, PermissionsState>(
                listener: (context, state) {
                  if (state is PermissionError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is PermissionCreated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Permission created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is PermissionUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Permission updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is PermissionDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Permission deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PermissionsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PermissionsLoaded) {
                    return PermissionsGridAPI(
                      permissions: state.permissions,
                      searchQuery: _searchQuery,
                      showSystemOnly: _showSystemOnly,
                      showCustomOnly: _showCustomOnly,
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
                              context.read<PermissionsBloc>().add(const LoadPermissions());
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
        child: CreatePermissionDialogAPI(
          onPermissionCreated: () {
            // The BlocConsumer above will handle the success message
          },
        ),
      ),
    );
  }
}
