import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:image_picker/image_picker.dart';

part 'album_creation_event.dart';
part 'album_creation_state.dart';

class AlbumCreationBloc extends Bloc<AlbumCreationEvent, AlbumCreationState> {
  final PrivateAlbumRepository albumRepository;
  final UserRepository userRepository;

  List<SimpleUser> friends = [];
  int friendsPage = 0;
  int friendsPageSize = 20;
  bool friendsHasMoreData = true;
  Set<SimpleUser> selectedFriends = {};
  List<bool> isSelectedFriend = [];

  Uint8List image = Uint8List(0);

  AlbumCreationBloc(
      {required this.albumRepository, required this.userRepository})
      : super(AlbumCreationInProgressState(
            image: Uint8List(0), friends: [], isSelectedFriend: [])) {
    on<AddFriendsStarted>(_startContributorSelection);
    on<ImageSelectionStarted>(_pickImage);
    on<RemoveImage>(_removeImage);
    on<AlbumCreationFinalized>(_createAlbum);
    on<SelectedFriendAtIndex>(_selectFriendAtIndex);
    on<UnselectedFriendAtIndex>(_unselectFriendAtIndex);
  }

  FutureOr<void> _pickImage(
      ImageSelectionStarted event, Emitter<AlbumCreationState> emit) async {
    final pickedImage =
        await ImagePicker().pickImage(source: event.imageSource);
    final File imageFile = File(pickedImage!.path);
    final double imageSize = await imageFile.length() / 1024;
    if (imageSize > 750.0) {
      image = await compressFile(imageFile);
    } else {
      image = imageFile.readAsBytesSync();
    }
    emit(AlbumCreationInProgressState(
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

  FutureOr<void> _removeImage(
      RemoveImage event, Emitter<AlbumCreationState> emit) {
    image = Uint8List(0);
    emit(AlbumCreationInProgressState(
        image: image, friends: friends, isSelectedFriend: isSelectedFriend));
  }

  FutureOr<void> _createAlbum(
      AlbumCreationFinalized event, Emitter<AlbumCreationState> emit) async {
    PrivateAlbumPreview simpleAlbum = await albumRepository.createAlbum(
        StorageService().userId,
        event.albumName,
        event.caption,
        selectedFriends.toList(),
        image);
    emit(AlbumCreationFinishedState(simpleAlbum));
  }

  FutureOr<void> _startContributorSelection(
      AddFriendsStarted event, Emitter<AlbumCreationState> emit) async {
    PaginatedResponse<SimpleUser> paginatedResponse = await userRepository
        .getFriendsOfUser(event.creatorId, friendsPage, friendsPageSize);
    friendsPage++;
    if (paginatedResponse.last) {
      friendsHasMoreData = false;
    }
    friends.addAll(paginatedResponse.content);
    for (int i = 0; i < paginatedResponse.content.length; i++) {
      isSelectedFriend.add(false);
    }
    emit(AlbumCreationInProgressState(
        image: image, friends: friends, isSelectedFriend: isSelectedFriend));
  }

  FutureOr<void> _selectFriendAtIndex(
      SelectedFriendAtIndex event, Emitter<AlbumCreationState> emit) {
    isSelectedFriend[event.index] = true;
    selectedFriends.add(friends[event.index]);
    emit(AlbumCreationInProgressState(
        image: image, friends: friends, isSelectedFriend: isSelectedFriend));
  }

  FutureOr<void> _unselectFriendAtIndex(
      UnselectedFriendAtIndex event, Emitter<AlbumCreationState> emit) {
    isSelectedFriend[event.index] = false;
    selectedFriends.remove(friends[event.index]);
    emit(AlbumCreationInProgressState(
        image: image, friends: friends, isSelectedFriend: isSelectedFriend));
  }
}
