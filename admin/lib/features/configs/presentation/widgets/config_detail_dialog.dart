import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:openauth/shared/utils/utility_functions.dart';
import 'package:openauth/shared/widgets/info_row_with_copy.dart';
import '../../../../src/generated/openauth/v1/configs.pb.dart';
import '../bloc/configs_bloc.dart';
import '../bloc/configs_state.dart';

class ConfigDetailDialog extends StatefulWidget {
  final Config config;
  final VoidCallback? onUpdated;

  const ConfigDetailDialog({
    super.key,
    required this.config,
    this.onUpdated,
  });

  static void show(BuildContext context, Config config,
      {VoidCallback? onUpdated}) {
    showDialog(
      context: context,
      builder: (context) => ConfigDetailDialog(
        config: config,
        onUpdated: onUpdated,
      ),
    );
  }

  @override
  State<ConfigDetailDialog> createState() => _ConfigDetailDialogState();
}

class _ConfigDetailDialogState extends State<ConfigDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _keyController;
  late TextEditingController _displayNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late ValueType _selectedType;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _keyController = TextEditingController(text: widget.config.key);
    _displayNameController =
        TextEditingController(text: widget.config.displayName);
    _descriptionController =
        TextEditingController(text: widget.config.description);
    _selectedType = widget.config.type;

    // Initialize value based on type
    String initialValue = '';
    switch (widget.config.type) {
      case ValueType.VALUE_TYPE_STRING:
        initialValue = widget.config.stringValue;
        break;
      case ValueType.VALUE_TYPE_INT:
        initialValue = widget.config.intValue.toString();
        break;
      case ValueType.VALUE_TYPE_FLOAT:
        initialValue = widget.config.floatValue.toString();
        break;
      case ValueType.VALUE_TYPE_BOOL:
        initialValue = widget.config.boolValue.toString();
        break;
      case ValueType.VALUE_TYPE_JSON:
        initialValue = widget.config.jsonValue;
        // Beautify JSON for display in both view and edit modes
        final beautified = _beautifyJson(initialValue);
        if (beautified != null) {
          initialValue = beautified;
        }
        break;
      default:
        initialValue = '';
    }
    _valueController = TextEditingController(text: initialValue);
    
    // Add listener to rebuild when JSON content changes
    _valueController.addListener(() {
      if (_selectedType == ValueType.VALUE_TYPE_JSON) {
        setState(() {
          // This will trigger a rebuild and recalculate maxLines
        });
      }
    });
  }

  @override
  void dispose() {
    _keyController.dispose();
    _displayNameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ConfigsBloc, ConfigsState>(
      listener: (context, state) {
        if (state is ConfigsLoaded) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Config updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onUpdated?.call();
        } else if (state is ConfigsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating config: ${state.failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Config Details',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _isEditing
                              ? 'Edit configuration'
                              : 'View configuration details',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_isEditing) ...[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit config',
                    ),
                  ],
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Key field
                        _buildDetailField(
                          'Key',
                          _keyController,
                          enabled: _isEditing,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // Display Name field
                        _buildDetailField(
                          'Display Name',
                          _displayNameController,
                          enabled: _isEditing,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // Description field
                        _buildDetailField(
                          'Description',
                          _descriptionController,
                          enabled: _isEditing,
                          maxLines: 3,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // Type field
                        _buildTypeField(),
                        const SizedBox(height: 16),

                        // Value field
                        _buildValueField(),
                        const SizedBox(height: 16),

                        // Metadata
                        _buildMetadataSection(),
                      ],
                    ),
                  ),
                ),
              ),

              // Actions
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditing) ...[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _initializeControllers(); // Reset values
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _saveConfig,
                      child: const Text('Save Changes'),
                    ),
                  ] else ...[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(
    String label,
    TextEditingController controller, {
    bool enabled = false,
    bool required = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          validator: enabled ? (validator ?? (required ? (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            return null;
          } : null)) : null,
          decoration: InputDecoration(
            border: enabled ? const OutlineInputBorder() : InputBorder.none,
            filled: !enabled,
            fillColor:
                enabled ? null : theme.colorScheme.surfaceContainerHighest,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: enabled ? null : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeField() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<ValueType>(
            value: _selectedType,
            onChanged: _isEditing ? (ValueType? newType) {
              if (newType != null) {
                setState(() {
                  _selectedType = newType;
                  _valueController.clear(); // Clear value when type changes
                });
              }
            } : null,
            decoration: InputDecoration(
              border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
              filled: !_isEditing,
              fillColor: _isEditing ? null : theme.colorScheme.surfaceContainerHighest,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: ValueType.values
                .where((type) => type != ValueType.VALUE_TYPE_UNSPECIFIED)
                .map((type) {
              final typeText =
                  type.toString().split('.').last.replaceAll('VALUE_TYPE_', '');
              return DropdownMenuItem<ValueType>(
                value: type,
                child: Text(typeText),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildValueField() {
    final theme = Theme.of(context);
    final isJsonType = _selectedType == ValueType.VALUE_TYPE_JSON;
    
    // Calculate lines for JSON content
    int maxLines = 1;
    if (isJsonType) {
      final lines = _valueController.text.split('\n').length;
      maxLines = (lines + 2).clamp(5, 25); // Min 5 lines, max 25 lines, add 2 for padding
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Value',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            if (isJsonType && _isEditing) ...[
              const Spacer(),
              TextButton.icon(
                onPressed: _beautifyJsonValue,
                icon: const Icon(Icons.auto_fix_high, size: 16),
                label: const Text('Beautify'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _valueController,
          enabled: _isEditing,
          maxLines: maxLines,
          keyboardType: _getKeyboardType(_selectedType),
          validator: _isEditing ? (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Value is required';
            }
            
            // Validate based on type
            final trimmedValue = value.trim();
            switch (_selectedType) {
              case ValueType.VALUE_TYPE_INT:
                try {
                  Int64.parseInt(trimmedValue);
                } catch (e) {
                  return 'Invalid integer value';
                }
                break;
              case ValueType.VALUE_TYPE_FLOAT:
                try {
                  double.parse(trimmedValue);
                } catch (e) {
                  return 'Invalid float value';
                }
                break;
              case ValueType.VALUE_TYPE_BOOL:
                final boolValue = trimmedValue.toLowerCase();
                if (boolValue != 'true' && boolValue != 'false') {
                  return 'Invalid boolean value (use true or false)';
                }
                break;
              case ValueType.VALUE_TYPE_JSON:
                if (_beautifyJson(trimmedValue) == null && trimmedValue.isNotEmpty) {
                  return 'Invalid JSON format';
                }
                break;
              default:
                break;
            }
            return null;
          } : null,
          decoration: InputDecoration(
            border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
            filled: !_isEditing,
            fillColor:
                _isEditing ? null : theme.colorScheme.surfaceContainerHighest,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            color: _isEditing ? null : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metadata',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRowWithCopy( label:'ID', value: widget.config.id.toString(), copy: true,),
              InfoRowWithCopy( label:'Entity ID', value: widget.config.entityId.toString(),copy: true,),
                InfoRowWithCopy( label:'Created', value: UtilityFunctions.formatDate(widget.config.createdAt)),
              InfoRowWithCopy( label:'Updated', value: UtilityFunctions.formatDate(widget.config.updatedAt)),
            ],
          ),
        ),
      ],
    );
  }

  TextInputType _getKeyboardType(ValueType type) {
    switch (type) {
      case ValueType.VALUE_TYPE_INT:
        return TextInputType.number;
      case ValueType.VALUE_TYPE_FLOAT:
        return const TextInputType.numberWithOptions(decimal: true);
      case ValueType.VALUE_TYPE_JSON:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  void _saveConfig() {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create update request
    final updateRequest = UpdateConfigRequest();
    updateRequest.id = widget.config.id;
    updateRequest.name = _keyController.text.trim();
    updateRequest.displayName = _displayNameController.text.trim();
    updateRequest.description = _descriptionController.text.trim();

    // Set value based on type
    final valueText = _valueController.text.trim();
    switch (_selectedType) {
      case ValueType.VALUE_TYPE_STRING:
        updateRequest.stringValue = valueText;
        break;
      case ValueType.VALUE_TYPE_INT:
        updateRequest.intValue = Int64.parseInt(valueText);
        break;
      case ValueType.VALUE_TYPE_FLOAT:
        updateRequest.floatValue = double.parse(valueText);
        break;
      case ValueType.VALUE_TYPE_BOOL:
        updateRequest.boolValue = valueText.toLowerCase() == 'true';
        break;
      case ValueType.VALUE_TYPE_JSON:
        updateRequest.jsonValue = valueText;
        break;
      default:
        break;
    }

    // Submit update
    final bloc = context.read<ConfigsBloc>();
    if (!bloc.isClosed) {
      bloc.add(updateRequest);
    }
  }

  String? _beautifyJson(String jsonString) {
    try {
      final dynamic jsonObject = jsonDecode(jsonString);
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonObject);
    } catch (e) {
      return null; // Return null if JSON is invalid
    }
  }

  void _beautifyJsonValue() {
    if (_selectedType == ValueType.VALUE_TYPE_JSON) {
      final currentValue = _valueController.text.trim();
      if (currentValue.isNotEmpty) {
        final beautified = _beautifyJson(currentValue);
        if (beautified != null) {
          setState(() {
            _valueController.text = beautified;
          });
        }
        // If JSON is invalid, the form validation will show the error
      }
    }
  }
}
