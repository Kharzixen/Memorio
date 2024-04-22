import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/collection_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'select_collections_sheet_event.dart';
part 'select_collections_sheet_state.dart';

class SelectCollectionsSheetBloc
    extends Bloc<SelectCollectionsSheetEvent, SelectCollectionsSheetState> {
  final CollectionRepository collectionRepository;
  final List<SimpleCollection> initiallyIncludedCollections;
  int page = 0;
  int pageSize = 10;
  String albumId = "";
  bool hasMoreData = true;

  Map<String, SimpleCollection> collections = {};
  Map<String, SimpleCollection> includedCollections = {};

  SelectCollectionsSheetBloc(
      {required this.collectionRepository,
      required this.initiallyIncludedCollections})
      : super(SelectCollectionsSheetInitialSate()) {
    //initialize included collections
    for (SimpleCollection collectionPreview in initiallyIncludedCollections) {
      includedCollections[collectionPreview.collectionId] = collectionPreview;
    }

    //event handlers
    on<NextCollectionsDatasetFetched>(_fetchNextDataset);
    on<CollectionAddedToIncluded>(_addCollectionToIncluded);
    on<CollectionRemovedFromIncluded>(_removeCollectionFromIncluded);
  }

  void _fetchNextDataset(NextCollectionsDatasetFetched event,
      Emitter<SelectCollectionsSheetState> emit) async {
    albumId = event.albumId;

    if (hasMoreData) {
      print("data fetched");
      PaginatedResponse<SimpleCollection> newCollections =
          await collectionRepository.getSimpleCollectionsOfAlbum(
              albumId, page, pageSize);
      if (newCollections.last) {
        hasMoreData = false;
      }
      page++;
      addToCollections(newCollections.content);
    }

    emit(SelectCollectionsSheetLoadedState(
        albumId: albumId,
        collections: collections,
        hasMoreData: hasMoreData,
        includedCollections: includedCollections));
  }

  void addToCollections(List<SimpleCollection> collectionsList) {
    for (SimpleCollection collection in collectionsList) {
      if (!includedCollections.containsKey(collection.collectionId)) {
        collections[collection.collectionId] = collection;
      }
    }
  }

  FutureOr<void> _addCollectionToIncluded(CollectionAddedToIncluded event,
      Emitter<SelectCollectionsSheetState> emit) {
    SimpleCollection collectionPreview = collections[event.collectionId]!;
    collections.remove(event.collectionId);
    includedCollections[collectionPreview.collectionId] = collectionPreview;
    emit(SelectCollectionsSheetLoadedState(
        albumId: albumId,
        collections: collections,
        hasMoreData: hasMoreData,
        includedCollections: includedCollections));
  }

  FutureOr<void> _removeCollectionFromIncluded(
      CollectionRemovedFromIncluded event,
      Emitter<SelectCollectionsSheetState> emit) {
    SimpleCollection collectionPreview =
        includedCollections[event.collectionId]!;
    includedCollections.remove(collectionPreview.collectionId);
    collections[collectionPreview.collectionId] = collectionPreview;
    emit(SelectCollectionsSheetLoadedState(
        albumId: albumId,
        collections: collections,
        hasMoreData: hasMoreData,
        includedCollections: includedCollections));
  }
}
