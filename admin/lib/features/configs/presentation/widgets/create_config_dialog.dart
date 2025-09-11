import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/configs.pb.dart';
import '../bloc/configs_bloc.dart';

class CreateConfigDialog extends StatefulWidget {
  final List<ConfigEntity> entities;
  
  const CreateConfigDialog({
    super.key,
    required this.entities,
  });

  @override
  State<CreateConfigDialog> createState() => _CreateConfigDialogState();
}

class _CreateConfigDialogState extends State<CreateConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  
  ConfigEntity? _selectedEntity;
  String _selectedType = 'STRING';
  
  final List<String> _types = [
    'STRING',
    'INTEGER',
    'FLOAT',
    'BOOLEAN',
    'JSON',
  ];

  @override
  void dispose() {
    _keyController.dispose();
    _displayNameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedEntity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a config entity')),
        );
        return;
      }

      final request = CreateConfigRequest(
        entityId: _selectedEntity!.id,
        key: _keyController.text,
        displayName: _displayNameController.text.isEmpty ? null : _displayNameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        type: _selectedType,
      );

      // Set the appropriate value based on type
      switch (_selectedType) {
        case 'STRING':
          request.stringValue = _valueController.text;
          break;
        case 'INTEGER':
          final intValue = int.tryParse(_valueController.text);
          if (intValue != null) {
            request.intValue = Int64(intValue);
          }
          break;
        case 'FLOAT':
          final floatValue = double.tryParse(_valueController.text);
          if (floatValue != null) {
            request.floatValue = floatValue;
          }
          break;
        case 'BOOLEAN':
          request.boolValue = _valueController.text.toLowerCase() == 'true';
          break;
        case 'JSON':
          request.jsonValue = _valueController.text;
          break;
      }

      context.read<ConfigsBloc>().add(request);
      Navigator.of(context).pop();
    }
  }

  String? _validateValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }

    switch (_selectedType) {
      case 'INTEGER':
        if (int.tryParse(value) == null) {
          return 'Please enter a valid integer';
        }
        break;
      case 'FLOAT':
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        break;
      case 'BOOLEAN':
        if (value.toLowerCase() != 'true' && value.toLowerCase() != 'false') {
          return 'Please enter true or false';
        }
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Config'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ConfigEntity>(
                value: _selectedEntity,
                decoration: const InputDecoration(
                  labelText: 'Config Entity *',
                  border: OutlineInputBorder(),
                ),
                items: widget.entities.map((ConfigEntity entity) {
                  return DropdownMenuItem<ConfigEntity>(
                    value: entity,
                    child: Text(entity.displayName.isNotEmpty ? entity.displayName : entity.name),
                  );
                }).toList(),
                onChanged: (ConfigEntity? newValue) {
                  setState(() {
                    _selectedEntity = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a config entity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keyController,
                decoration: const InputDecoration(
                  labelText: 'Key *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a key';
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
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type *',
                  border: OutlineInputBorder(),
                ),
                items: _types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedType = newValue;
                      _valueController.clear(); // Clear value when type changes
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: 'Value *',
                  border: const OutlineInputBorder(),
                  helperText: _getValueHelperText(),
                ),
                validator: _validateValue,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Create'),
        ),
      ],
    );
  }

  String _getValueHelperText() {
    switch (_selectedType) {
      case 'INTEGER':
        return 'Enter an integer number';
      case 'FLOAT':
        return 'Enter a decimal number';
      case 'BOOLEAN':
        return 'Enter true or false';
      case 'JSON':
        return 'Enter valid JSON';
      default:
        return 'Enter a text value';
    }
  }
}
