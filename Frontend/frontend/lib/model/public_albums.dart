import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/public_memory.dart';
import 'package:frontend/service/storage_service.dart';

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
          : "${StorageService.connectionString}/private-album-images/${json['albumImageLink']}",
      caption: json['caption'] as String,
      previewImages: [],
    );
  }
}
