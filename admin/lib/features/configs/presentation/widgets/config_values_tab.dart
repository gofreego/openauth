import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/widgets/widgets.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/configs_bloc.dart';
import '../bloc/configs_state.dart';

class ConfigValuesTab extends StatefulWidget {
  final String searchQuery;

  const ConfigValuesTab({
    super.key,
    required this.searchQuery,
  });

  @override
  State<ConfigValuesTab> createState() => _ConfigValuesTabState();
}

class _ConfigValuesTabState extends State<ConfigValuesTab> {
  @override
  void initState() {
    super.initState();
    // Load configs when tab is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfigsBloc>().add(ListConfigsRequest(
        limit: PaginationConstants.defaultPageLimit,
        offset: 0,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConfigsBloc, ConfigsState>(
      listener: (context, state) {
        if (state is ConfigsError) {
          ToastUtils.showError(state.message);
        } else if (state is ConfigCreated) {
          ToastUtils.showSuccess('Config created successfully');
          _refreshConfigs();
        } else if (state is ConfigUpdated) {
          ToastUtils.showSuccess('Config updated successfully');
          _refreshConfigs();
        } else if (state is ConfigDeleted) {
          ToastUtils.showSuccess('Config deleted successfully');
          _refreshConfigs();
        }
      },
      builder: (context, state) {
        if (state is ConfigsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ConfigsLoaded) {
          return _buildConfigsList(state);
        } else if (state is ConfigsError) {
          return Center(
            child: CustomErrorWidget(
              failure: state.failure,
              onRetry: _refreshConfigs,
            ),
          );
        }
        // Initial state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildConfigsList(ConfigsLoaded state) {
    if (state.configs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tune_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              widget.searchQuery.isEmpty
                  ? 'No configurations found'
                  : 'No configurations match your search',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.searchQuery.isEmpty
                  ? 'Create config entities first, then add configurations'
                  : 'Try adjusting your search query',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.configs.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.configs.length) {
          // Loading indicator for load more
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final config = state.configs[index];
        return _buildConfigCard(config);
      },
    );
  }

  Widget _buildConfigCard(Config config) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(config.type).withValues(alpha: 0.1),
          child: Icon(
            _getTypeIcon(config.type),
            color: _getTypeColor(config.type),
          ),
        ),
        title: Text(
          config.displayName.isNotEmpty ? config.displayName : config.key,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.key,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  config.key,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getTypeColor(config.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    config.type.toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getTypeColor(config.type),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (config.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                config.description,
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.data_object,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _formatValue(config),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                // TODO: Implement edit dialog
                break;
              case 'delete':
                _showDeleteConfirmation(config);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                dense: true,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                dense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'string':
        return Colors.blue;
      case 'int':
        return Colors.green;
      case 'float':
        return Colors.orange;
      case 'bool':
        return Colors.purple;
      case 'json':
        return Colors.red;
      case 'choice':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'string':
        return Icons.text_fields;
      case 'int':
        return Icons.numbers;
      case 'float':
        return Icons.functions;
      case 'bool':
        return Icons.toggle_on;
      case 'json':
        return Icons.data_object;
      case 'choice':
        return Icons.list;
      default:
        return Icons.help;
    }
  }

  String _formatValue(Config config) {
    switch (config.whichValue()) {
      case Config_Value.stringValue:
        return '"${config.stringValue}"';
      case Config_Value.intValue:
        return config.intValue.toString();
      case Config_Value.floatValue:
        return config.floatValue.toString();
      case Config_Value.boolValue:
        return config.boolValue.toString();
      case Config_Value.jsonValue:
        return config.jsonValue;
      case Config_Value.notSet:
        return 'No value set';
    }
  }

  void _showDeleteConfirmation(Config config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Configuration'),
        content: Text(
          'Are you sure you want to delete "${config.displayName.isNotEmpty ? config.displayName : config.key}"?\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ConfigsBloc>().add(
                DeleteConfigRequest(id: config.id),
              );
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

  void _refreshConfigs() {
    context.read<ConfigsBloc>().add(ListConfigsRequest(
      limit: PaginationConstants.defaultPageLimit,
      offset: 0,
      search: widget.searchQuery.isNotEmpty ? widget.searchQuery : null,
    ));
  }
}
