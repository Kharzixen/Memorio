import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

class Post {
  String postId;
  String caption;
  DateTime creationDate;
  String imageLink;
  SimpleUser owner;

  Post(
      {required this.postId,
      required this.caption,
      required this.creationDate,
      required this.imageLink,
      required this.owner});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        postId: json['id'].toString(),
        owner: SimpleUser.fromMap(json["owner"]),
        caption: json['caption'] as String,
        creationDate: DateTime.parse(json['creationDate']),
        imageLink:
            "${StorageService.connectionString}/post-images/${json['imageId']}");
  }
}
