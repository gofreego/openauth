/// Model representing dashboard statistics
class DashboardStats {
  final int totalUsers;
  final int activeSessions;
  final int permissions;
  final int groups;
  final DateTime lastUpdated;

  const DashboardStats({
    required this.totalUsers,
    required this.activeSessions,
    required this.permissions,
    required this.groups,
    required this.lastUpdated,
  });

  factory DashboardStats.empty() {
    return DashboardStats(
      totalUsers: 0,
      activeSessions: 0,
      permissions: 0,
      groups: 0,
      lastUpdated: DateTime.now(),
    );
  }

  DashboardStats copyWith({
    int? totalUsers,
    int? activeSessions,
    int? permissions,
    int? groups,
    DateTime? lastUpdated,
  }) {
    return DashboardStats(
      totalUsers: totalUsers ?? this.totalUsers,
      activeSessions: activeSessions ?? this.activeSessions,
      permissions: permissions ?? this.permissions,
      groups: groups ?? this.groups,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'DashboardStats(totalUsers: $totalUsers, activeSessions: $activeSessions, permissions: $permissions, groups: $groups, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardStats &&
        other.totalUsers == totalUsers &&
        other.activeSessions == activeSessions &&
        other.permissions == permissions &&
        other.groups == groups &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return totalUsers.hashCode ^
        activeSessions.hashCode ^
        permissions.hashCode ^
        groups.hashCode ^
        lastUpdated.hashCode;
  }
}
