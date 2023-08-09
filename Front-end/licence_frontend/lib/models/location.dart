import 'package:flutter/material.dart';

class NightlifeLocation {
  String name;
  String bio;
  NetworkImage pfp;

  int allLikesCount;
  int postsCount;
  int followersCount;

  NightlifeLocation(
      {required this.name,
      required this.bio,
      required this.pfp,
      required this.allLikesCount,
      required this.followersCount,
      required this.postsCount});
}
