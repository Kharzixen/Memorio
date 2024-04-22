part of 'album_creation_bloc.dart';

sealed class AlbumCreationEvent {}

class AlbumCreationStarted extends AlbumCreationEvent {}

class ImageSelectionStarted extends AlbumCreationEvent {}

class RemoveImage extends AlbumCreationEvent {}

class AlbumCreationFinalized extends AlbumCreationEvent {
  String albumName;
  String caption;
  AlbumCreationFinalized({required this.albumName, required this.caption});
}
