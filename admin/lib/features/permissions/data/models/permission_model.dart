import 'package:flutter/material.dart';

/// Enum for permission categories
enum PermissionCategory {
  userManagement('User Management', Icons.people, Colors.blue),
  system('System', Icons.settings, Colors.orange),
  content('Content', Icons.article, Colors.green),
  analytics('Analytics', Icons.analytics, Colors.purple);

  const PermissionCategory(this.displayName, this.icon, this.color);

  final String displayName;
  final IconData icon;
  final Color color;
}

/// Model representing a permission in the system
class PermissionModel {
  final String name;
  final String description;
  final PermissionCategory category;
  final int assignedUsers;

  const PermissionModel({
    required this.name,
    required this.description,
    required this.category,
    required this.assignedUsers,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: _categoryFromString(json['category'] ?? ''),
      assignedUsers: json['assignedUsers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category.displayName,
      'assignedUsers': assignedUsers,
    };
  }

  PermissionModel copyWith({
    String? name,
    String? description,
    PermissionCategory? category,
    int? assignedUsers,
  }) {
    return PermissionModel(
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      assignedUsers: assignedUsers ?? this.assignedUsers,
    );
  }

  static PermissionCategory _categoryFromString(String categoryString) {
    return PermissionCategory.values.firstWhere(
      (category) => category.displayName == categoryString,
      orElse: () => PermissionCategory.system,
    );
  }

  @override
  String toString() {
    return 'PermissionModel(name: $name, description: $description, category: $category, assignedUsers: $assignedUsers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PermissionModel &&
        other.name == name &&
        other.description == description &&
        other.category == category &&
        other.assignedUsers == assignedUsers;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        category.hashCode ^
        assignedUsers.hashCode;
  }

  // Mock data for demonstration
  static final List<PermissionModel> mockPermissions = [
    const PermissionModel(
      name: 'User Create',
      description: 'Ability to create new user accounts',
      category: PermissionCategory.userManagement,
      assignedUsers: 12,
    ),
    const PermissionModel(
      name: 'User Edit',
      description: 'Ability to edit existing user accounts',
      category: PermissionCategory.userManagement,
      assignedUsers: 8,
    ),
    const PermissionModel(
      name: 'User Delete',
      description: 'Ability to delete user accounts',
      category: PermissionCategory.userManagement,
      assignedUsers: 3,
    ),
    const PermissionModel(
      name: 'System Settings',
      description: 'Access to system configuration settings',
      category: PermissionCategory.system,
      assignedUsers: 5,
    ),
    const PermissionModel(
      name: 'View Analytics',
      description: 'Access to system analytics and reports',
      category: PermissionCategory.analytics,
      assignedUsers: 15,
    ),
    const PermissionModel(
      name: 'Export Data',
      description: 'Ability to export system data',
      category: PermissionCategory.analytics,
      assignedUsers: 7,
    ),
    const PermissionModel(
      name: 'Content Publish',
      description: 'Ability to publish content',
      category: PermissionCategory.content,
      assignedUsers: 10,
    ),
    const PermissionModel(
      name: 'Content Moderate',
      description: 'Ability to moderate user content',
      category: PermissionCategory.content,
      assignedUsers: 6,
    ),
    const PermissionModel(
      name: 'Backup Restore',
      description: 'Ability to create and restore backups',
      category: PermissionCategory.system,
      assignedUsers: 2,
    ),
  ];
}
