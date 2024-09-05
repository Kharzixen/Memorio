import 'dart:convert';

import 'package:frontend/service/storage_service.dart';

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
      pfpLink:
          "${StorageService.connectionString}/profile-images/${map["username"]}?dateTime=${DateTime.now().toIso8601String()}",
      followersCount: map["followersCount"].toString(),
      followingCount: map["followingCount"].toString(),
    );
  }

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SimpleUser {
  String userId;
  String username;
  String pfpLink;
  SimpleUser({
    required this.userId,
    required this.username,
    required this.pfpLink,
  });

  factory SimpleUser.fromMap(Map<String, dynamic> map) {
    return SimpleUser(
      userId: (map["userId"] as int).toString(),
      username: map["username"] as String,
      pfpLink:
          "${StorageService.connectionString}/profile-images/${map["username"]}?dateTime=${DateTime.now().toIso8601String()}",
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SimpleUser && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
