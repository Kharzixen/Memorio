part of 'memory_creation_bloc.dart';

class MemoryCreationEvent {}

class MemoryCreationStarted extends MemoryCreationEvent {
  MemoryCreationDetails memoryCreationDetails;
  MemoryCreationStarted({required this.memoryCreationDetails});
}

class NextPageFetched extends MemoryCreationEvent {}

class PrevPageFetched extends MemoryCreationEvent {}

class CollectionSelected extends MemoryCreationEvent {
  String albumId;
  SimplePrivateCollection collection;
  CollectionSelected({required this.albumId, required this.collection});
}

class CollectionUnselected extends MemoryCreationEvent {
  String albumId;
  SimplePrivateCollection collection;
  CollectionUnselected({required this.albumId, required this.collection});
}

class AlbumSelected extends MemoryCreationEvent {
  String albumId;
  SimplePrivateAlbum album;
  AlbumSelected({required this.albumId, required this.album});
}

class AlbumUnselected extends MemoryCreationEvent {
  String albumId;
  AlbumUnselected({required this.albumId});
}

class DescriptionSaved extends MemoryCreationEvent {
  String description;
  DescriptionSaved({required this.description});
}

class MemoryCreationFinished extends MemoryCreationEvent {}

class ImageSaveRequested extends MemoryCreationEvent {}
