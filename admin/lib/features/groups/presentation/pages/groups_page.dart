import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/src/generated/openauth/v1/groups.pb.dart';
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
    context.read<GroupsBloc>().add(ListGroupsRequest(
      limit: context.read<GroupsBloc>().listGroupsLimit,
      offset: 0,
    ));
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
                        bloc.add(ListGroupsRequest(
                          search: query,
                          limit: bloc.listGroupsLimit,
                          offset: 0,
                        ));
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
                    ToastUtils.showError(state.message);
                  } else if (state is GroupCreated) {

                    ToastUtils.showSuccess('Group created successfully');
                  } else if (state is GroupUpdated) {
                    ToastUtils.showSuccess('Group updated successfully');
                  } else if (state is GroupDeleted) {
                    ToastUtils.showSuccess('Group deleted successfully');
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
                      isLoadingMore: state.isLoadingMore,
                      onLoadMore: () {
                        if (!state.hasReachedMax && !state.isLoadingMore) {
                          final bloc = context.read<GroupsBloc>();
                          bloc.add(ListGroupsRequest(
                            search: _searchQuery.isNotEmpty ? _searchQuery : null,
                            limit: bloc.listGroupsLimit,
                            offset: state.groups.length,
                          ));
                        }
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
                                  bloc.add(ListGroupsRequest(
                                    search: _searchQuery.isNotEmpty ? _searchQuery : null,
                                    limit: bloc.listGroupsLimit,
                                    offset: 0,
                                  ));
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
