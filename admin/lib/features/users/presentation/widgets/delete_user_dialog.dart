import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/users/presentation/bloc/users_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';

class DeleteUserDialog extends StatelessWidget {
  const DeleteUserDialog({super.key, required this.user});

  final User user;

  static void show(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => DeleteUserDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete User'),
      content: Text('Are you sure you want to delete ${user.name}? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            final bloc = context.read<UsersBloc>();
            if (!bloc.isClosed) {
              bloc.add(DeleteUserRequest(uuid:user.uuid));
            }
            ToastUtils.showSuccess('${user.name} deleted successfully');
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