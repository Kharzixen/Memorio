import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

class Memory {
  String memoryId;
  String caption;
  DateTime date;
  String photo;

  SimpleUser uploader;

  Memory({
    required this.memoryId,
    required this.uploader,
    required this.date,
    required this.caption,
    required this.photo,
  });
}

class PublicMemory extends Memory {
  PublicMemory({
    required String memoryId,
    required SimpleUser uploader,
    required DateTime date,
    required String caption,
    required String photo,
  }) : super(
            memoryId: memoryId,
            uploader: uploader,
            date: date,
            caption: caption,
            photo: photo);

  factory PublicMemory.fromJson(Map<String, dynamic> json) {
    return PublicMemory(
        memoryId: json['id'].toString(),
        caption: json['caption'] as String,
        photo:
            "${StorageService.connectionString}/public-album-images/${json['imageId']}",
        date: DateTime.parse(json['creationDate']),
        uploader: SimpleUser.fromMap(json["uploader"]));
  }
}

class PrivateMemory extends Memory {
  PrivateMemory({
    required String memoryId,
    required SimpleUser uploader,
    required DateTime date,
    required String caption,
    required String photo,
  }) : super(
            memoryId: memoryId,
            uploader: uploader,
            date: date,
            caption: caption,
            photo: photo);

  factory PrivateMemory.fromJson(Map<String, dynamic> json) {
    return PrivateMemory(
        memoryId: json['id'].toString(),
        caption: json['caption'] as String,
        photo:
            "${StorageService.connectionString}/private-album-images/${json['imageId']}",
        date: DateTime.parse(json['creationDate']),
        uploader: SimpleUser.fromMap(json["uploader"]));
  }
}

class DetailedPublicMemory {
  String memoryId;
  String caption;
  DateTime date;
  String photo;
  SimpleUser uploader;
  int likeCount;
  SimplePublicAlbumWithOwner album;
  bool isHighlighted;

  DetailedPublicMemory(
      {required this.memoryId,
      required this.uploader,
      required this.date,
      required this.caption,
      required this.photo,
      required this.album,
      required this.isHighlighted,
      required this.likeCount});

  factory DetailedPublicMemory.fromJson(Map<String, dynamic> json) {
    return DetailedPublicMemory(
        memoryId: json['id'].toString(),
        caption: json['caption'] as String,
        likeCount: json['likeCount'] as int,
        album: SimplePublicAlbumWithOwner.fromJson(json['album']),
        isHighlighted: json['isHighlighted'] as bool,
        photo:
            "${StorageService.connectionString}/public-album-images/${json['imageId']}",
        date: DateTime.parse(json['creationDate']),
        uploader: SimpleUser.fromMap(json["uploader"]));
  }
}
