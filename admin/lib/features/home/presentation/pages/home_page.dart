import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/app_bloc.dart';
import '../../../../core/bloc/app_state.dart';
import '../widgets/admin_sidebar.dart';
import '../../../dashboard/dashboard.dart';
import 'users_page.dart';
import 'permissions_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initialSection});

  final String? initialSection;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NavigationSection _currentSection = NavigationSection.dashboard;

  @override
  void initState() {
    super.initState();
    // Set initial section if provided
    if (widget.initialSection != null) {
      switch (widget.initialSection) {
        case 'users':
          _currentSection = NavigationSection.users;
          break;
        case 'permissions':
          _currentSection = NavigationSection.permissions;
          break;
        case 'groups':
          _currentSection = NavigationSection.groups;
          break;
        case 'sessions':
          _currentSection = NavigationSection.sessions;
          break;
        case 'settings':
          _currentSection = NavigationSection.settings;
          break;
        case 'profile':
          _currentSection = NavigationSection.profile;
          break;
        default:
          _currentSection = NavigationSection.dashboard;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        return Scaffold(
          body: Row(
            children: [
              // Sidebar
              AdminSidebar(
                currentSection: _currentSection,
                onSectionChanged: (section) {
                  setState(() {
                    _currentSection = section;
                  });
                },
              ),
              
              // Vertical divider
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              
              // Main content area
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    switch (_currentSection) {
      case NavigationSection.dashboard:
        return const DashboardPage();
      case NavigationSection.users:
        return const UsersPage();
      case NavigationSection.permissions:
        return const PermissionsPage();
      case NavigationSection.groups:
        return _buildComingSoonPage('Groups', Icons.group);
      case NavigationSection.sessions:
        return _buildComingSoonPage('Sessions', Icons.access_time);
      case NavigationSection.settings:
        return _buildComingSoonPage('Settings', Icons.settings);
      case NavigationSection.profile:
        return const ProfilePage();
    }
  }

  Widget _buildComingSoonPage(String title, IconData icon) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Coming soon content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$title Management',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This feature is coming soon!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentSection = NavigationSection.dashboard;
                      });
                    },
                    icon: const Icon(Icons.dashboard),
                    label: const Text('Back to Dashboard'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
