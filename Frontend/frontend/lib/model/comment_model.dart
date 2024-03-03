part of 'album_model.dart';

class Comment {
  String commentId;
  String userId;
  String username;
  String text;
  String userpfp;
  DateTime date;
  Comment(
      {required this.commentId,
      required this.userId,
      required this.userpfp,
      required this.username,
      required this.date,
      required this.text});
}
