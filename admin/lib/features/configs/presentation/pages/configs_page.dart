import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/configs_header.dart';
import '../widgets/config_entities_tab.dart';
import '../widgets/config_values_tab.dart';
import '../widgets/create_config_entity_dialog.dart';
import '../widgets/create_config_dialog.dart';
import '../bloc/config_entities_bloc.dart';
import '../bloc/configs_bloc.dart';
import '../bloc/config_entities_state.dart';

class ConfigsPage extends StatefulWidget {
  const ConfigsPage({super.key});

  @override
  State<ConfigsPage> createState() => _ConfigsPageState();
}

class _ConfigsPageState extends State<ConfigsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load initial data when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
        limit: PaginationConstants.defaultPageLimit,
        offset: 0,
      ));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header
          ConfigsHeader(
            onAddConfigEntity: () {
              // TODO: Implement create config entity dialog
            },
          ),
          const SizedBox(height: 24),

          // Search bar
          CustomSearchBar(
            hintText: 'Search configs and entities...',
            initialQuery: _searchController.text,
            triggerSearchOnKeyStroke: true,
            onSearch: (query) {
              setState(() {
                _searchController.text = query;
                // Trigger search for current tab
                _performSearch(query);
              });
            },
          ),
          const SizedBox(height: 24),

          // Tab bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.category),
                text: 'Config Entities',
              ),
              Tab(
                icon: Icon(Icons.tune),
                text: 'Config Values',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ConfigEntitiesTab(searchQuery: _searchController.text),
                ConfigValuesTab(searchQuery: _searchController.text),
              ],
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _showCreateDialog(context),
      child: const Icon(Icons.add),
    ),
  );
}

  void _performSearch(String query) {
    final currentTab = _tabController.index;
    
    if (currentTab == 0) {
      // Search config entities
      context.read<ConfigEntitiesBloc>().add(ListConfigEntitiesRequest(
        search: query.isNotEmpty ? query : null,
        limit: PaginationConstants.defaultPageLimit,
        offset: 0,
      ));
    } else {
      // Search configs
      context.read<ConfigsBloc>().add(ListConfigsRequest(
        search: query.isNotEmpty ? query : null,
        limit: PaginationConstants.defaultPageLimit,
        offset: 0,
      ));
    }
  }

  void _showCreateDialog(BuildContext context) {
    final currentTab = _tabController.index;
    
    if (currentTab == 0) {
      // Create config entity
      showDialog(
        context: context,
        builder: (context) => const CreateConfigEntityDialog(),
      );
    } else {
      // Create config - need to get available entities first
      final state = context.read<ConfigEntitiesBloc>().state;
      if (state is ConfigEntitiesLoaded) {
        showDialog(
          context: context,
          builder: (context) => CreateConfigDialog(entities: state.entities),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please load config entities first')),
        );
      }
    }
  }
}
