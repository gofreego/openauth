import 'package:flutter/material.dart';
import '../../../../shared/widgets/coming_soon_page.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback? onBackToDashboard;

  const SettingsPage({
    super.key,
    this.onBackToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return ComingSoonPage(
      title: 'Settings',
      description: 'Configure system settings, security policies, and preferences',
      icon: Icons.settings,
      onBackToDashboard: onBackToDashboard,
    );
  }
}
