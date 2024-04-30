import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

part 'memory_model.dart';
part 'collection_model.dart';
part 'comment_model.dart';

class AlbumInfo {
  String albumId;
  String name;
  String albumPicture;
  String albumDescription;
  int nrOfContributors;
  SimpleUser owner;
  AlbumInfo({
    required this.albumId,
    required this.name,
    required this.nrOfContributors,
    required this.albumPicture,
    required this.albumDescription,
    required this.owner,
  });

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
        albumId: json['id'].toString(),
        name: json['albumName'] as String,
        nrOfContributors: json['contributorCount'] as int,
        // contributors: (json['contributorsPreview'] as List<dynamic>)
        //     .map((user) => SimpleUser.fromMap(user as Map<String, dynamic>))
        //     .toList(),
        albumPicture: (json['albumImageLink'] as String).contains("https")
            ? json['albumImageLink']
            : "${StorageService.connectionString}/images/${json['albumImageLink']}",
        albumDescription: json['caption'] as String,
        owner: SimpleUser.fromMap(json['owner']));
  }
}

class AlbumPreview {
  String albumId;
  String name;
  String albumPicture;
  String caption;
  List<Memory> previewImages;

  AlbumPreview({
    required this.albumId,
    required this.name,
    required this.caption,
    required this.albumPicture,
    required this.previewImages,
  });

  factory AlbumPreview.fromJson(Map<String, dynamic> json) {
    return AlbumPreview(
      albumId: json['id'].toString(),
      name: json['albumName'] as String,
      albumPicture: (json['albumImageLink'] as String).contains("https")
          ? json['albumImageLink']
          : "${StorageService.connectionString}/images/${json['albumImageLink']}",
      caption: json['caption'] as String,
      previewImages: [],
    );
  }
}

class SimpleAlbum {
  String albumId;
  String albumName;
  String albumPicture;
  SimpleAlbum(
      {required this.albumId,
      required this.albumName,
      required this.albumPicture});

  factory SimpleAlbum.fromJson(Map<String, dynamic> json) {
    return SimpleAlbum(
      albumId: json['id'].toString(),
      albumName: json['albumName'] as String,
      albumPicture: (json['albumImageLink'] as String).contains("https")
          ? json['albumImageLink']
          : "${StorageService.connectionString}/images/${json['albumImageLink']}",
    );
  }

  factory SimpleAlbum.fromAlbumPreview(AlbumPreview albumPreview) {
    return SimpleAlbum(
        albumId: albumPreview.albumId,
        albumName: albumPreview.name,
        albumPicture: albumPreview.albumPicture);
  }
  @override
  bool operator ==(Object other) {
    return (other is SimpleAlbum) && other.albumId == albumId;
  }

  @override
  int get hashCode => super.hashCode;
}

class AlbumWithSelectedCollections {
  String albumId;
  String albumName;
  String albumPicture;
  List<SimpleCollection> collections;
  AlbumWithSelectedCollections(
      {required this.albumId,
      required this.albumName,
      required this.albumPicture,
      required this.collections});
}
