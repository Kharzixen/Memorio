import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/data/repository/post_repository.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/model/utils/post_creation_details.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository postRepository;

  Uint8List image = Uint8List(0);
  String caption = "";

  bool savedToGallery = false;

  CreatePostCubit(this.postRepository) : super(CreatePostInitialState());

  void pickImage(PostCreationDetails details) async {
    emit(PostCreationLoadingState());
    final pickedImage = await ImagePicker().pickImage(source: details.source);
    File imageFile = File(pickedImage!.path);
    double imageSize = await imageFile.length() / 1024;
    double prevImageSize = 0;
    if (imageSize > 650) {
      while (imageSize > 650) {
        imageFile = await _compressFile(imageFile);
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
    emit(PostCreationInProgressState(
        image: image,
        caption: caption,
        saveInProgress: false,
        savedToGallery: savedToGallery));
  }

  Future<File> _compressFile(File file) async {
    final filePath = file.absolute.path;

    final outPath = "${filePath}_out.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 50,
    );

    return File(result!.path);
  }

  void removeImage() {
    image = Uint8List(0);
    emit(PostCreationInProgressState(
        image: image,
        caption: caption,
        saveInProgress: false,
        savedToGallery: savedToGallery));
  }

  void setDescription(String caption) {
    this.caption = caption;
    emit(PostCreationInProgressState(
        image: image,
        caption: caption,
        saveInProgress: false,
        savedToGallery: savedToGallery));
  }

  void createPost() async {
    try {
      Post post = await postRepository.createPost(
          StorageService().userId, image, caption);
      emit(PostCreationFinishedState(post: post));
    } catch (e) {
      emit(PostCreationErrorState(message: e.toString()));
    }
  }

  void saveImage() async {
    if (!savedToGallery) {
      emit(PostCreationInProgressState(
          image: image,
          caption: caption,
          saveInProgress: true,
          savedToGallery: savedToGallery));
      await Gal.putImageBytes(image,
          album: "Memorio", name: "IMG_${DateTime.now()}.jpg");
      savedToGallery = true;
      emit(PostCreationInProgressState(
          image: image,
          caption: caption,
          saveInProgress: false,
          savedToGallery: savedToGallery));
    }
  }
}
