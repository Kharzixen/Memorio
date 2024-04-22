part of 'select_collections_sheet_bloc.dart';

sealed class SelectCollectionsSheetEvent {}

class NextCollectionsDatasetFetched extends SelectCollectionsSheetEvent {
  String albumId;
  // List<SimpleCollection> includedCollections;
  NextCollectionsDatasetFetched({required this.albumId});
}

class CollectionAddedToIncluded extends SelectCollectionsSheetEvent {
  String collectionId;
  CollectionAddedToIncluded({required this.collectionId});
}

class CollectionRemovedFromIncluded extends SelectCollectionsSheetEvent {
  String collectionId;
  CollectionRemovedFromIncluded({required this.collectionId});
}
