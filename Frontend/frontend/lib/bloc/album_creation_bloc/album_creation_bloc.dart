import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:image_picker/image_picker.dart';

part 'album_creation_event.dart';
part 'album_creation_state.dart';

class AlbumCreationBloc extends Bloc<AlbumCreationEvent, AlbumCreationState> {
  AlbumRepository albumRepository;

  Uint8List image = Uint8List(0);

  AlbumCreationBloc({required this.albumRepository})
      : super(AlbumCreationInProgressState(image: Uint8List(0))) {
    on<AlbumCreationStarted>(_startAlbumCreation);
    on<ImageSelectionStarted>(_pickImage);
    on<RemoveImage>(_removeImage);
    on<AlbumCreationFinalized>(_createAlbum);
  }

  FutureOr<void> _pickImage(
      ImageSelectionStarted event, Emitter<AlbumCreationState> emit) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    final File imageFile = File(pickedImage!.path);
    final double imageSize = await imageFile.length() / 1024;
    if (imageSize > 750.0) {
      image = await compressFile(imageFile);
    } else {
      image = imageFile.readAsBytesSync();
    }
    emit(AlbumCreationInProgressState(image: image));
  }

  Future<Uint8List> compressFile(File file) async {
    final outPath = "${file.path}_out.jpg";

    // Compress the image file
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: 70, // Set compression quality (0 - 100)
    );

    return File(result!.path).readAsBytesSync();
  }

  FutureOr<void> _removeImage(
      RemoveImage event, Emitter<AlbumCreationState> emit) {
    image = Uint8List(0);
    emit(AlbumCreationInProgressState(image: image));
  }

  FutureOr<void> _createAlbum(
      AlbumCreationFinalized event, Emitter<AlbumCreationState> emit) async {
    int statusCode = await albumRepository.createAlbum(
        StorageService().userId, event.albumName, event.caption, [], image);
    print(statusCode);
    emit(AlbumCreationFinishedState());
  }

  FutureOr<void> _startAlbumCreation(
      AlbumCreationStarted event, Emitter<AlbumCreationState> emit) {
    emit(AlbumCreationInProgressState(image: image));
  }
}
