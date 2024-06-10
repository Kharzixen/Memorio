part of 'public_album_cubit.dart';

sealed class PublicAlbumState {}

final class PublicAlbumInitialState extends PublicAlbumState {}

final class PublicAlbumLoadingState extends PublicAlbumState {}

final class PublicAlbumLoadedState extends PublicAlbumState {
  PublicAlbumInfo albumInfo;
  List<SimpleUser> contributors;
  bool isAsyncActionRunning;
  PublicAlbumLoadedState({
    required this.albumInfo,
    required this.contributors,
    required this.isAsyncActionRunning,
  });
}

final class PublicAlbumErrorState extends PublicAlbumState {
  final String errorMessage;
  PublicAlbumErrorState(this.errorMessage);
}

final class LeavedPublicAlbumState extends PublicAlbumState {}
