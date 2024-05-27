part of 'private_albums_preview_bloc.dart';

sealed class PrivateAlbumPreviewEvent {}

final class PrivateAlbumsPreviewFetched extends PrivateAlbumPreviewEvent {
  String userId;
  PrivateAlbumsPreviewFetched({required this.userId});
}

final class PrivateAlbumsRefreshRequested extends PrivateAlbumPreviewEvent {}

final class PrivateAlbumLeaved extends PrivateAlbumPreviewEvent {
  String albumId;
  PrivateAlbumLeaved(this.albumId);
}

final class PrivateNewImageCreatedForAlbum extends PrivateAlbumPreviewEvent {
  String albumId;
  PrivateMemory memory;
  PrivateNewImageCreatedForAlbum(this.albumId, this.memory);
}

final class PrivateLeaveAlbum extends PrivateAlbumPreviewEvent {
  String albumId;
  PrivateLeaveAlbum(this.albumId);
}
