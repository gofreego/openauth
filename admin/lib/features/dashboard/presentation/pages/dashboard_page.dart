import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/stats.pb.dart';
import '../widgets/stat_card.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _refreshTimer;
  Timer? _countdownTimer;
  bool _autoRefreshEnabled = true;
  int _refreshIntervalSeconds = 5;
  int _secondsUntilRefresh = 5;
  
  // Available refresh intervals in seconds
  final List<int> _refreshIntervals = [1, 5, 10, 30, 60];

  @override
  void initState() {
    super.initState();
    // Load stats when the page initializes
    _loadStats();
    // Start auto-refresh
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _loadStats() {
    context.read<DashboardBloc>().add(StatsRequest());
    // Reset countdown when manually refreshing
    if (_autoRefreshEnabled) {
      _secondsUntilRefresh = _refreshIntervalSeconds;
    }
  }

  void _loadStatsInBackground() {
    context.read<DashboardBloc>().add(BackgroundStatsRequest());
    // Reset countdown when auto-refreshing
    if (_autoRefreshEnabled) {
      _secondsUntilRefresh = _refreshIntervalSeconds;
    }
  }

  void _startAutoRefresh() {
    if (_autoRefreshEnabled) {
      _refreshTimer?.cancel();
      _countdownTimer?.cancel();
      
      _secondsUntilRefresh = _refreshIntervalSeconds;
      
      // Timer for actual refresh
      _refreshTimer = Timer.periodic(
        Duration(seconds: _refreshIntervalSeconds),
        (timer) {
          _loadStatsInBackground(); // Use background loading for auto-refresh
          _secondsUntilRefresh = _refreshIntervalSeconds;
        },
      );
      
      // Timer for countdown display
      _countdownTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          setState(() {
            _secondsUntilRefresh--;
            if (_secondsUntilRefresh <= 0) {
              _secondsUntilRefresh = _refreshIntervalSeconds;
            }
          });
        },
      );
    }
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    _refreshTimer = null;
    _countdownTimer = null;
  }

  void _toggleAutoRefresh() {
    setState(() {
      _autoRefreshEnabled = !_autoRefreshEnabled;
      if (_autoRefreshEnabled) {
        _startAutoRefresh();
      } else {
        _stopAutoRefresh();
      }
    });
  }

  void _updateRefreshInterval(int newInterval) {
    setState(() {
      _refreshIntervalSeconds = newInterval;
      if (_autoRefreshEnabled) {
        _startAutoRefresh(); // Restart with new interval
      }
    });
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
              // Auto-refresh controls
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  final isLoading = state is DashboardLoading && state.isInitialLoad;
                  
                  return Row(
                    children: [
                      // Loading indicator when refreshing (only for initial loads)
                      if (isLoading)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      // Auto-refresh toggle
                      IconButton(
                        onPressed: _toggleAutoRefresh,
                        icon: Icon(
                          _autoRefreshEnabled ? Icons.pause : Icons.play_arrow,
                          color: _autoRefreshEnabled ? Colors.green : Colors.grey,
                        ),
                        tooltip: _autoRefreshEnabled ? 'Pause auto-refresh' : 'Enable auto-refresh',
                      ),
                      const SizedBox(width: 8),
                      // Refresh interval dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _refreshIntervalSeconds,
                            isDense: true,
                            items: _refreshIntervals.map((int interval) {
                              return DropdownMenuItem<int>(
                                value: interval,
                                child: Text(
                                  interval == 1 ? '1 sec' : '$interval sec',
                                  style: theme.textTheme.bodySmall,
                                ),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                _updateRefreshInterval(newValue);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Manual refresh button
                      IconButton(
                        onPressed: isLoading ? null : _loadStats,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh Stats',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Overview of your OpenAuth system',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              // Auto-refresh status
              if (_autoRefreshEnabled)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 14,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Next refresh in ${_secondsUntilRefresh}s',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pause,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Auto-refresh paused',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Stats cards
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading && state.isInitialLoad) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (state is DashboardError) {
                return  
                
                Center(
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
                        onPressed: _loadStats,
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
              
              // Check if we should animate based on value changes
              final shouldAnimateUsers = state is DashboardLoaded && state.totalUsersChanged;
              final shouldAnimateActiveUsers = state is DashboardLoaded && state.activeUsersChanged;
              final shouldAnimatePermissions = state is DashboardLoaded && state.totalPermissionsChanged;
              final shouldAnimateGroups = state is DashboardLoaded && state.totalGroupsChanged;
              
              return Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Users',
                      value: stats?.totalUsers.toString() ?? '0',
                      icon: Icons.people,
                      color: Colors.blue,
                      shouldAnimate: shouldAnimateUsers,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Active Users',
                      value: stats?.activeUsers.toString() ?? '0',
                      icon: Icons.access_time,
                      color: Colors.green,
                      shouldAnimate: shouldAnimateActiveUsers,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Permissions',
                      value: stats?.totalPermissions.toString() ?? '0',
                      icon: Icons.security,
                      color: Colors.orange,
                      shouldAnimate: shouldAnimatePermissions,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Groups',
                      value: stats?.totalGroups.toString() ?? '0',
                      icon: Icons.group,
                      color: Colors.indigoAccent,
                      shouldAnimate: shouldAnimateGroups,
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
