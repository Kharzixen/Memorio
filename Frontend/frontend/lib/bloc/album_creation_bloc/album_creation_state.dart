part of 'album_creation_bloc.dart';

sealed class AlbumCreationState {}

class AlbumCreationInProgressState extends AlbumCreationState {
  Uint8List image;
  AlbumCreationInProgressState({required this.image});
}

class AlbumCreationFinishedState extends AlbumCreationState {
  AlbumCreationFinishedState();
}
