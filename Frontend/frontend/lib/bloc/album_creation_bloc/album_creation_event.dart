part of 'album_creation_bloc.dart';

sealed class AlbumCreationEvent {}

class AlbumCreationStarted extends AlbumCreationEvent {}

class AddFriendsStarted extends AlbumCreationEvent {
  String creatorId;
  AddFriendsStarted(this.creatorId);
}

class ImageSelectionStarted extends AlbumCreationEvent {
  ImageSource imageSource;
  ImageSelectionStarted(this.imageSource);
}

class RemoveImage extends AlbumCreationEvent {}

class AlbumCreationFinalized extends AlbumCreationEvent {
  String albumName;
  String caption;
  AlbumCreationFinalized({required this.albumName, required this.caption});
}

class SelectedFriendAtIndex extends AlbumCreationEvent {
  int index;
  SelectedFriendAtIndex(this.index);
}

class UnselectedFriendAtIndex extends AlbumCreationEvent {
  int index;
  UnselectedFriendAtIndex(this.index);
}
