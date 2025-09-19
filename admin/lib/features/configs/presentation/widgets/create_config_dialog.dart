import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/configs.pb.dart';
import '../../../../shared/shared.dart';
import '../bloc/configs_bloc.dart';
import '../bloc/configs_state.dart';

class CreateConfigDialog extends StatefulWidget {
  final int entityId;
  final VoidCallback? onConfigCreated;

  const CreateConfigDialog({
    super.key,
    required this.entityId,
    this.onConfigCreated,
  });

  static void show(BuildContext context, int entityId, {VoidCallback? onConfigCreated}) {
    showDialog(
      context: context,
      builder: (context) => CreateConfigDialog(
        entityId: entityId,
        onConfigCreated: onConfigCreated,
      ),
    );
  }

  @override
  State<CreateConfigDialog> createState() => _CreateConfigDialogState();
}

class _CreateConfigDialogState extends State<CreateConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  
  ValueType _selectedType = ValueType.VALUE_TYPE_STRING;
  bool _boolValue = false;

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
    return BlocListener<ConfigsBloc, ConfigsState>(
      listener: (context, state) {
        if (state is ConfigCreated) {
          Navigator.of(context).pop();
          widget.onConfigCreated?.call();
          ToastUtils.showSuccess('Config created successfully');
        } else if (state is ConfigCreateError) {
          ToastUtils.showError('Error: ${state.message}');
        }
      },
      child: AlertDialog(
        title: const Text('Create New Config'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _keyController,
                    decoration: const InputDecoration(
                      labelText: 'Key *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.key),
                      helperText: 'Unique identifier for this config',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Key is required';
                      }
                      if (value.contains(' ')) {
                        return 'Key cannot contain spaces';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outline),
                      helperText: 'Human-readable name for this config',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description_outlined),
                      helperText: 'Optional description of this config',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ValueType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Value Type *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: ValueType.VALUE_TYPE_STRING,
                        child: Text('String'),
                      ),
                      DropdownMenuItem(
                        value: ValueType.VALUE_TYPE_INT,
                        child: Text('Integer'),
                      ),
                      DropdownMenuItem(
                        value: ValueType.VALUE_TYPE_FLOAT,
                        child: Text('Float'),
                      ),
                      DropdownMenuItem(
                        value: ValueType.VALUE_TYPE_BOOL,
                        child: Text('Boolean'),
                      ),
                      DropdownMenuItem(
                        value: ValueType.VALUE_TYPE_JSON,
                        child: Text('JSON'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                        _valueController.clear();
                        _boolValue = false;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildValueInput(),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          BlocBuilder<ConfigsBloc, ConfigsState>(
            builder: (context, state) {
              final isLoading = state is ConfigsLoading;

              return FilledButton(
                onPressed: isLoading ? null : _createConfig,
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Config'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildValueInput() {
    switch (_selectedType) {
      case ValueType.VALUE_TYPE_BOOL:
        return CheckboxListTile(
          title: const Text('Value'),
          subtitle: Text(_boolValue ? 'True' : 'False'),
          value: _boolValue,
          onChanged: (value) {
            setState(() {
              _boolValue = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        );
      
      case ValueType.VALUE_TYPE_INT:
        return TextFormField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'Value *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.numbers),
            helperText: 'Enter an integer value',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Value is required';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid integer';
            }
            return null;
          },
        );
      
      case ValueType.VALUE_TYPE_FLOAT:
        return TextFormField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'Value *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.pin),
            helperText: 'Enter a decimal value',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Value is required';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid decimal number';
            }
            return null;
          },
        );
      
      case ValueType.VALUE_TYPE_JSON:
        return TextFormField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'JSON Value *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.code),
            helperText: 'Enter valid JSON',
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'JSON value is required';
            }
            // Basic JSON validation - could be enhanced
            try {
              // This is a simple check - in a real app you might want more robust validation
              if (!value.trim().startsWith('{') && !value.trim().startsWith('[')) {
                return 'Please enter valid JSON (start with { or [)';
              }
            } catch (e) {
              return 'Please enter valid JSON';
            }
            return null;
          },
        );
      
      default: // STRING
        return TextFormField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'Value *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.text_fields),
            helperText: 'Enter a text value',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Value is required';
            }
            return null;
          },
        );
    }
  }

  void _createConfig() {
    if (_formKey.currentState!.validate()) {
      final request = CreateConfigRequest(
        entityId: Int64(widget.entityId),
        key: _keyController.text.trim(),
        displayName: _displayNameController.text.trim().isEmpty 
            ? null 
            : _displayNameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        type: _selectedType,
      );

      // Set the value based on type
      switch (_selectedType) {
        case ValueType.VALUE_TYPE_STRING:
          request.stringValue = _valueController.text.trim();
          break;
        case ValueType.VALUE_TYPE_INT:
          request.intValue = Int64(int.parse(_valueController.text.trim()));
          break;
        case ValueType.VALUE_TYPE_FLOAT:
          request.floatValue = double.parse(_valueController.text.trim());
          break;
        case ValueType.VALUE_TYPE_BOOL:
          request.boolValue = _boolValue;
          break;
        case ValueType.VALUE_TYPE_JSON:
          request.jsonValue = _valueController.text.trim();
          break;
        default:
          break;
      }

      context.read<ConfigsBloc>().add(request);
    }
  }
}