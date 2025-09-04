import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/shared/utils/toast_utils.dart';
import '../../../../src/generated/openauth/v1/users.pb.dart' as user_pb;
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as session_pb;
import '../bloc/sessions_bloc.dart';
import '../bloc/sessions_event.dart';
import '../bloc/sessions_state.dart';
import '../../domain/utils/session_utils.dart';
import 'session_row.dart';

class UserSessionsDialog extends StatefulWidget {
  final user_pb.User user;

  const UserSessionsDialog({
    super.key,
    required this.user,
  });

  @override
  State<UserSessionsDialog> createState() => _UserSessionsDialogState();
}

class _UserSessionsDialogState extends State<UserSessionsDialog> {
  @override
  void initState() {
    super.initState();
    // Load sessions when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionsBloc>().add(LoadUserSessionsEvent(widget.user.uuid));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary,
                  backgroundImage: widget.user.avatarUrl.isNotEmpty 
                      ? NetworkImage(widget.user.avatarUrl) 
                      : null,
                  child: widget.user.avatarUrl.isEmpty 
                      ? Text(
                          _getInitials(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sessions for ${widget.user.name}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${widget.user.username} • ${widget.user.email}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Actions
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  onPressed: () {
                    context.read<SessionsBloc>().add(
                      RefreshUserSessionsEvent(widget.user.uuid),
                    );
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('Terminate All'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () => _showTerminateAllDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Sessions content
            Expanded(
              child: BlocConsumer<SessionsBloc, SessionsState>(
                listener: (context, state) {
                  if (state is SessionTerminated) {
                    ToastUtils.showSuccess(state.message);
                    // Refresh the sessions list
                    context.read<SessionsBloc>().add(
                      RefreshUserSessionsEvent(widget.user.uuid),
                    );
                  } else if (state is AllSessionsTerminated) {
                    ToastUtils.showSuccess(state.message);
                    // Refresh the sessions list
                    context.read<SessionsBloc>().add(
                      RefreshUserSessionsEvent(widget.user.uuid),
                    );
                  } else if (state is SessionsError) {
                    ToastUtils.showError(state.message);
                  }
                },
                builder: (context, state) {
                  if (state is SessionsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SessionsLoaded) {
                    return _buildSessionsList(state.sessions);
                  } else if (state is SessionsError) {
                    return _buildErrorState(state.message);
                  }
                  
                  return const Center(
                    child: Text('Load sessions to get started'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsList(List<session_pb.Session> sessions) {
    if (sessions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No active sessions',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'This user has no active sessions.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Sort sessions by activity
    final sortedSessions = SessionUtils.sortSessionsByActivity(sessions);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Expanded(flex: 3, child: Text('Device', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text('Location', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text('Last Activity', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 100, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Sessions list
        Expanded(
          child: ListView.builder(
            itemCount: sortedSessions.length,
            itemBuilder: (context, index) {
              final session = sortedSessions[index];
              return SessionRow(
                session: session,
                index: index,
                onTerminate: () => _terminateSession(session.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading sessions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<SessionsBloc>().add(
                LoadUserSessionsEvent(widget.user.uuid),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _terminateSession(String sessionId) {
    context.read<SessionsBloc>().add(TerminateSessionEvent(sessionId));
  }

  void _showTerminateAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminate All Sessions'),
        content: Text(
          'Are you sure you want to terminate all sessions for ${widget.user.name}? '
          'This will log them out of all devices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SessionsBloc>().add(
                TerminateAllUserSessionsEvent(widget.user.uuid),
              );
            },
            child: const Text('Terminate All'),
          ),
        ],
      ),
    );
  }

  String _getInitials() {
    final name = widget.user.name;
    if (name.isEmpty) return widget.user.username.isNotEmpty ? widget.user.username[0].toUpperCase() : '?';
    
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
