import 'package:frontend/model/memory_model.dart';

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
