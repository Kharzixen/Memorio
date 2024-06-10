part of 'public_memory_cubit.dart';

sealed class PublicMemoryState {}

class PublicMemoryInitialState extends PublicMemoryState {}

class PublicMemoryLoadingState extends PublicMemoryState {}

class PublicMemoryLoadedState extends PublicMemoryState {
  bool asyncMethodInProgress;
  DetailedPublicMemory memory;
  PublicMemoryLoadedState(this.memory, this.asyncMethodInProgress);
}

class PublicMemoryErrorState extends PublicMemoryState {
  String error;
  PublicMemoryErrorState(this.error);
}

class PublicMemoryDeletedState extends PublicMemoryState {}
