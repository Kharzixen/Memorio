part of 'album_bloc.dart';

sealed class AlbumState {}

final class AlbumInitialState extends AlbumState {}

final class AlbumLoadingState extends AlbumState {}

final class AlbumLoadedState extends AlbumState {
  String content;
  AlbumHeaderInfo albumInfo;
  bool animationEnabled;
  bool timelineHasMoreData;
  Map<String, List<Moment>> photosByDate;
  bool collectionHasMoreData;
  List<CollectionPreview> collections;
  double timelinePosition;
  double collectionsPosition;
  bool timelineFirstFetch;
  bool collectionFirstFetch;
  AlbumLoadedState(
      {required this.content,
      required this.albumInfo,
      required this.animationEnabled,
      required this.photosByDate,
      required this.timelineHasMoreData,
      required this.collectionHasMoreData,
      required this.collections,
      required this.timelinePosition,
      required this.collectionsPosition,
      required this.timelineFirstFetch,
      required this.collectionFirstFetch});
}

final class AlbumErrorState extends AlbumState {
  final String errorMessage;
  AlbumErrorState(this.errorMessage);
}
