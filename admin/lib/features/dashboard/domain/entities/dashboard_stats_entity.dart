import '../../../../../../src/generated/openauth/v1/stats.pb.dart' as pb;

/// Entity representing dashboard statistics
class DashboardStatsEntity {
  final int totalUsers;
  final int totalPermissions;
  final int totalGroups;
  final int activeUsers;
  final DateTime lastUpdated;

  const DashboardStatsEntity({
    required this.totalUsers,
    required this.totalPermissions,
    required this.totalGroups,
    required this.activeUsers,
    required this.lastUpdated,
  });

  factory DashboardStatsEntity.fromProto(pb.StatsResponse statsResponse) {
    return DashboardStatsEntity(
      totalUsers: statsResponse.totalUsers.toInt(),
      totalPermissions: statsResponse.totalPermissions.toInt(),
      totalGroups: statsResponse.totalGroups.toInt(),
      activeUsers: statsResponse.activeUsers.toInt(),
      lastUpdated: DateTime.now(),
    );
  }

  factory DashboardStatsEntity.empty() {
    return DashboardStatsEntity(
      totalUsers: 0,
      totalPermissions: 0,
      totalGroups: 0,
      activeUsers: 0,
      lastUpdated: DateTime.now(),
    );
  }

  DashboardStatsEntity copyWith({
    int? totalUsers,
    int? totalPermissions,
    int? totalGroups,
    int? activeUsers,
    DateTime? lastUpdated,
  }) {
    return DashboardStatsEntity(
      totalUsers: totalUsers ?? this.totalUsers,
      totalPermissions: totalPermissions ?? this.totalPermissions,
      totalGroups: totalGroups ?? this.totalGroups,
      activeUsers: activeUsers ?? this.activeUsers,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'DashboardStatsEntity(totalUsers: $totalUsers, totalPermissions: $totalPermissions, totalGroups: $totalGroups, activeUsers: $activeUsers, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardStatsEntity &&
        other.totalUsers == totalUsers &&
        other.totalPermissions == totalPermissions &&
        other.totalGroups == totalGroups &&
        other.activeUsers == activeUsers &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return totalUsers.hashCode ^
        totalPermissions.hashCode ^
        totalGroups.hashCode ^
        activeUsers.hashCode ^
        lastUpdated.hashCode;
  }
}
