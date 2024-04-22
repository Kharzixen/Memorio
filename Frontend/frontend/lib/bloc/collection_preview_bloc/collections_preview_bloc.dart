import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/collection_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'collections_preview_event.dart';
part 'collections_preview_state.dart';

class CollectionsPreviewBloc
    extends Bloc<CollectionsPreviewEvent, CollectionsPreviewState> {
  final CollectionRepository collectionRepository;

  int page = 0;
  int pageSize = 10;
  //this field indicates if the first load is made,
  // if it is "" string, the first load is not yet made
  String albumId = "";
  bool hasMoreData = true;

  List<CollectionPreview> collections = [];

  CollectionsPreviewBloc({required this.collectionRepository})
      : super(CollectionsPreviewInitialState()) {
    on<NextDatasetFetched>(_getNextPageOfMemories);
    on<MemoryRemovedFromCollections>(_removeMemoryFromCollectionsPreview);
    on<CollectionRefreshRequested>(_refreshCollectionsPreviewPage);
  }

  FutureOr<void> _getNextPageOfMemories(
      NextDatasetFetched event, Emitter<CollectionsPreviewState> emit) async {
    if (albumId == "") {
      albumId = event.albumId;
    }
    PaginatedResponse<CollectionPreview> newCollections =
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
        CollectionPreview collection = collections[i];
        for (Memory memory in collection.latestMemories) {
          if (memory.memoryId == event.memoryId) {
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
    PaginatedResponse<CollectionPreview> newCollections =
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

}
