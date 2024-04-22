part of 'collections_preview_bloc.dart';

sealed class CollectionsPreviewEvent {}

final class NextDatasetFetched extends CollectionsPreviewEvent {
  String albumId;
  NextDatasetFetched({required this.albumId});
}

class MemoryRemovedFromCollections extends CollectionsPreviewEvent {
  String memoryId;
  MemoryRemovedFromCollections({required this.memoryId});
}

class CollectionRefreshRequested extends CollectionsPreviewEvent {}
