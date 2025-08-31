import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/services/session_manager.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

/// Widget that displays authentication and session security information
class AuthSessionInfo extends StatefulWidget {
  const AuthSessionInfo({super.key});

  @override
  State<AuthSessionInfo> createState() => _AuthSessionInfoState();
}

class _AuthSessionInfoState extends State<AuthSessionInfo> {
  Map<String, String>? _sessionMetadata;
  Map<String, String>? _deviceSession;
  SessionSecurityStatus? _securityStatus;
  List<Map<String, dynamic>>? _loginHistory;

  @override
  void initState() {
    super.initState();
    _loadSessionInfo();
  }

  Future<void> _loadSessionInfo() async {
    try {
      final sessionManager = SessionManager(
        await SharedPreferences.getInstance(),
      );
      
      final metadata = await sessionManager.getSessionMetadata();
      final device = await sessionManager.getDeviceSession();
      final security = await sessionManager.validateSessionSecurity();
      final history = await sessionManager.getLoginHistory();

      if (mounted) {
        setState(() {
          _sessionMetadata = metadata;
          _deviceSession = device;
          _securityStatus = security;
          _loginHistory = history;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildSessionStatus(context),
                const SizedBox(height: 16),
                _buildDeviceInfo(context),
                if (_loginHistory?.isNotEmpty == true) ...[
                  const SizedBox(height: 16),
                  _buildLoginHistory(context),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.security,
          color: _getSecurityColor(context),
        ),
        const SizedBox(width: 8),
        Text(
          'Session Security',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        _buildSecurityBadge(context),
      ],
    );
  }

  Widget _buildSecurityBadge(BuildContext context) {
    final theme = Theme.of(context);
    final status = _securityStatus;
    
    Color badgeColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case SessionSecurityStatus.valid:
        badgeColor = theme.colorScheme.primary;
        statusText = 'Secure';
        statusIcon = Icons.verified;
        break;
      case SessionSecurityStatus.expired:
        badgeColor = theme.colorScheme.error;
        statusText = 'Expired';
        statusIcon = Icons.timer_off;
        break;
      case SessionSecurityStatus.suspicious:
        badgeColor = Colors.orange;
        statusText = 'Suspicious';
        statusIcon = Icons.warning;
        break;
      case SessionSecurityStatus.invalid:
      case null:
        badgeColor = theme.colorScheme.error;
        statusText = 'Invalid';
        statusIcon = Icons.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 12, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStatus(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = _sessionMetadata;

    if (metadata == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Information',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Login Method', metadata['identifier'] ?? 'Unknown'),
        _buildInfoRow('Login Time', _formatDateTime(metadata['loginTime'])),
        _buildInfoRow('Remember Me', metadata['rememberMe'] == 'true' ? 'Yes' : 'No'),
        if (metadata['lastRefresh'] != null)
          _buildInfoRow('Last Refresh', _formatDateTime(metadata['lastRefresh'])),
        _buildInfoRow('Refresh Count', metadata['refreshCount'] ?? '0'),
      ],
    );
  }

  Widget _buildDeviceInfo(BuildContext context) {
    final theme = Theme.of(context);
    final device = _deviceSession;

    if (device == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Information',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Device Type', device['deviceType'] ?? 'Unknown'),
        _buildInfoRow('Device Name', device['deviceName'] ?? 'Unknown'),
        _buildInfoRow('IP Address', device['ipAddress'] ?? 'Unknown'),
        _buildInfoRow('Location', device['location'] ?? 'Unknown'),
        _buildInfoRow('Security Level', device['securityLevel'] ?? 'Unknown'),
      ],
    );
  }

  Widget _buildLoginHistory(BuildContext context) {
    final theme = Theme.of(context);
    final history = _loginHistory!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Login History',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...history.take(3).map((entry) => _buildHistoryEntry(context, entry)),
        if (history.length > 3)
          TextButton(
            onPressed: () => _showFullHistory(context),
            child: const Text('View all login history'),
          ),
      ],
    );
  }

  Widget _buildHistoryEntry(BuildContext context, Map<String, dynamic> entry) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            _getDeviceIcon(entry['deviceType']),
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${entry['deviceName']} • ${_formatDateTime(entry['timestamp'])}',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Unknown',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSecurityColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (_securityStatus) {
      case SessionSecurityStatus.valid:
        return theme.colorScheme.primary;
      case SessionSecurityStatus.expired:
        return theme.colorScheme.error;
      case SessionSecurityStatus.suspicious:
        return Colors.orange;
      case SessionSecurityStatus.invalid:
      case null:
        return theme.colorScheme.error;
    }
  }

  IconData _getDeviceIcon(String? deviceType) {
    switch (deviceType?.toLowerCase()) {
      case 'android':
        return Icons.android;
      case 'ios':
        return Icons.phone_iphone;
      case 'web':
        return Icons.web;
      case 'windows':
        return Icons.computer;
      case 'macos':
        return Icons.laptop_mac;
      case 'linux':
        return Icons.computer;
      default:
        return Icons.device_unknown;
    }
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return 'Unknown';
    
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void _showFullHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login History'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _loginHistory?.length ?? 0,
            itemBuilder: (context, index) {
              final entry = _loginHistory![index];
              return ListTile(
                leading: Icon(_getDeviceIcon(entry['deviceType'])),
                title: Text(entry['deviceName'] ?? 'Unknown Device'),
                subtitle: Text(_formatDateTime(entry['timestamp'])),
                trailing: Text(entry['ipAddress'] ?? ''),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
