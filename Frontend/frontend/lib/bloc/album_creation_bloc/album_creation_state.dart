part of 'album_creation_bloc.dart';

sealed class AlbumCreationState {}

class AlbumCreationInProgressState extends AlbumCreationState {
  Uint8List image;
  List<SimpleUser> friends;
  List<bool> isSelectedFriend;
  AlbumCreationInProgressState(
      {required this.image,
      required this.friends,
      required this.isSelectedFriend});
}

class AlbumCreationFinishedState extends AlbumCreationState {
  SimpleAlbum album;
  AlbumCreationFinishedState(this.album);
}
