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
      pfpLink: (map["pfpId"] as String).contains("https")
          ? map["pfpId"]
          : "${StorageService.connectionString}/images/${map["pfpId"]}",
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
      userId: (map["id"] as int).toString(),
      username: map["username"] as String,
      pfpLink: (map["pfpId"] as String).contains("https")
          ? map["pfpId"]
          : "${StorageService.connectionString}/images/${map["pfpId"]}",
    );
  }
}
