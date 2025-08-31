import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user
class AuthUser extends Equatable {
  final String id;
  final String uuid;
  final String username;
  final String email;
  final String? phone;
  final bool emailVerified;
  final bool phoneVerified;
  final bool isActive;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AuthUser({
    required this.id,
    required this.uuid,
    required this.username,
    required this.email,
    this.phone,
    required this.emailVerified,
    required this.phoneVerified,
    required this.isActive,
    this.firstName,
    this.lastName,
    this.displayName,
    this.avatarUrl,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return displayName ?? username;
  }

  @override
  List<Object?> get props => [
        id,
        uuid,
        username,
        email,
        phone,
        emailVerified,
        phoneVerified,
        isActive,
        firstName,
        lastName,
        displayName,
        avatarUrl,
        lastLoginAt,
        createdAt,
        updatedAt,
      ];
}
