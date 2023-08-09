import 'user.dart';

class Thought {
  String text;
  User user;
  int likeCount;
  String date;

  Thought(
      {required this.text,
      required this.user,
      required this.likeCount,
      required this.date});
}
