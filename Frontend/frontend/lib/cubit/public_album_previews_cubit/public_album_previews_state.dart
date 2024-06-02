part of 'public_album_previews_cubit.dart';

sealed class PublicAlbumPreviewsState {}

class PublicAlbumPreviewsInitialState extends PublicAlbumPreviewsState {}

class PublicAlbumPreviewsLoadingState extends PublicAlbumPreviewsState {}

class PublicAlbumPreviewsLoadedState extends PublicAlbumPreviewsState {
  List<PublicAlbumPreview> publicAlbums;
  PublicAlbumPreviewsLoadedState(this.publicAlbums);
}

class PublicAlbumPreviewsErrorState extends PublicAlbumPreviewsState {
  String message;
  PublicAlbumPreviewsErrorState(this.message);
}
