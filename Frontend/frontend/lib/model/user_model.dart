import 'dart:convert';

class User {
  String userId;
  String username;
  String name;
  String bio;
  String pfpLink;
  String followersCount;
  String followingCount;

  User(
      {required this.userId,
      required this.username,
      required this.name,
      required this.bio,
      required this.pfpLink,
      required this.followersCount,
      required this.followingCount});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        userId: map["userId"],
        username: map["username"],
        name: map["name"],
        bio: map["bio"],
        pfpLink: map["pfpLink"],
        followersCount: "22",
        followingCount: "33");
  }

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
