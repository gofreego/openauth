import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/config_page_header.dart';
import '../widgets/config_entities_table.dart';
import '../widgets/create_config_entity_dialog.dart';
import '../bloc/config_entities_bloc.dart';

class ConfigsPage extends StatefulWidget {
  const ConfigsPage({super.key});

  @override
  State<ConfigsPage> createState() => _ConfigsPageState();
}

class _ConfigsPageState extends State<ConfigsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load config entities when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
        limit: PaginationConstants.defaultPageLimit,
        offset: 0,
      ));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ConfigPageHeader(
            onAddEntity: () {
              CreateConfigEntityDialog.show(context);
            },
          ),
          const SizedBox(height: 32),

          // Search functionality (for future enhancement)
          CustomSearchBar(
            hintText: 'Search by name, display name, or description...',
            onSearch: (query) {
              _performSearch(query);
            },
            onClear: () {
              context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
                limit: PaginationConstants.defaultPageLimit,
                offset: 0,
              ));
            },
          ),
          const SizedBox(height: 16),
          
          // Config entities table
          const Expanded(
            child: ConfigEntitiesTable(),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    final trimmedQuery = query.trim();
    context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
      limit: PaginationConstants.defaultPageLimit,
      offset: 0,
      search: trimmedQuery.isNotEmpty ? trimmedQuery : null,
    ));
  }
}