part of 'album_model.dart';

class Moment {
  String entryId;
  String userId;
  String username;
  DateTime date;
  String photo;

  Moment({
    required this.entryId,
    required this.userId,
    required this.username,
    required this.date,
    required this.photo,
  });
}

class DetailedMoment {
  String entryId;
  String userId;
  String username;
  DateTime date;
  String photo;
  String caption;
  int likeCount;
  List<LikeModel> likes;
  int commentsCount;
  List<Comment> comments;

  DetailedMoment({
    required this.entryId,
    required this.userId,
    required this.caption,
    required this.likeCount,
    required this.likes,
    required this.username,
    required this.commentsCount,
    required this.comments,
    required this.date,
    required this.photo,
  });
}

class LikeModel {
  String userId;
  String username;
  //temporary
  String userpfp;

  LikeModel({
    required this.userId,
    required this.username,
    required this.userpfp,
  });
}
