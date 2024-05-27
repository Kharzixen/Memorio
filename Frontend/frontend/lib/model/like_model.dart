import 'package:frontend/model/user_model.dart';

class LikeModel {
  SimpleUser user;
  DateTime creationDate;

  LikeModel({
    required this.user,
    required this.creationDate,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
        user: SimpleUser.fromMap(json['user']),
        creationDate: DateTime.parse(json['likedDate'] as String));
  }
}
