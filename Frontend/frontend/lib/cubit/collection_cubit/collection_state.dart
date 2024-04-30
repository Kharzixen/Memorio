part of 'collection_cubit.dart';

sealed class CollectionPageState {}

class CollectionPageLoadingState extends CollectionPageState {}

class CollectionPageLoadedState extends CollectionPageState {
  CollectionPreview collectionPreview;
  Map<String, List<Memory>> memories;
  int dateGranularityIndex;
  bool hasMoreData;
  bool isAsyncMethodRunning;
  CollectionPageLoadedState(this.collectionPreview, this.memories,
      this.hasMoreData, this.dateGranularityIndex, this.isAsyncMethodRunning);
}

class CollectionPageInitialState extends CollectionPageState {}

class CollectionPageErrorState extends CollectionPageState {
  String errorMessage;
  CollectionPageErrorState(this.errorMessage);
}

class CollectionPageDeletedState extends CollectionPageState {}
