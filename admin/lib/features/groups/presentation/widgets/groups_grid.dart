import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/groups/presentation/widgets/group_card.dart';
import 'package:openauth/features/groups/presentation/widgets/group_details_dialog.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';
import '../bloc/groups_bloc.dart';

class GroupsGrid extends StatefulWidget {
  final List<Group> groups;
  final String searchQuery;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const GroupsGrid({
    super.key,
    required this.groups,
    required this.searchQuery,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  State<GroupsGrid> createState() => _GroupsGridState();
}

class _GroupsGridState extends State<GroupsGrid> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !widget.hasReachedMax && !widget.isLoadingMore) {
      widget.onLoadMore?.call();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Trigger when 90% scrolled
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _getFilteredGroups();
    
    if (filteredGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No groups found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.searchQuery.isNotEmpty 
                ? 'Try adjusting your search query'
                : 'Try adjusting your filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 8 : 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = (constraints.maxWidth / 320).floor().clamp(1, 10);
                final cardWidth = (constraints.maxWidth - (16 * (crossAxisCount - 1))) / crossAxisCount;
                
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ...filteredGroups.map((group) => SizedBox(
                      width: cardWidth,
                      child: GroupCard(
                        group: group,
                        onTap: () => _showGroupDetails(context, group),
                        onAction: (action) => _handleGroupAction(context, action, group),
                      ),
                    )),
                    if (widget.isLoadingMore)
                      SizedBox(
                        width: cardWidth,
                        height: 120,
                        child: const Card(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Group> _getFilteredGroups() {
    List<Group> filtered = List.from(widget.groups);
    
    // Apply search filter
    if (widget.searchQuery.isNotEmpty) {
      filtered = filtered.where((group) {
        final query = widget.searchQuery.toLowerCase();
        return group.name.toLowerCase().contains(query) ||
               group.displayName.toLowerCase().contains(query) ||
               group.description.toLowerCase().contains(query);
      }).toList();
    }
    
    return filtered;
  }

  void _showGroupDetails(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<GroupsBloc>(),
        child: GroupDetailsDialog(
          group: group,
          onEdit: () => _handleGroupAction(context, 'edit', group),
        ),
      ),
    );
  }

  void _handleGroupAction(BuildContext context, String action, Group group) {
    switch (action) {
      case 'edit':
        _showEditGroupDialog(context, group);
        break;
      case 'delete':
        _showDeleteGroupDialog(context, group);
        break;
      case 'manage_users':
        _showManageUsersDialog(context, group);
        break;
    }
  }

  void _showEditGroupDialog(BuildContext context, Group group) {
    // Create edit dialog similar to create dialog but pre-filled
    final nameController = TextEditingController(text: group.name);
    final displayNameController = TextEditingController(text: group.displayName);
    final descriptionController = TextEditingController(text: group.description);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Group'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'e.g., administrators',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  hintText: 'e.g., Administrators',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief description of the group',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Update group logic
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteGroupDialog(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
          'Are you sure you want to delete "${group.displayName}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<GroupsBloc>().add(DeleteGroup(group.id));
              Navigator.of(context).pop();
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

  void _showManageUsersDialog(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Manage Users - ${group.displayName}'),
        content: const SizedBox(
          width: 600,
          height: 400,
          child: Center(
            child: Text('User management functionality coming soon...'),
          ),
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
