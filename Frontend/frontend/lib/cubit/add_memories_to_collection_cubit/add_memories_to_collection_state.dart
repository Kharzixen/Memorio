part of 'add_memories_to_collection_cubit.dart';

sealed class AddMemoriesToCollectionPageState {}

class AddMemoriesToCollectionPageInitialState
    extends AddMemoriesToCollectionPageState {}

class AddMemoriesToCollectionPageLoadingState
    extends AddMemoriesToCollectionPageState {}

class AddMemoriesToCollectionPageLoadedState
    extends AddMemoriesToCollectionPageState {
  List<PrivateMemory> memories;
  List<bool> isSelected;
  int nrOfSelected;
  bool isAsyncMethodRunning;
  AddMemoriesToCollectionPageLoadedState(this.memories, this.isSelected,
      this.nrOfSelected, this.isAsyncMethodRunning);
}

class AddMemoriesToCollectionPageFinishedState
    extends AddMemoriesToCollectionPageState {
  List<PrivateMemory> memories;
  AddMemoriesToCollectionPageFinishedState(this.memories);
}

class AddMemoriesToCollectionPageErrorState
    extends AddMemoriesToCollectionPageState {}
