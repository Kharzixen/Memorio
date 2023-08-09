import 'package:flutter/material.dart';

import 'user.dart';

class Post {
  String caption;
  User user;
  int likeCount;
  String date;
  NetworkImage img;

  Post(
      {required this.caption,
      required this.user,
      required this.likeCount,
      required this.date,
      required this.img});
}
