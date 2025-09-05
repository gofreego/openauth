import 'package:fixnum/fixnum.dart';



class UtilityFunctions {

  static String getInitials(String name) {
    final firstName = name.split(' ').first;
    final lastName = name.split(' ').last;

    if (firstName.isEmpty && lastName.isEmpty) {
      return 'UN';
    }

    String initials = '';
    if (firstName.isNotEmpty) {
      initials += firstName[0].toUpperCase();
    }
    if (lastName.isNotEmpty) {
      initials += lastName[0].toUpperCase();
    }
    return initials;
  }
  
  static String formatDate(Int64 millis) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis.toInt());
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String formatDateInWords(Int64 millis) {
    if (millis == 0) return 'Never';
    final date = DateTime.fromMillisecondsSinceEpoch(millis.toInt());
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
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

  static bool isUUID(String query) {
      return RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$').hasMatch(query);
  }

  static bool isNumber(String query) {
    return RegExp(r'^\d+$').hasMatch(query);
  }

  static bool isEmail(String query) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(query);
  }

  static bool isMobile(String query) {
    final mobileNumberRegex = RegExp(r'^(\+91[\-\s]?)?[6-9]\d{9}$');
    return mobileNumberRegex.hasMatch(query);
  }
}