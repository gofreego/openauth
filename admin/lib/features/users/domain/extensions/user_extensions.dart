import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

/// Extensions for the proto-generated User class to provide convenience methods
extension UserExtensions on pb.User {
  // Convenience getters for better readability
  String get userIdString => id.toString();
  
  DateTime? get lastLoginAtDateTime => hasLastLoginAt() 
      ? DateTime.fromMillisecondsSinceEpoch(lastLoginAt.toInt() * 1000) 
      : null;
      
  DateTime? get passwordChangedAtDateTime => hasPasswordChangedAt() 
      ? DateTime.fromMillisecondsSinceEpoch(passwordChangedAt.toInt() * 1000) 
      : null;
      
  DateTime? get createdAtDateTime => hasCreatedAt() 
      ? DateTime.fromMillisecondsSinceEpoch(createdAt.toInt() * 1000) 
      : null;
      
  DateTime? get updatedAtDateTime => hasUpdatedAt() 
      ? DateTime.fromMillisecondsSinceEpoch(updatedAt.toInt() * 1000) 
      : null;

  String get displayName => name.isEmpty ? username : name;
  
  String get status => isActive ? 'Active' : 'Inactive';

  String get lastLoginFormatted {
    if (lastLoginAtDateTime == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastLoginAtDateTime!);
    
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
    
    if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays ~/ 7} weeks ago';
    } else if (difference.inDays < 365) {
      return '${difference.inDays ~/ 30} months ago';
    } else {
      return '${difference.inDays ~/ 365} years ago';
    }
  }
}

/// Extensions for UserProfile to provide convenience methods
extension UserProfileExtensions on pb.UserProfile {
  String get fullName => '$firstName $lastName'.trim();
  
  DateTime? get createdAtDateTime => hasCreatedAt() 
      ? DateTime.fromMillisecondsSinceEpoch(createdAt.toInt() * 1000) 
      : null;
      
  DateTime? get updatedAtDateTime => hasUpdatedAt() 
      ? DateTime.fromMillisecondsSinceEpoch(updatedAt.toInt() * 1000) 
      : null;
}
