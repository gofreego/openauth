import 'package:flutter/material.dart';
import 'package:openauth/features/groups/presentation/widgets/group_action_dialogs.dart';
import 'package:openauth/features/groups/presentation/widgets/group_card.dart';
import '../../../../src/generated/openauth/v1/groups.pb.dart';

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
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount =
                        (constraints.maxWidth / 320).floor().clamp(1, 10);
                    final cardWidth =
                        (constraints.maxWidth - (16 * (crossAxisCount - 1))) /
                            crossAxisCount;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: filteredGroups
                          .map((group) => SizedBox(
                                width: cardWidth,
                                child: GroupCard(
                                  group: group,
                                  onTap: () =>
                                      GroupActionDialogs.showGroupDetails(context, group),
                                ),
                              ))
                          .toList(),
                    );
                  },
                ),
                // Load More button below all groups
                if (!widget.hasReachedMax || widget.isLoadingMore) ...[
                  const SizedBox(height: 32),
                  widget.isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        )
                      : OutlinedButton(
                          onPressed: widget.onLoadMore,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          child: const Text('Load More Groups'),
                        ),
                  const SizedBox(height: 16),
                ],
              ],
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
}
