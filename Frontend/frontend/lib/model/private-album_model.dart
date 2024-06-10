import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/disposable_camera_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

part 'private_memory_model.dart';
part 'private_collection_model.dart';
part 'comment_model.dart';

class PrivateAlbumInfo {
  String albumId;
  String name;
  String albumPicture;
  String albumDescription;
  int nrOfContributors;
  DisposableCamera disposableCamera;
  SimpleUser owner;
  PrivateAlbumInfo({
    required this.albumId,
    required this.name,
    required this.nrOfContributors,
    required this.albumPicture,
    required this.albumDescription,
    required this.disposableCamera,
    required this.owner,
  });

  factory PrivateAlbumInfo.fromJson(Map<String, dynamic> json) {
    return PrivateAlbumInfo(
        albumId: json['id'].toString(),
        name: json['albumName'] as String,
        nrOfContributors: json['contributorCount'] as int,
        // contributors: (json['contributorsPreview'] as List<dynamic>)
        //     .map((user) => SimpleUser.fromMap(user as Map<String, dynamic>))
        //     .toList(),
        albumPicture: (json['albumImageLink'] as String).contains("https")
            ? json['albumImageLink']
            : "${StorageService.connectionString}/private-album-images/${json['albumImageLink']}",
        albumDescription: json['caption'] as String,
        disposableCamera: DisposableCamera.fromJson(json['disposableCamera']),
        owner: SimpleUser.fromMap(json['owner']));
  }
}

class SimplePrivateAlbum {
  String albumId;
  String albumName;
  String albumPicture;
  SimplePrivateAlbum(
      {required this.albumId,
      required this.albumName,
      required this.albumPicture});

  factory SimplePrivateAlbum.fromJson(Map<String, dynamic> json) {
    return SimplePrivateAlbum(
      albumId: json['id'].toString(),
      albumName: json['albumName'] as String,
      albumPicture: (json['albumImageLink'] as String).contains("https")
          ? json['albumImageLink']
          : "${StorageService.connectionString}/private-album-images/${json['albumImageLink']}",
    );
  }

  factory SimplePrivateAlbum.fromAlbumPreview(AlbumPreview albumPreview) {
    return SimplePrivateAlbum(
        albumId: albumPreview.albumId,
        albumName: albumPreview.name,
        albumPicture: albumPreview.albumPicture);
  }

  factory SimplePrivateAlbum.fromAlbumInfo(PrivateAlbumInfo albumPreview) {
    return SimplePrivateAlbum(
        albumId: albumPreview.albumId,
        albumName: albumPreview.name,
        albumPicture: albumPreview.albumPicture);
  }
  @override
  bool operator ==(Object other) {
    return (other is SimplePrivateAlbum) && other.albumId == albumId;
  }

  @override
  int get hashCode => super.hashCode;
}

class PrivateAlbumWithSelectedCollections {
  String albumId;
  String albumName;
  String albumPicture;
  List<SimplePrivateCollection> collections;
  PrivateAlbumWithSelectedCollections(
      {required this.albumId,
      required this.albumName,
      required this.albumPicture,
      required this.collections});
}

class SimplePrivateAlbumWithOwner {
  String albumId;
  String albumName;
  String albumPicture;
  SimpleUser owner;
  SimplePrivateAlbumWithOwner(
      {required this.albumId,
      required this.albumName,
      required this.owner,
      required this.albumPicture});

  factory SimplePrivateAlbumWithOwner.fromJson(Map<String, dynamic> json) {
    return SimplePrivateAlbumWithOwner(
      albumId: json['id'].toString(),
      albumName: json['albumName'] as String,
      owner: SimpleUser.fromMap(json['owner']),
      albumPicture: (json['albumImageLink'] as String).contains("https")
          ? json['albumImageLink']
          : "${StorageService.connectionString}/private-album-images/${json['albumImageLink']}",
    );
  }

  factory SimplePrivateAlbumWithOwner.fromAlbumInfo(
      PrivateAlbumInfo albumPreview) {
    return SimplePrivateAlbumWithOwner(
        albumId: albumPreview.albumId,
        albumName: albumPreview.name,
        owner: albumPreview.owner,
        albumPicture: albumPreview.albumPicture);
  }
  @override
  bool operator ==(Object other) {
    return (other is SimplePrivateAlbum) && other.albumId == albumId;
  }

  @override
  int get hashCode => super.hashCode;
}
