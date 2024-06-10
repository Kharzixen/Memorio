import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:image_picker/image_picker.dart';

part 'public_album_creation_state.dart';

class PublicAlbumCreationCubit extends Cubit<PublicAlbumCreationState> {
  PublicAlbumRepository albumRepository;
  UserRepository userRepository;
  Uint8List image = Uint8List(0);
  List<SimpleUser> friends = [];
  List<SimpleUser> selectedFriends = [];
  List<bool> isSelectedFriend = [];
  int friendsPage = 0;
  int friendsPageSize = 10;
  bool friendsHasMoreData = true;
  PublicAlbumCreationCubit(this.albumRepository, this.userRepository)
      : super(PublicAlbumCreationInProgressState(
            image: Uint8List(0), friends: [], isSelectedFriend: []));

  FutureOr<void> pickImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    final File imageFile = File(pickedImage!.path);
    final double imageSize = await imageFile.length() / 1024;
    if (imageSize > 750.0) {
      image = await compressFile(imageFile);
    } else {
      image = imageFile.readAsBytesSync();
    }
    emit(PublicAlbumCreationInProgressState(
        image: image, friends: friends, isSelectedFriend: isSelectedFriend));
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

  FutureOr<void> removeImage() {
    image = Uint8List(0);
    emit(PublicAlbumCreationInProgressState(
        image: image, friends: friends, isSelectedFriend: isSelectedFriend));
  }

  FutureOr<void> createAlbum(String albumName, String caption) async {
    PublicAlbumPreview simpleAlbum = await albumRepository.createAlbum(
        StorageService().userId,
        albumName,
        caption,
        selectedFriends.toList(),
        image);
    emit(PublicAlbumCreationFinishedState(simpleAlbum));
  }

  FutureOr<void> startContributorSelection(String creatorId) async {
    PaginatedResponse<SimpleUser> paginatedResponse = await userRepository
        .getFriendsOfUser(creatorId, friendsPage, friendsPageSize);
    friendsPage++;
    if (paginatedResponse.last) {
      friendsHasMoreData = false;
    }
    friends.addAll(paginatedResponse.content);
    for (int i = 0; i < paginatedResponse.content.length; i++) {
      isSelectedFriend.add(false);
    }
    emit(PublicAlbumCreationInProgressState(
        image: image, friends: friends, isSelectedFriend: isSelectedFriend));
  }

  FutureOr<void> selectFriendAtIndex(int index) {
    isSelectedFriend[index] = true;
    selectedFriends.add(friends[index]);
    emit(PublicAlbumCreationInProgressState(
        image: image, friends: friends, isSelectedFriend: isSelectedFriend));
  }

  FutureOr<void> unselectFriendAtIndex(int index) {
    isSelectedFriend[index] = false;
    selectedFriends.remove(friends[index]);
    emit(PublicAlbumCreationInProgressState(
        image: image, friends: friends, isSelectedFriend: isSelectedFriend));
  }
}
