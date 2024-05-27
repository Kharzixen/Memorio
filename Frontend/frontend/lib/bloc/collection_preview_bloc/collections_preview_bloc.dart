import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/private_collection_repository.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'collections_preview_event.dart';
part 'collections_preview_state.dart';

class CollectionsPreviewBloc
    extends Bloc<CollectionsPreviewEvent, CollectionsPreviewState> {
  final PrivateCollectionRepository collectionRepository;

  int page = 0;
  int pageSize = 10;
  //this field indicates if the first load is made,
  // if it is "" string, the first load is not yet made
  String albumId = "";
  bool hasMoreData = true;

  List<PrivateCollectionPreview> collections = [];

  CollectionsPreviewBloc({required this.collectionRepository})
      : super(CollectionsPreviewInitialState()) {
    on<NextDatasetFetched>(_getNextPageOfMemories);
    on<MemoryRemovedFromCollections>(_removeMemoryFromCollectionsPreview);
    on<CollectionRefreshRequested>(_refreshCollectionsPreviewPage);
    on<NewCollectionCreated>(_addNewCollection);
    on<CollectionRemoved>(_deleteCollection);
  }

  FutureOr<void> _getNextPageOfMemories(
      NextDatasetFetched event, Emitter<CollectionsPreviewState> emit) async {
    if (albumId == "") {
      albumId = event.albumId;
    }
    PaginatedResponse<PrivateCollectionPreview> newCollections =
        await collectionRepository.getCollectionsOfAlbum(
            albumId, page, pageSize);
    if (newCollections.last) {
      hasMoreData = false;
    }
    page++;
    collections.addAll(newCollections.content);
    emit(CollectionsPreviewLoadedState(
      albumId: albumId,
      collections: collections,
      hasMoreData: hasMoreData,
    ));
  }

  FutureOr<void> _removeMemoryFromCollectionsPreview(
      MemoryRemovedFromCollections event,
      Emitter<CollectionsPreviewState> emit) async {
    if (albumId != "") {
      for (int i = 0; i < collections.length; i++) {
        PrivateCollectionPreview collection = collections[i];
        for (PrivateCollectionMemory collectionMemory
            in collection.latestMemories) {
          if (collectionMemory.memory.memoryId == event.memoryId) {
            collections[i] = await collectionRepository
                .getCollectionPreviewById(albumId, collection.collectionId);
          }
          break;
        }
      }
      emit(CollectionsPreviewLoadedState(
        albumId: albumId,
        collections: collections,
        hasMoreData: hasMoreData,
      ));
    }
  }

  FutureOr<void> _refreshCollectionsPreviewPage(
      CollectionRefreshRequested event,
      Emitter<CollectionsPreviewState> emit) async {
    hasMoreData = true;
    collections = [];
    page = 0;
    PaginatedResponse<PrivateCollectionPreview> newCollections =
        await collectionRepository.getCollectionsOfAlbum(
            albumId, page, pageSize);
    if (newCollections.last) {
      hasMoreData = false;
    }
    page++;
    collections.addAll(newCollections.content);
    emit(CollectionsPreviewLoadedState(
      albumId: albumId,
      collections: collections,
      hasMoreData: hasMoreData,
    ));
  }

  FutureOr<void> _addNewCollection(
      NewCollectionCreated event, Emitter<CollectionsPreviewState> emit) {
    collections.insert(0, event.newCollection);
    emit(CollectionsPreviewLoadedState(
      albumId: albumId,
      collections: collections,
      hasMoreData: hasMoreData,
    ));
  }

  FutureOr<void> _deleteCollection(
      CollectionRemoved event, Emitter<CollectionsPreviewState> emit) {
    for (int i = 0; i < collections.length; i++) {
      if (collections[i].collectionId == event.collectionId) {
        collections.removeAt(i);
        break;
      }
    }
    emit(CollectionsPreviewLoadedState(
      albumId: albumId,
      collections: collections,
      hasMoreData: hasMoreData,
    ));
  }
}
