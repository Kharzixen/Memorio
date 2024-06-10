part of 'public_memories_cubit.dart';

sealed class PublicMemoriesState {}

class PublicMemoriesInitialState extends PublicMemoriesState {}

class PublicMemoriesLoadingState extends PublicMemoriesState {}

class PublicMemoriesLoadedState extends PublicMemoriesState {
  Map<String, List<PublicMemory>> memories;
  bool hasMoreData;
  int dateGranularityIndex;
  PublicMemoriesLoadedState(
      this.memories, this.hasMoreData, this.dateGranularityIndex);
}

class PublicMemoriesErrorState extends PublicMemoriesState {
  String message;
  PublicMemoriesErrorState(this.message);
}
