part of 'album_bloc.dart';

sealed class AlbumState {}

final class AlbumInitialState extends AlbumState {}

final class AlbumLoadingState extends AlbumState {}

final class AlbumLoadedState extends AlbumState {
  AlbumInfo albumInfo;

  AlbumLoadedState({
    required this.albumInfo,
  });
}

final class AlbumErrorState extends AlbumState {
  final String errorMessage;
  AlbumErrorState(this.errorMessage);
}
