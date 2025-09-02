import 'package:flutter/material.dart';
import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

class SessionUtils {
  static String getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'mobile':
      case 'phone':
      case 'android':
      case 'ios':
        return '📱';
      case 'tablet':
      case 'ipad':
        return '📱';
      case 'desktop':
      case 'computer':
      case 'pc':
      case 'mac':
        return '💻';
      case 'web':
      case 'browser':
        return '🌐';
      default:
        return '📱';
    }
  }

  static IconData getDeviceIconData(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'mobile':
      case 'phone':
      case 'android':
      case 'ios':
        return Icons.smartphone;
      case 'tablet':
      case 'ipad':
        return Icons.tablet;
      case 'desktop':
      case 'computer':
      case 'pc':
      case 'mac':
        return Icons.computer;
      case 'web':
      case 'browser':
        return Icons.web;
      default:
        return Icons.device_unknown;
    }
  }

  static Color getStatusColor(pb.Session session) {
    if (!session.isActive) return Colors.red;
    
    final expiresAt = session.hasExpiresAt() 
        ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt.toInt() * 1000)
        : null;
    
    if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
      return Colors.orange; // Expired but still marked as active
    }
    
    return Colors.green; // Active and not expired
  }

  static String getFormattedDuration(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  static bool isCurrentSession(pb.Session session) {
    // This would typically be determined by comparing with current session ID
    // For now, we'll check if it's the most recent active session
    return session.isActive && session.hasLastActivityAt();
  }

  static List<pb.Session> sortSessionsByActivity(List<pb.Session> sessions) {
    return sessions..sort((a, b) {
      // Sort by active status first, then by last activity
      if (a.isActive && !b.isActive) return -1;
      if (!a.isActive && b.isActive) return 1;
      
      if (a.hasLastActivityAt() && b.hasLastActivityAt()) {
        return b.lastActivityAt.compareTo(a.lastActivityAt);
      } else if (a.hasLastActivityAt()) {
        return -1;
      } else if (b.hasLastActivityAt()) {
        return 1;
      }
      
      return 0;
    });
  }

  static List<pb.Session> filterActiveSessions(List<pb.Session> sessions) {
    return sessions.where((session) => session.isActive).toList();
  }

  static List<pb.Session> filterExpiredSessions(List<pb.Session> sessions) {
    return sessions.where((session) {
      if (!session.hasExpiresAt()) return false;
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(session.expiresAt.toInt() * 1000);
      return DateTime.now().isAfter(expiresAt);
    }).toList();
  }
}
