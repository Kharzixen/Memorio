import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  UserRepository userRepository;
  EditProfileCubit(this.userRepository) : super(EditProfileInitialState());

  late User user;
  late Uint8List image = Uint8List(0);
  late String newBio;

  loadEditProfile(String userId) async {
    try {
      user = await userRepository.getUser(userId);
      newBio = user.bio;
      emit(EditProfileLoadedState(user, image, newBio));
    } catch (e) {
      emit(EditProfileErrorState(e.toString()));
    }
  }

  void updateProfile(String newBio) async {
    this.newBio = newBio;
    try {
      if (user.bio == this.newBio) {
        user =
            await userRepository.changeProfileOfUser(user.userId, image, null);
      } else {
        user = await userRepository.changeProfileOfUser(
            user.userId, image, this.newBio);
      }

      emit(EditProfileSuccessState(user));
    } catch (e) {
      emit(EditProfileErrorState(e.toString()));
    }
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

  void loadNewImage(ImageSource source, String newBio) async {
    try {
      this.newBio = newBio;
      final pickedImage = await ImagePicker().pickImage(source: source);
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
      emit(EditProfileLoadedState(user, image, newBio));
    } catch (e) {
      emit(EditProfileErrorState(e.toString()));
    }
  }

  void removeImage(String newBio) {
    try {
      this.newBio = newBio;
      image = Uint8List(0);
      emit(EditProfileLoadedState(user, image, newBio));
    } catch (e) {
      emit(EditProfileErrorState(e.toString()));
    }
  }
}
