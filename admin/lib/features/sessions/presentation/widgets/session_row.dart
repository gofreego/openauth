import 'package:flutter/material.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;
import '../../../../config/dependency_injection/service_locator.dart';
import '../../../../shared/services/session_manager.dart';
import '../../domain/extensions/session_extensions.dart';
import '../../domain/utils/session_utils.dart';

class SessionRow extends StatefulWidget {
  final pb.Session session;
  final int index;
  final VoidCallback onTerminate;

  const SessionRow({
    super.key,
    required this.session,
    required this.index,
    required this.onTerminate,
  });

  @override
  State<SessionRow> createState() => _SessionRowState();
}

class _SessionRowState extends State<SessionRow> {
  String? _currentSessionId;

  @override
  void initState() {
    super.initState();
    _loadCurrentSessionId();
  }

  Future<void> _loadCurrentSessionId() async {
    try {
      final sessionManager = serviceLocator<SessionManager>();
      final sessionId = await sessionManager.getCurrentSessionId();
      if (mounted) {
        setState(() {
          _currentSessionId = sessionId;
        });
      }
    } catch (e) {
      // Handle error silently, fallback to heuristic method
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEven = widget.index % 2 == 0;
    final statusColor = SessionUtils.getStatusColor(widget.session);
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isEven ? null : theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Device info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  SessionUtils.getDeviceIconData(widget.session.deviceType),
                  size: 24,
                  color: statusColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.session.deviceInfo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.session.shortIpAddress,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Location
          Expanded(
            flex: 2,
            child: Text(
              widget.session.formattedLocation,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Last Activity
          Expanded(
            flex: 2,
            child: Text(
              widget.session.lastActivityFormatted,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Status
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.session.status,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.session.hasExpiresAt())
                        Text(
                          widget.session.formattedExpiresAt,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Actions
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (SessionUtils.isCurrentSession(widget.session, currentSessionId: _currentSessionId))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Current',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.logout_outlined, size: 20),
                    onPressed: widget.session.isActive ? widget.onTerminate : null,
                    tooltip: widget.session.isActive ? 'Terminate session' : 'Session already terminated',
                    color: Colors.red,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
