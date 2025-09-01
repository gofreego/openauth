import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/stat_card.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load stats when the page initializes
    context.read<DashboardBloc>().add(const LoadStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
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
                Icons.dashboard,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Dashboard',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Refresh button
              IconButton(
                onPressed: () {
                  context.read<DashboardBloc>().add(const RefreshStatsEvent());
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Stats',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Overview of your OpenAuth system',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Stats cards
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (state is DashboardError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading stats',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DashboardBloc>().add(const RefreshStatsEvent());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              // Default to showing stats (either loaded or initial values)
              final stats = state is DashboardLoaded 
                  ? state.stats 
                  : null;
              
              return Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Users',
                      value: stats?.totalUsers.toString() ?? '0',
                      icon: Icons.people,
                      color: Colors.blue,
                      onTap: () {
                        // TODO: Navigate to users page
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Active Users',
                      value: stats?.activeUsers.toString() ?? '0',
                      icon: Icons.access_time,
                      color: Colors.green,
                      onTap: () {
                        // TODO: Navigate to sessions page
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Permissions',
                      value: stats?.totalPermissions.toString() ?? '0',
                      icon: Icons.security,
                      color: Colors.orange,
                      onTap: () {
                        // TODO: Navigate to permissions page
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Groups',
                      value: stats?.totalGroups.toString() ?? '0',
                      icon: Icons.group,
                      color: Colors.purple,
                      onTap: () {
                        // TODO: Navigate to groups page
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
