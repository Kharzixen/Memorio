class User {
  final String id;
  final String username;
  final bool isAdmin;
  final bool isActive;

  User(
      {required this.id,
      required this.username,
      required this.isAdmin,
      required this.isActive});

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'] as String,
      isAdmin: json['isAdmin'] == null ? false : json['isAdmin'] as bool,
      isActive: json['isActive'] == null ? true : json['isActive'] as bool,
    );
  }
}
