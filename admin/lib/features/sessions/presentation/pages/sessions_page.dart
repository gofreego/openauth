import 'package:flutter/material.dart';
import '../../../../shared/widgets/coming_soon_page.dart';

class SessionsPage extends StatelessWidget {
  final VoidCallback? onBackToDashboard;

  const SessionsPage({
    super.key,
    this.onBackToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return ComingSoonPage(
      title: 'Sessions',
      description: 'Monitor and manage active user sessions across the system',
      icon: Icons.access_time,
      onBackToDashboard: onBackToDashboard,
    );
  }
}
