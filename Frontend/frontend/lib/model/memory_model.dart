part of 'album_model.dart';

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

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
        memoryId: json['id'].toString(),
        caption: json['caption'] as String,
        photo: "${StorageService.connectionString}/images/${json['imageLink']}",
        date: DateTime.parse(json['creationDate']),
        uploader: SimpleUser.fromMap(json["uploader"]));
  }
}

class DetailedMemory {
  String memoryId;
  SimpleUser uploader;
  DateTime date;
  String photo;
  String caption;
  int likeCount;
  int commentsCount;
  int collectionsCount;
  List<SimpleCollection> collections;
  SimpleAlbum album;

  DetailedMemory({
    required this.memoryId,
    required this.uploader,
    required this.caption,
    required this.likeCount,
    required this.commentsCount,
    required this.collectionsCount,
    required this.collections,
    required this.date,
    required this.album,
    required this.photo,
  });

  factory DetailedMemory.fromJson(Map<String, dynamic> json) {
    return DetailedMemory(
        memoryId: json['id'].toString(),
        uploader: SimpleUser.fromMap(json["uploader"]),
        caption: json['caption'] as String,
        likeCount: 0,
        album: SimpleAlbum.fromJson(json['album']),
        commentsCount: 0,
        collectionsCount: 2,
        collections: (json['collections'] as List<dynamic>)
            .map((collection) =>
                SimpleCollection.fromJson(collection as Map<String, dynamic>))
            .toList(),
        date: DateTime.parse(json['creationDate']),
        photo:
            "${StorageService.connectionString}/images/${json['imageLink']}");
  }
}
