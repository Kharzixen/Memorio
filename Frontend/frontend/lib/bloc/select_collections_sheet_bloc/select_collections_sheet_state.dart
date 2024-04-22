part of 'select_collections_sheet_bloc.dart';

sealed class SelectCollectionsSheetState {}

class SelectCollectionsSheetInitialSate extends SelectCollectionsSheetState {}

class SelectCollectionsSheetLoadingState extends SelectCollectionsSheetState {}

class SelectCollectionsSheetLoadedState extends SelectCollectionsSheetState {
  final String albumId;
  final Map<String, SimpleCollection> collections;
  final Map<String, SimpleCollection> includedCollections;
  final bool hasMoreData;
  SelectCollectionsSheetLoadedState(
      {required this.albumId,
      required this.collections,
      required this.includedCollections,
      required this.hasMoreData});
}
