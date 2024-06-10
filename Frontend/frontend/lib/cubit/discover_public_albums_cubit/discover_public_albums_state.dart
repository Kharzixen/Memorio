part of 'discover_public_albums_cubit.dart';

sealed class DiscoverPublicAlbumPreviewsState {}

class DiscoverPublicAlbumPreviewsInitialState
    extends DiscoverPublicAlbumPreviewsState {}

class DiscoverPublicAlbumPreviewsLoadingState
    extends DiscoverPublicAlbumPreviewsState {}

class DiscoverPublicAlbumPreviewsLoadedState
    extends DiscoverPublicAlbumPreviewsState {
  List<PublicAlbumPreview> publicAlbums;
  DiscoverPublicAlbumPreviewsLoadedState(this.publicAlbums);
}

class DiscoverPublicAlbumPreviewsErrorState
    extends DiscoverPublicAlbumPreviewsState {
  String message;
  DiscoverPublicAlbumPreviewsErrorState(this.message);
}
