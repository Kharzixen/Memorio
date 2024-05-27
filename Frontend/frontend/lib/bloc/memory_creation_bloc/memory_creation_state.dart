part of 'memory_creation_bloc.dart';

class MemoryCreationState {}

class MemoryCreationInitialState extends MemoryCreationState {}

class MemoryCreationLoadingState extends MemoryCreationState {}

class MemoryCreationLoadedState extends MemoryCreationState {
  Uint8List image;
  int width;
  int height;
  int page;
  String description;
  Map<String, PrivateAlbumWithSelectedCollections> albums;
  MemoryCreationLoadedState(
      {required this.image,
      required this.width,
      required this.height,
      required this.page,
      required this.description,
      required this.albums});
}

class MemoryCreationNoImageSelectedState extends MemoryCreationState {}

class MemoryCreationFinishedState extends MemoryCreationState {
  PrivateMemory memory;
  MemoryCreationFinishedState(this.memory);
}

class MemoryCreationErrorState extends MemoryCreationState {
  String message;
  MemoryCreationErrorState(this.message);
}
