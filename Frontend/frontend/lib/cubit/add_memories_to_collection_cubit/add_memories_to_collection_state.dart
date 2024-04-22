part of 'add_memories_to_collection_cubit.dart';

sealed class AddMemoriesToCollectionPageState {}

class AddMemoriesToCollectionPageInitialState
    extends AddMemoriesToCollectionPageState {}

class AddMemoriesToCollectionPageLoadingState
    extends AddMemoriesToCollectionPageState {}

class AddMemoriesToCollectionPageLoadedState
    extends AddMemoriesToCollectionPageState {
  List<Memory> memories;
  List<bool> isSelected;
  int nrOfSelected;
  AddMemoriesToCollectionPageLoadedState(
      this.memories, this.isSelected, this.nrOfSelected);
}

class AddMemoriesToCollectionPageErrorState
    extends AddMemoriesToCollectionPageState {}
