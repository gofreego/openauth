import '../../../../src/generated/openauth/v1/users.pb.dart' as pb;

/// Utility functions for user-related operations
class UserUtils {
  /// Gets the display initials for a user, handling empty strings safely
  static String getInitials(pb.User user) {
    if (user.name.isNotEmpty) {
      return user.name[0].toUpperCase();
    } else if (user.username.isNotEmpty) {
      return user.username[0].toUpperCase();
    } else if (user.email.isNotEmpty) {
      return user.email[0].toUpperCase();
    } else {
      return '?'; // Fallback if all fields are empty
    }
  }

  /// Gets the display name for a user, with fallback options
  static String getDisplayName(pb.User user) {
    if (user.name.isNotEmpty) {
      return user.name;
    } else if (user.username.isNotEmpty) {
      return user.username;
    } else {
      return user.email;
    }
  }

  /// Formats user status for display
  static String getStatusText(pb.User user) {
    return user.isActive ? 'Active' : 'Inactive';
  }

  /// Gets appropriate status color
  static String getStatusColor(pb.User user) {
    return user.isActive ? 'success' : 'warning';
  }

  /// Validates if user has minimum required fields
  static bool isValidUser(pb.User user) {
    return user.username.isNotEmpty || user.email.isNotEmpty;
  }

  /// Gets safe user identifier (username or email)
  static String getUserIdentifier(pb.User user) {
    if (user.username.isNotEmpty) {
      return user.username;
    } else if (user.email.isNotEmpty) {
      return user.email;
    } else {
      return 'Unknown User';
    }
  }
}
