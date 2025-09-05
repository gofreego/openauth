import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/users.pb.dart' as pb;
import '../../../../config/dependency_injection/service_locator.dart';
import '../../../profile/presentation/bloc/profiles_bloc.dart';
import '../../../profile/presentation/widgets/user_profiles_dialog.dart';

/// Widget that shows user profiles dialog by wrapping the profile feature's dialog
class UserProfilesDialogWrapper extends StatelessWidget {
  final pb.User user;

  const UserProfilesDialogWrapper({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProfilesBloc>(),
      child: UserProfilesDialog(user: user),
    );
  }
}
