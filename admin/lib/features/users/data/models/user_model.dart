/// Model representing a user in the system
class UserModel {
  final String name;
  final String username;
  final String email;
  final bool isActive;
  final String lastLogin;

  const UserModel({
    required this.name,
    required this.username,
    required this.email,
    required this.isActive,
    required this.lastLogin,
  });

  String get status => isActive ? 'Active' : 'Inactive';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? false,
      lastLogin: json['lastLogin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'isActive': isActive,
      'lastLogin': lastLogin,
    };
  }

  UserModel copyWith({
    String? name,
    String? username,
    String? email,
    bool? isActive,
    String? lastLogin,
  }) {
    return UserModel(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, username: $username, email: $email, isActive: $isActive, lastLogin: $lastLogin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.name == name &&
        other.username == username &&
        other.email == email &&
        other.isActive == isActive &&
        other.lastLogin == lastLogin;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        isActive.hashCode ^
        lastLogin.hashCode;
  }

  // Mock data for demonstration
  static final List<UserModel> mockUsers = [
    const UserModel(
      name: 'John Doe',
      username: 'johndoe',
      email: 'john.doe@example.com',
      isActive: true,
      lastLogin: '2 hours ago',
    ),
    const UserModel(
      name: 'Jane Smith',
      username: 'janesmith',
      email: 'jane.smith@example.com',
      isActive: true,
      lastLogin: '1 day ago',
    ),
    const UserModel(
      name: 'Bob Johnson',
      username: 'bobjohnson',
      email: 'bob.johnson@example.com',
      isActive: false,
      lastLogin: '1 week ago',
    ),
    const UserModel(
      name: 'Alice Wilson',
      username: 'alicewilson',
      email: 'alice.wilson@example.com',
      isActive: true,
      lastLogin: '5 minutes ago',
    ),
    const UserModel(
      name: 'Charlie Brown',
      username: 'charliebrown',
      email: 'charlie.brown@example.com',
      isActive: true,
      lastLogin: '3 days ago',
    ),
  ];
}
