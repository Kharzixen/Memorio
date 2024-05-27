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

class NewCollectionCreated extends CollectionsPreviewEvent {
  PrivateCollectionPreview newCollection;
  NewCollectionCreated(this.newCollection);
}

class CollectionRefreshRequested extends CollectionsPreviewEvent {}

class CollectionRemoved extends CollectionsPreviewEvent {
  String collectionId;
  CollectionRemoved(this.collectionId);
}
