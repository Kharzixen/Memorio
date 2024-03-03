part of 'album_bloc.dart';

sealed class AlbumEvent {}

final class AlbumFetched extends AlbumEvent {
  String albumId;
  AlbumFetched({required this.albumId});
}

final class AlbumDisplayChangedToCollection extends AlbumEvent {
  String contentBefore;
  double position;
  AlbumDisplayChangedToCollection(
      {required this.contentBefore, required this.position});
}

final class AlbumDisplayChangedToTimeline extends AlbumEvent {
  String contentBefore;
  double position;
  AlbumDisplayChangedToTimeline(
      {required this.contentBefore, required this.position});
}

final class AlbumTimelineNewChunkFetched extends AlbumEvent {
  String albumId;
  AlbumTimelineNewChunkFetched({required this.albumId});
}

final class IncreaseGranularity extends AlbumEvent {}

final class DecreaseGranularity extends AlbumEvent {}
