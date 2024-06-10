import 'package:frontend/model/disposable_camera_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

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
}

class PublicAlbumPreview extends AlbumPreview {
  PublicAlbumPreview({
    required String albumId,
    required String name,
    required String caption,
    required String albumPicture,
    required List<Memory> previewImages,
  }) : super(
            albumId: albumId,
            name: name,
            caption: caption,
            albumPicture: albumPicture,
            previewImages: previewImages);

  factory PublicAlbumPreview.fromJson(Map<String, dynamic> json) {
    return PublicAlbumPreview(
      albumId: json['id'].toString(),
      name: json['albumName'] as String,
      albumPicture: (json['albumImageLink'] as String).contains("https")
          ? json['albumImageLink']
          : "${StorageService.connectionString}/public-album-images/${json['albumImageLink']}",
      caption: json['caption'] as String,
      previewImages: [],
    );
  }
}

class SimplePublicAlbum {
  String albumId;
  String albumName;
  String albumPfpLink;
  SimplePublicAlbum(this.albumId, this.albumName, this.albumPfpLink);

  static fromAlbumPreview(AlbumPreview albumPreview) {
    return SimplePublicAlbum(
        albumPreview.albumId, albumPreview.name, albumPreview.albumPicture);
  }
}

class PrivateAlbumPreview extends AlbumPreview {
  DisposableCamera disposableCamera;

  PrivateAlbumPreview(
      {required String albumId,
      required String name,
      required String caption,
      required String albumPicture,
      required List<Memory> previewImages,
      required this.disposableCamera})
      : super(
            albumId: albumId,
            name: name,
            caption: caption,
            albumPicture: albumPicture,
            previewImages: previewImages);

  factory PrivateAlbumPreview.fromJson(Map<String, dynamic> json) {
    return PrivateAlbumPreview(
      albumId: json['id'].toString(),
      name: json['albumName'] as String,
      albumPicture: (json['albumImageLink'] as String).contains("https")
          ? json['albumImageLink']
          : "${StorageService.connectionString}/private-album-images/${json['albumImageLink']}",
      caption: json['caption'] as String,
      disposableCamera: DisposableCamera.fromJson(json['disposableCamera']),
      previewImages: [],
    );
  }
}

class SimplePublicAlbumWithOwner {
  String id;
  String name;
  String imageLink;
  SimpleUser owner;
  SimplePublicAlbumWithOwner(
      {required this.id,
      required this.name,
      required this.imageLink,
      required this.owner});

  factory SimplePublicAlbumWithOwner.fromJson(Map<String, dynamic> json) {
    return SimplePublicAlbumWithOwner(
        id: json['id'].toString(),
        name: json['albumName'] as String,
        imageLink: (json['albumImageLink'] as String).contains("https")
            ? json['albumImageLink']
            : "${StorageService.connectionString}/public-album-images/${json['albumImageLink']}",
        owner: SimpleUser.fromMap(json['owner']));
  }
}

class PublicAlbumInfo {
  String albumId;
  String name;
  String albumPicture;
  String albumDescription;
  int nrOfContributors;
  SimpleUser owner;
  PublicAlbumInfo({
    required this.albumId,
    required this.name,
    required this.nrOfContributors,
    required this.albumPicture,
    required this.albumDescription,
    required this.owner,
  });

  factory PublicAlbumInfo.fromJson(Map<String, dynamic> json) {
    return PublicAlbumInfo(
        albumId: json['id'].toString(),
        name: json['albumName'] as String,
        nrOfContributors: json['contributorCount'] as int,
        // contributors: (json['contributorsPreview'] as List<dynamic>)
        //     .map((user) => SimpleUser.fromMap(user as Map<String, dynamic>))
        //     .toList(),
        albumPicture: (json['albumImageLink'] as String).contains("https")
            ? json['albumImageLink']
            : "${StorageService.connectionString}/public-album-images/${json['albumImageLink']}",
        albumDescription: json['caption'] as String,
        owner: SimpleUser.fromMap(json['owner']));
  }
}
