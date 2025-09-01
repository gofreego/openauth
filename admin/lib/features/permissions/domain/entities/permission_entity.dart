import 'package:fixnum/fixnum.dart';
import '../../../../src/generated/openauth/v1/permissions.pb.dart' as pb;

/// Domain entity representing a permission
class PermissionEntity {
  final int id;
  final String name;
  final String displayName;
  final String description;
  final int createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PermissionEntity({
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create entity from protobuf permission
  factory PermissionEntity.fromProto(pb.Permission permission) {
    return PermissionEntity(
      id: permission.id.toInt(),
      name: permission.name,
      displayName: permission.displayName,
      description: permission.description,
      createdBy: permission.createdBy.toInt(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        permission.createdAt.toInt() * 1000,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        permission.updatedAt.toInt() * 1000,
      ),
    );
  }

  /// Convert entity to protobuf permission
  pb.Permission toProto() {
    return pb.Permission()
      ..id = Int64(id)
      ..name = name
      ..displayName = displayName
      ..description = description
      ..createdBy = Int64(createdBy)
      ..createdAt = Int64(createdAt.millisecondsSinceEpoch ~/ 1000)
      ..updatedAt = Int64(updatedAt.millisecondsSinceEpoch ~/ 1000);
  }

  PermissionEntity copyWith({
    int? id,
    String? name,
    String? displayName,
    String? description,
    int? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PermissionEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'PermissionEntity(id: $id, name: $name, displayName: $displayName, description: $description, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PermissionEntity &&
        other.id == id &&
        other.name == name &&
        other.displayName == displayName &&
        other.description == description &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        displayName.hashCode ^
        description.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
