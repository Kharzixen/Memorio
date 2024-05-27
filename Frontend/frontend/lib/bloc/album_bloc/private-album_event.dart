part of 'private-album_bloc.dart';

sealed class AlbumEvent {}

final class AlbumFetched extends AlbumEvent {
  String albumId;
  AlbumFetched({required this.albumId});
}

final class RemoveUserFromAlbumInitiated extends AlbumEvent {
  String userId;
  RemoveUserFromAlbumInitiated(this.userId);
}

final class Refresh extends AlbumEvent {}
