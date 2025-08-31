class BreadcrumbItem {
  final String id;
  final String name;

  const BreadcrumbItem({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreadcrumbItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'BreadcrumbItem(id: $id, name: $name)';
}
