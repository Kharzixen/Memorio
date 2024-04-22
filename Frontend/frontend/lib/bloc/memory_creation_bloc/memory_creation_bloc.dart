import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/memory_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_creation_details.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

part 'memory_creation_event.dart';
part 'memory_creation_state.dart';

class MemoryCreationBloc
    extends Bloc<MemoryCreationEvent, MemoryCreationState> {
  late Uint8List image;
  int width = 0;
  int height = 0;
  int page = 0;
  Map<String, AlbumWithSelectedCollections> albums = {};

  String description = "";

  late MemoryCreationDetails _memoryCreationDetails;

  MemoryRepository memoryRepository;
  MemoryCreationBloc(this.memoryRepository)
      : super(MemoryCreationInitialState()) {
    on<MemoryCreationStarted>(_loadAndDecodePhoto);
    on<CollectionSelected>(_addCollectionToAlbum);
    on<CollectionUnselected>(_removeCollectionFromAlbum);
    on<AlbumSelected>(_addAlbumToAlbums);
    on<AlbumUnselected>(_removeAlbumFromAlbums);
    on<DescriptionSaved>(_saveDescription);
    on<MemoryCreationFinished>(_saveCreation);
  }

  Future _loadAndDecodePhoto(
      MemoryCreationStarted event, Emitter<MemoryCreationState> emit) async {
    emit(MemoryCreationLoadingState());
    _memoryCreationDetails = event.memoryCreationDetails;
    final album = _memoryCreationDetails.album;
    if (album != null) {
      albums[album.albumId] = AlbumWithSelectedCollections(
        albumId: album.albumId,
        albumName: album.albumName,
        albumPicture: album.albumPicture,
        collections: [],
      );
      final collection = event.memoryCreationDetails.collection;
      if (collection != null) {
        albums[album.albumId]!.collections.add(collection);
      }
    }

    final pickedImage = await ImagePicker()
        .pickImage(source: event.memoryCreationDetails.source);

    if (pickedImage == null) {
      emit(MemoryCreationNoImageSelectedState());
    }
    File imageFile = File(pickedImage!.path);
    double imageSize = await imageFile.length() / 1024;

    if (imageSize > 650) {
      while (imageSize > 650) {
        imageFile = await compressFile(imageFile);
        imageSize = await imageFile.length() / 1024;
      }
      image = imageFile.readAsBytesSync();
    } else {
      image = imageFile.readAsBytesSync();
    }

    emit(
      MemoryCreationLoadedState(
          image: image,
          width: width,
          height: height,
          description: description,
          page: page,
          albums: albums),
    );
  }

  void _addCollectionToAlbum(
      CollectionSelected event, Emitter<MemoryCreationState> emit) {
    String albumId = event.albumId;
    albums[albumId]!.collections.add(event.collection);
    emit(
      MemoryCreationLoadedState(
          image: image,
          width: width,
          height: height,
          description: description,
          page: page,
          albums: albums),
    );
  }

  FutureOr<void> _removeCollectionFromAlbum(
      CollectionUnselected event, Emitter<MemoryCreationState> emit) {
    String albumId = event.albumId;
    albums[albumId]!.collections.remove(event.collection);
    emit(
      MemoryCreationLoadedState(
          image: image,
          width: width,
          height: height,
          description: description,
          page: page,
          albums: albums),
    );
  }

  FutureOr<void> _addAlbumToAlbums(
      AlbumSelected event, Emitter<MemoryCreationState> emit) {
    String albumId = event.albumId;
    albums[albumId] = AlbumWithSelectedCollections(
        albumId: event.album.albumId,
        albumName: event.album.albumName,
        albumPicture: event.album.albumPicture,
        collections: []);
    emit(
      MemoryCreationLoadedState(
          image: image,
          width: width,
          height: height,
          description: description,
          page: page,
          albums: albums),
    );
  }

  FutureOr<void> _removeAlbumFromAlbums(
      AlbumUnselected event, Emitter<MemoryCreationState> emit) {
    String albumId = event.albumId;
    albums.remove(albumId);
    emit(
      MemoryCreationLoadedState(
          image: image,
          width: width,
          height: height,
          description: description,
          page: page,
          albums: albums),
    );
  }

  FutureOr<void> _saveDescription(
      DescriptionSaved event, Emitter<MemoryCreationState> emit) {
    description = event.description;
    emit(
      MemoryCreationLoadedState(
          image: image,
          width: width,
          height: height,
          description: description,
          page: page,
          albums: albums),
    );
  }

  Future<FutureOr<void>> _saveCreation(
      MemoryCreationFinished event, Emitter<MemoryCreationState> emit) async {
    try {
      Memory? createdMemory;
      for (AlbumWithSelectedCollections album in albums.values) {
        Memory currentSavedMemory = await memoryRepository.createMemory(
            StorageService().userId,
            album.albumId,
            description,
            album.collections.map((e) => e.collectionId).toList(),
            image);
        if (_memoryCreationDetails.album != null) {
          if (album.albumId == _memoryCreationDetails.album!.albumId) {
            createdMemory = currentSavedMemory;
          }
        } else {
          createdMemory ??= currentSavedMemory;
        }
      }
      emit(MemoryCreationFinishedState(createdMemory!));
    } catch (ex) {
      emit(MemoryCreationErrorState(ex.toString()));
    }
  }

  //--------------------------------------------------------------------------------------------

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    final outPath = "${filePath}_out.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 50,
    );

    return File(result!.path);
  }
}
