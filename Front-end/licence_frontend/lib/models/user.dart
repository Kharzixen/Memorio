import 'package:flutter/material.dart';

class User {
  String username;
  NetworkImage pfp;
  int allLikesCount;
  int postsCount;
  int followersCount;
  User(
      {required this.username,
      required this.pfp,
      required this.allLikesCount,
      required this.followersCount,
      required this.postsCount});
}

class ProfileUser extends User {
  String email;
  ProfileUser(
      {required super.username,
      required super.pfp,
      required super.allLikesCount,
      required super.followersCount,
      required super.postsCount,
      required this.email});
}
