import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/data/repository/public_memory_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/memory_creation_details.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

part 'public_memory_creation_state.dart';

class PublicMemoryCreationCubit extends Cubit<MemoryCreationState> {
  late Uint8List image;
  int width = 0;
  int height = 0;
  int page = 0;

  String description = "";
  late SimplePublicAlbum album;

  late PublicMemoryCreationDetails _memoryCreationDetails;

  final PublicMemoryRepository publicMemoryRepository;

  PublicMemoryCreationCubit(this.publicMemoryRepository)
      : super(MemoryCreationInitialState());

  Future loadAndDecodePhoto(
      PublicMemoryCreationDetails memoryCreationDetails) async {
    emit(MemoryCreationLoadingState());
    _memoryCreationDetails = memoryCreationDetails;
    album = _memoryCreationDetails.album;

    final pickedImage =
        await ImagePicker().pickImage(source: memoryCreationDetails.source);

    if (pickedImage == null) {
      emit(MemoryCreationNoImageSelectedState());
      return;
    }
    File imageFile = File(pickedImage.path);

    double imageSize = await imageFile.length() / 1024;
    double prevImageSize = 0;

    if (imageSize > 650) {
      while (imageSize > 650) {
        imageFile = await compressFile(imageFile);
        prevImageSize = imageSize;
        imageSize = await imageFile.length() / 1024;
        if (prevImageSize != 0 && prevImageSize - imageSize < 10.0) {
          break;
        }
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
          publicAlbum: album),
    );
  }

  FutureOr<void> saveDescription(String description) {
    this.description = description;
    emit(
      MemoryCreationLoadedState(
          image: image,
          width: width,
          height: height,
          description: description,
          page: page,
          publicAlbum: album),
    );
  }

  Future<FutureOr<void>> saveCreation() async {
    try {
      PublicMemory savedMemory = await publicMemoryRepository.createMemory(
          StorageService().userId, album.albumId, description, image);
      emit(MemoryCreationFinishedState(savedMemory));
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

  void saveImage(event, emit) async {
    await Gal.putImageBytes(image,
        album: "Memorio", name: "IMG_${DateTime.now()}.jpg");
  }
}
