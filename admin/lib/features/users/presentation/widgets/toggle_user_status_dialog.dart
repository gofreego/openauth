import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/users/presentation/bloc/users_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart';

class ToggleUserStatusDialog extends StatelessWidget {
  const ToggleUserStatusDialog({super.key, required this.user});

  final User user;

  static void show(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => ToggleUserStatusDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
     final newStatus = !user.isActive;
    final action = newStatus ? 'activate' : 'deactivate';
    final capitalizedAction = action[0].toUpperCase() + action.substring(1);
    return AlertDialog(
        title: Text('$capitalizedAction User'),
        content: Text('Are you sure you want to $action ? ${user.name} will${action == 'activate'?'':' not'} be able to log in!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              final bloc = context.read<UsersBloc>();
              if (!bloc.isClosed) {
                bloc.add(UpdateUserRequest(
                  uuid: user.uuid,
                  isActive: newStatus,
                ));
              }
              ToastUtils.showSuccess('${user.name} ${action}d successfully');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange),
              foregroundColor: Colors.orange,
            ),
            child: Text(capitalizedAction),
          ),
        ],
      );
  }
}