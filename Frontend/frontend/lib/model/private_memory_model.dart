part of 'private-album_model.dart';

class PrivateMemory {
  String memoryId;
  String caption;
  DateTime date;
  String photo;

  SimpleUser uploader;

  PrivateMemory({
    required this.memoryId,
    required this.uploader,
    required this.date,
    required this.caption,
    required this.photo,
  });

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

class DetailedPrivateMemory {
  String memoryId;
  SimpleUser uploader;
  DateTime date;
  String photo;
  String caption;
  int likeCount;
  int commentsCount;
  int collectionsCount;
  List<SimplePrivateCollection> collections;
  SimplePrivateAlbumWithOwner album;

  DetailedPrivateMemory({
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

  factory DetailedPrivateMemory.fromJson(Map<String, dynamic> json) {
    return DetailedPrivateMemory(
        memoryId: json['id'].toString(),
        uploader: SimpleUser.fromMap(json["uploader"]),
        caption: json['caption'] as String,
        likeCount: json['likeCount'] as int,
        album: SimplePrivateAlbumWithOwner.fromJson(json['album']),
        commentsCount: 0,
        collectionsCount: 2,
        collections: [],
        // collections: (json['collections'] as List<dynamic>)
        //     .map((collection) =>
        //         SimpleCollection.fromJson(collection as Map<String, dynamic>))
        //     .toList(),
        date: DateTime.parse(json['creationDate']),
        photo:
            "${StorageService.connectionString}/private-album-images/${json['imageId']}");
  }
}

class PrivateCollectionMemory {
  PrivateMemory memory;
  DateTime addedToCollectionDate;
  PrivateCollectionMemory(
      {required this.memory, required this.addedToCollectionDate});

  factory PrivateCollectionMemory.fromJson(Map<String, dynamic> json) {
    return PrivateCollectionMemory(
      memory: PrivateMemory.fromJson(json['memory']),
      addedToCollectionDate: DateTime.parse(json['addedDate']),
    );
  }
}
