import 'dart:core';

import 'package:frontend/model/album_model.dart';
import 'package:image_picker/image_picker.dart';

class MemoryCreationDetails {
  final ImageSource source;
  final SimpleAlbum? album;
  final SimpleCollection? collection;

  MemoryCreationDetails({
    required this.source,
    this.album,
    this.collection,
  });
}
