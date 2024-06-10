import 'dart:core';

import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:image_picker/image_picker.dart';

class MemoryCreationDetails {
  final ImageSource source;
  final SimplePrivateAlbum? album;
  final SimplePrivateCollection? collection;

  MemoryCreationDetails({
    required this.source,
    this.album,
    this.collection,
  });
}

class PublicMemoryCreationDetails {
  final ImageSource source;
  final SimplePublicAlbum album;

  PublicMemoryCreationDetails({
    required this.source,
    required this.album,
  });
}
