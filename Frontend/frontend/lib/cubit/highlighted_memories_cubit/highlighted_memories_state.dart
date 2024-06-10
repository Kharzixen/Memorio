part of 'highlighted_memories_cubit.dart';

sealed class HighlightedMemoriesState {}

class HighlightedMemoriesInitialState extends HighlightedMemoriesState {}

class HighlightedMemoriesLoadingState extends HighlightedMemoriesState {}

class HighlightedMemoriesLoadedState extends HighlightedMemoriesState {
  Map<String, List<PublicMemory>> memories;
  bool hasMoreData;
  int dateGranularityIndex;
  HighlightedMemoriesLoadedState(
      this.memories, this.hasMoreData, this.dateGranularityIndex);
}

class HighlightedMemoriesErrorState extends HighlightedMemoriesState {
  String message;
  HighlightedMemoriesErrorState(this.message);
}
