import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import '../bloc/groups_bloc.dart';
import '../widgets/groups_header.dart';
import '../widgets/groups_grid.dart';
import '../widgets/create_group_dialog.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load groups when page is initialized
    context.read<GroupsBloc>().add(const LoadGroups());
  }

  @override
  Widget build(BuildContext context) {
    return _buildGroupsContent();
  }

  Widget _buildGroupsContent() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            GroupsHeader(
              onAddGroup: _showCreateGroupDialog,
            ),
            const SizedBox(height: 32),

            // Search and filters
            CustomSearchBar(
              onSearch: (query) {
                setState(() {
                  _searchQuery = query;
                });
                // Trigger search with new query, but only if bloc is still available
                if (mounted) {
                  final bloc = context.read<GroupsBloc>();
                  if (!bloc.isClosed) {
                    // Use a small debounce to prevent too many requests while typing
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted && _searchQuery == query) {
                        bloc.add(SearchGroups(query));
                      }
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 24),

            // Groups grid with API integration
            Expanded(
              child: BlocConsumer<GroupsBloc, GroupsState>(
                listener: (context, state) {
                  if (state is GroupsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is GroupCreated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Group created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is GroupUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Group updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is GroupDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Group deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GroupsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GroupsLoaded) {
                    return GroupsGrid(
                      groups: state.groups,
                      searchQuery: _searchQuery,
                      hasReachedMax: state.hasReachedMax,
                      isLoadingMore: false,
                      onLoadMore: () {
                        // TODO: Implement load more functionality
                      },
                    );
                  } else if (state is GroupsError) {
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
                            'Error loading groups',
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
                                final bloc = context.read<GroupsBloc>();
                                if (!bloc.isClosed) {
                                  bloc.add(const LoadGroups());
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

    void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<GroupsBloc>(),
        child: const CreateGroupDialog(),
      ),
    );
  }
}
