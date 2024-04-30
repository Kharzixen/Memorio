part of 'album_bloc.dart';

sealed class AlbumState {}

final class AlbumInitialState extends AlbumState {}

final class AlbumLoadingState extends AlbumState {}

final class AlbumLoadedState extends AlbumState {
  AlbumInfo albumInfo;
  List<SimpleUser> contributors;
  bool isAsyncActionRunning;
  AlbumLoadedState({
    required this.albumInfo,
    required this.contributors,
    required this.isAsyncActionRunning,
  });
}

final class AlbumErrorState extends AlbumState {
  final String errorMessage;
  AlbumErrorState(this.errorMessage);
}

final class LeavedAlbumState extends AlbumState {}
