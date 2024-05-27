part of 'private-album_model.dart';

class Comment {
  String id;
  SimpleUser user;
  DateTime creationDate;
  String message;

  Comment({
    required this.id,
    required this.user,
    required this.creationDate,
    required this.message,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'].toString(),
        user: SimpleUser.fromMap(json['owner']),
        creationDate: DateTime.parse(json['dateWhenMade']),
        message: json['message'] as String);
  }
}
