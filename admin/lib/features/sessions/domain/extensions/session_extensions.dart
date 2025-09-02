import '../../../../src/generated/openauth/v1/sessions.pb.dart' as pb;

/// Extensions for the proto-generated Session class to provide convenience methods
extension SessionExtensions on pb.Session {
  // Convenience getters for better readability
  String get sessionIdString => id.toString();
  
  DateTime? get expiresAtDateTime => hasExpiresAt() 
      ? DateTime.fromMillisecondsSinceEpoch(expiresAt.toInt() * 1000) 
      : null;
      
  DateTime? get lastActivityAtDateTime => hasLastActivityAt() 
      ? DateTime.fromMillisecondsSinceEpoch(lastActivityAt.toInt() * 1000) 
      : null;
      
  DateTime? get createdAtDateTime => hasCreatedAt() 
      ? DateTime.fromMillisecondsSinceEpoch(createdAt.toInt() * 1000) 
      : null;

  String get status => isActive ? 'Active' : 'Expired';
  
  bool get isExpired {
    if (expiresAtDateTime == null) return false;
    return DateTime.now().isAfter(expiresAtDateTime!);
  }

  String get lastActivityFormatted {
    if (lastActivityAtDateTime == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(lastActivityAtDateTime!);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${difference.inDays ~/ 7} weeks ago';
    }
  }

  String get formattedCreatedAt {
    if (createdAtDateTime == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(createdAtDateTime!);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${difference.inDays ~/ 7} weeks ago';
    }
  }

  String get formattedExpiresAt {
    if (expiresAtDateTime == null) return 'Never';
    
    final now = DateTime.now();
    final difference = expiresAtDateTime!.difference(now);
    
    if (difference.isNegative) {
      return 'Expired';
    } else if (difference.inMinutes < 1) {
      return 'Expires soon';
    } else if (difference.inHours < 1) {
      return 'Expires in ${difference.inMinutes} minutes';
    } else if (difference.inDays < 1) {
      return 'Expires in ${difference.inHours} hours';
    } else if (difference.inDays < 7) {
      return 'Expires in ${difference.inDays} days';
    } else {
      return 'Expires in ${difference.inDays ~/ 7} weeks';
    }
  }

  String get deviceInfo {
    final parts = <String>[];
    if (deviceName.isNotEmpty) parts.add(deviceName);
    if (deviceType.isNotEmpty) parts.add(deviceType);
    return parts.isEmpty ? 'Unknown Device' : parts.join(' • ');
  }

  String get formattedLocation {
    return location.isEmpty ? 'Unknown Location' : location;
  }

  String get shortIpAddress {
    if (ipAddress.isEmpty) return 'Unknown IP';
    // Show only first and last parts of IP for privacy
    final parts = ipAddress.split('.');
    if (parts.length == 4) {
      return '${parts[0]}.*.*.${parts[3]}';
    }
    return ipAddress;
  }
}
