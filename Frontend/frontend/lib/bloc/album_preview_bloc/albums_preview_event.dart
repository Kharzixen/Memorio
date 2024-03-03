part of 'albums_preview_bloc.dart';

sealed class AlbumPreviewEvent {}

final class AlbumsPreviewFetched extends AlbumPreviewEvent {
  String userId;
  AlbumsPreviewFetched({required this.userId});
}
