part of 'public_album_creation_cubit.dart';

sealed class PublicAlbumCreationState {}

class PublicAlbumCreationInProgressState extends PublicAlbumCreationState {
  Uint8List image;
  List<SimpleUser> friends;
  List<bool> isSelectedFriend;
  PublicAlbumCreationInProgressState(
      {required this.image,
      required this.friends,
      required this.isSelectedFriend});
}

class PublicAlbumCreationFinishedState extends PublicAlbumCreationState {
  PublicAlbumPreview album;
  PublicAlbumCreationFinishedState(this.album);
}
