import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/configs.pb.dart';
import '../../../../shared/shared.dart';
import '../bloc/config_entities_bloc.dart';

class DeleteConfigEntityDialog extends StatelessWidget {
  const DeleteConfigEntityDialog({super.key, required this.entity});

  final ConfigEntity entity;

  static void show(BuildContext context, ConfigEntity entity) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfigEntityDialog(entity: entity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Config Entity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to delete the config entity "${entity.name}"?'),
          const SizedBox(height: 8),
          const Text(
            'This action cannot be undone and may affect related configurations.',
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
            Navigator.of(context).pop();
            final bloc = context.read<ConfigEntitiesBloc>();
            if (!bloc.isClosed) {
              bloc.add(DeleteConfigEntityRequest(id: entity.id));
            }
            ToastUtils.showSuccess('Config entity "${entity.name}" deleted successfully');
          },
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
