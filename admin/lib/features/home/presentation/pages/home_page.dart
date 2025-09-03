import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/app_bloc.dart';
import '../../../../core/bloc/app_state.dart';
import '../widgets/admin_sidebar.dart';
import '../../../dashboard/dashboard.dart';
import '../../../users/users.dart';
import '../../../permissions/permissions.dart';
import '../../../groups/groups.dart';
import '../../../sessions/sessions.dart';
import '../../../settings/settings.dart';
import '../../../profile/profile.dart';

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
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
        return const PermissionsPageWrapper();
      case NavigationSection.groups:
        return GroupsPage(
          onBackToDashboard: () {
            setState(() {
              _currentSection = NavigationSection.dashboard;
            });
          },
        );
      case NavigationSection.sessions:
        return SessionsPage(
          onBackToDashboard: () {
            setState(() {
              _currentSection = NavigationSection.dashboard;
            });
          },
        );
      case NavigationSection.settings:
        return SettingsPage(
          onBackToDashboard: () {
            setState(() {
              _currentSection = NavigationSection.dashboard;
            });
          },
        );
      case NavigationSection.profile:
        return const ProfilePage();
    }
  }
}
