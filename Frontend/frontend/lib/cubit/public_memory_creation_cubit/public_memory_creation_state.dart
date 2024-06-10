part of 'public_memory_creation_cubit.dart';

class MemoryCreationState {}

class MemoryCreationInitialState extends MemoryCreationState {}

class MemoryCreationLoadingState extends MemoryCreationState {}

class MemoryCreationLoadedState extends MemoryCreationState {
  Uint8List image;
  int width;
  int height;
  int page;
  String description;
  SimplePublicAlbum publicAlbum;
  MemoryCreationLoadedState({
    required this.image,
    required this.width,
    required this.height,
    required this.page,
    required this.description,
    required this.publicAlbum,
  });
}

class MemoryCreationNoImageSelectedState extends MemoryCreationState {}

class MemoryCreationFinishedState extends MemoryCreationState {
  PublicMemory memory;
  MemoryCreationFinishedState(this.memory);
}

class MemoryCreationErrorState extends MemoryCreationState {
  String message;
  MemoryCreationErrorState(this.message);
}
