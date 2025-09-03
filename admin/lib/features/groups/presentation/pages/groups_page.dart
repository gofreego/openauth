import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../bloc/groups_bloc.dart';
import '../widgets/groups_header.dart';
import '../widgets/groups_table.dart';
import '../../../../shared/widgets/error_widget.dart' as shared;

class GroupsPage extends StatefulWidget {
  final VoidCallback? onBackToDashboard;

  const GroupsPage({
    super.key,
    this.onBackToDashboard,
  });

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

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    context.read<GroupsBloc>().add(SearchGroups(query));
  }

  void _onRefresh() {
    context.read<GroupsBloc>().add(RefreshGroups(search: _searchQuery.isEmpty ? null : _searchQuery));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupsHeader(
            onSearchChanged: _onSearchChanged,
            onRefresh: _onRefresh,
            onBackToDashboard: widget.onBackToDashboard,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<GroupsBloc, GroupsState>(
              builder: (context, state) {
                if (state is GroupsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GroupsError) {
                  return Center(
                    child: shared.ErrorWidget(
                      failure: ServerFailure(message: state.message),
                      onRetry: _onRefresh,
                    ),
                  );
                } else if (state is GroupsLoaded) {
                  return GroupsTable(
                    groups: state.groups,
                    searchQuery: _searchQuery,
                  );
                } else {
                  return const Center(
                    child: Text('No groups available'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
