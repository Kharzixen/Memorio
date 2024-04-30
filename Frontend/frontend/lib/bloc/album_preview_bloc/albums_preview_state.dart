part of 'albums_preview_bloc.dart';

sealed class AlbumsPreviewState {}

final class AlbumsPreviewInitialState extends AlbumsPreviewState {}

final class AlbumsPreviewLoadingState extends AlbumsPreviewState {}

final class AlbumsPreviewLoadedState extends AlbumsPreviewState {
  final List<AlbumPreview> albums;
  final bool isAsyncMethodInProgress;
  AlbumsPreviewLoadedState(this.albums, this.isAsyncMethodInProgress);
}

final class AlbumsPreviewErrorState extends AlbumsPreviewState {
  final String errorMessage;
  AlbumsPreviewErrorState(this.errorMessage);
}
