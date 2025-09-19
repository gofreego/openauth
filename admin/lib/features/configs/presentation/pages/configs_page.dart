import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/configs.pb.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/config_entities_bloc.dart';
import '../bloc/config_entities_state.dart';
import '../bloc/configs_bloc.dart';
import '../bloc/configs_state.dart';
import '../widgets/create_config_dialog.dart';
import '../widgets/config_detail_dialog.dart';

class ConfigsPage extends StatefulWidget {
  final int entityId;

  const ConfigsPage({
    super.key,
    required this.entityId,
  });

  @override
  State<ConfigsPage> createState() => _ConfigsPageState();
}

class _ConfigsPageState extends State<ConfigsPage> {
  ConfigEntity? _entity;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load configs for this entity
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // First, try to get the entity from the current entities list
      final entitiesState = context.read<ConfigEntitiesBloc>().state;
      if (entitiesState is ConfigEntitiesLoaded) {
        final entity = entitiesState.entities.where(
          (e) => e.id.toInt() == widget.entityId,
        ).firstOrNull;
        if (entity != null) {
          setState(() {
            _entity = entity;
          });
        }
      }
      
      // Load configs for this entity
      _loadConfigs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_entity?.displayName ?? 'Configs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              onPressed: _showCreateConfigDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Config'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search functionality
            CustomSearchBar(
              hintText: 'Search configs by key, display name, or description...',
              onSearch: (query) {
                _performSearch(query);
              },
              onClear: () {
                _loadConfigs();
              },
            ),
            const SizedBox(height: 16),
            
            // Configs table
            Expanded(
              child: _buildConfigsTable(),
            ),
          ],
        ),
      ),
    );
  }

  void _loadConfigs() {
    context.read<ConfigsBloc>().add(
      ListConfigsRequest(
        entityId: Int64(widget.entityId),
        limit: PaginationConstants.defaultPageLimit,
        offset: 0,
      ),
    );
  }

  void _performSearch(String query) {
    final trimmedQuery = query.trim();
    setState(() {
      _searchQuery = trimmedQuery;
    });
    context.read<ConfigsBloc>().add(
      ListConfigsRequest(
        entityId: Int64(widget.entityId),
        limit: PaginationConstants.defaultPageLimit,
        offset: 0,
        search: trimmedQuery.isNotEmpty ? trimmedQuery : null,
      ),
    );
  }

  Widget _buildConfigsTable() {
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
                    'Name',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Key',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Type',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                Expanded(
                  flex: 2,
                  child: Text(
                    'Value',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Actions',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Table content
          Expanded(
            child: BlocBuilder<ConfigsBloc, ConfigsState>(
              builder: (context, state) {
                if (state is ConfigsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (state is ConfigsLoaded) {
                  if (state.configs.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return ListView.builder(
                    itemCount: state.configs.length,
                    itemBuilder: (context, index) {
                      final config = state.configs[index];
                      return _buildConfigRow(config);
                    },
                  );
                }
                
                if (state is ConfigsError) {
                  return CustomErrorWidget(
                    failure: state.failure,
                    onRetry: () {
                      _loadConfigs();
                    },
                  );
                }
                
                return const Center(
                  child: Text('Unknown state'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigRow(Config config) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => _showConfigDetailDialog(config),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            
            // Display Name
            Expanded(
              flex: 2,
              child: Text(
                config.displayName.isNotEmpty ? config.displayName : '-',
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold ,
                ),

              ),
            ),
            // Key
            Expanded(
              flex: 2,
              child: Text(
                config.key,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Type
            Expanded(
              child: _buildTypeChip(config.type),
            ),
            // Value
            Expanded(
              flex: 2,
              child: _buildValueDisplay(config),
            ),
            // Actions
            Expanded(
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteDialog(config);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueDisplay(Config config) {
    final theme = Theme.of(context);
    String value = '';
    
    switch (config.type) {
      case ValueType.VALUE_TYPE_STRING:
        value = config.stringValue;
        break;
      case ValueType.VALUE_TYPE_INT:
        value = config.intValue.toString();
        break;
      case ValueType.VALUE_TYPE_FLOAT:
        value = config.floatValue.toString();
        break;
      case ValueType.VALUE_TYPE_BOOL:
        value = config.boolValue.toString();
        break;
      case ValueType.VALUE_TYPE_JSON:
        value = config.jsonValue;
        break;
      default:
        value = 'Unknown';
    }
    
    return Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tune,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ? 'No configs found for "$_searchQuery"' : 'No configs found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Try adjusting your search criteria'
                : 'Create your first config to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _showCreateConfigDialog,
              icon: const Icon(Icons.add),
              label: const Text('Create Config'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeChip(ValueType type) {
    final theme = Theme.of(context);
    final typeText = type.toString().split('.').last.replaceAll('VALUE_TYPE_', '');
    
    return Text(
        typeText,
        style: theme.textTheme.bodyMedium,
    );
  }

  void _showCreateConfigDialog() {
    CreateConfigDialog.show(
      context, 
      widget.entityId,
      onConfigCreated: () {
        // Reload configs after creation
        _loadConfigs();
      },
    );
  }

  void _showConfigDetailDialog(Config config) {
    ConfigDetailDialog.show(
      context,
      config,
      onUpdated: () {
        // Reload configs after update
        _loadConfigs();
      },
    );
  }

  void _showDeleteDialog(Config config) {
    showDialog(
      context: context,
      builder: (context) => _DeleteConfigDialog(
        config: config,
        onDeleted: () {
          // Reload configs after deletion
          _loadConfigs();
        },
      ),
    );
  }
}

class _DeleteConfigDialog extends StatelessWidget {
  final Config config;
  final VoidCallback onDeleted;

  const _DeleteConfigDialog({
    required this.config,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigsBloc, ConfigsState>(
      listener: (context, state) {
        if (state is ConfigsLoaded) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Config deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          onDeleted();
        } else if (state is ConfigsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting config: ${state.failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Delete Config'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete the config "${config.key}"?'),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final bloc = context.read<ConfigsBloc>();
              if (!bloc.isClosed) {
                bloc.add(DeleteConfigRequest(id: config.id));
              }
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
}