import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/errors/failures.dart';

/// Utility class for showing toast messages that appear on top of all widgets
class ToastUtils {
  
  /// Show a success toast message
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Show an error toast message
  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.red,
      webBgColor: "#D22B2B",
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Show an info toast message
  static void showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Show a warning toast message
  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Show a custom toast message with custom colors
  static void showCustom({
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.TOP,
    Toast toastLength = Toast.LENGTH_SHORT,
    int timeInSecForIosWeb = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}

/// An error toast helper for showing errors as toast messages
class ErrorToast {
  static void show(Failure failure) {
    final message = _getErrorMessage(failure);
     ToastUtils.showError(message);
  }

  /// Get appropriate message based on failure type
  static String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return '🌐 ${failure.message}';
      case ServerFailure _:
        return '🔧 ${failure.message}';
      case CacheFailure _:
        return '💾 ${failure.message}';
      case ValidationFailure _:
        return '⚠️ ${failure.message}';
      case AuthenticationFailure _:
        return '🔒 ${failure.message}';
      case ServiceUnavailableFailure _:
        return '☁️ ${failure.message}';
      default:
        return '❌ ${failure.message}';
    }
  }
}

/// A copy toast helper for showing copy confirmations
class CopyToast {
  static void show(String itemName) {
    ToastUtils.showSuccess('📋 $itemName copied to clipboard');
  }
}
