part of 'albums_preview_bloc.dart';

sealed class AlbumPreviewEvent {}

final class AlbumsPreviewFetched extends AlbumPreviewEvent {
  String userId;
  AlbumsPreviewFetched({required this.userId});
}

final class AlbumsRefreshRequested extends AlbumPreviewEvent {}

final class AlbumLeaved extends AlbumPreviewEvent {
  String albumId;
  AlbumLeaved(this.albumId);
}

final class NewImageCreatedForAlbum extends AlbumPreviewEvent {
  String albumId;
  Memory memory;
  NewImageCreatedForAlbum(this.albumId, this.memory);
}

final class LeaveAlbum extends AlbumPreviewEvent {
  String albumId;
  LeaveAlbum(this.albumId);
}
