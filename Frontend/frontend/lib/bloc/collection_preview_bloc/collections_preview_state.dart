part of 'collections_preview_bloc.dart';

sealed class CollectionsPreviewState {}

final class CollectionsPreviewInitialState extends CollectionsPreviewState {}

final class CollectionsPreviewLoadedState extends CollectionsPreviewState {
  final String albumId;
  final List<PrivateCollectionPreview> collections;
  final bool hasMoreData;
  CollectionsPreviewLoadedState(
      {required this.albumId,
      required this.collections,
      required this.hasMoreData});
}
