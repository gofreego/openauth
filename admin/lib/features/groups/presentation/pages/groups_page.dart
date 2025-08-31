import 'package:flutter/material.dart';
import '../../../../shared/widgets/coming_soon_page.dart';

class GroupsPage extends StatelessWidget {
  final VoidCallback? onBackToDashboard;

  const GroupsPage({
    super.key,
    this.onBackToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return ComingSoonPage(
      title: 'Groups',
      description: 'Organize users into groups and manage collective permissions',
      icon: Icons.group,
      onBackToDashboard: onBackToDashboard,
    );
  }
}
