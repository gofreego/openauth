import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

/// User entity that wraps the generated protobuf User model
class UserEntity {
  final pb.User user;
  final pb.UserProfile? profile;

  const UserEntity({
    required this.user,
    this.profile,
  });

  // Convenience getters
  String get id => user.id.toString();
  String get uuid => user.uuid;
  String get username => user.username;
  String get email => user.email;
  String get phone => user.phone;
  bool get emailVerified => user.emailVerified;
  bool get phoneVerified => user.phoneVerified;
  bool get isActive => user.isActive;
  bool get isLocked => user.isLocked;
  int get failedLoginAttempts => user.failedLoginAttempts;
  DateTime? get lastLoginAt => user.hasLastLoginAt() 
      ? DateTime.fromMillisecondsSinceEpoch(user.lastLoginAt.toInt() * 1000) 
      : null;
  DateTime? get passwordChangedAt => user.hasPasswordChangedAt() 
      ? DateTime.fromMillisecondsSinceEpoch(user.passwordChangedAt.toInt() * 1000) 
      : null;
  DateTime? get createdAt => user.hasCreatedAt() 
      ? DateTime.fromMillisecondsSinceEpoch(user.createdAt.toInt() * 1000) 
      : null;
  DateTime? get updatedAt => user.hasUpdatedAt() 
      ? DateTime.fromMillisecondsSinceEpoch(user.updatedAt.toInt() * 1000) 
      : null;

  // Profile getters
  String get displayName => profile?.displayName ?? username;
  String get firstName => profile?.firstName ?? '';
  String get lastName => profile?.lastName ?? '';
  String get fullName => profile != null 
      ? '${profile!.firstName} ${profile!.lastName}'.trim()
      : username;
  String get avatarUrl => profile?.avatarUrl ?? '';

  String get status => isActive ? 'Active' : 'Inactive';

  String get lastLoginFormatted {
    if (lastLoginAt == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastLoginAt!);
    
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
    if (createdAt == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.user == user &&
        other.profile == profile;
  }

  @override
  int get hashCode => user.hashCode ^ profile.hashCode;

  @override
  String toString() {
    return 'UserEntity(user: $user, profile: $profile)';
  }
}