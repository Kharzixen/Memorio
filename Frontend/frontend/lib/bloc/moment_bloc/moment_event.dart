part of 'moment_bloc.dart';

sealed class MemoryEvent {}

final class MemoryFetched extends MemoryEvent {
  String momentId;
  String albumId;
  MemoryFetched({required this.momentId, required this.albumId});
}

final class MemoryRemoved extends MemoryEvent {
  String memoryId;
  MemoryRemoved({required this.memoryId});
}

final class MemoryCollectionsChanged extends MemoryEvent {
  List<SimplePrivateCollection> newCollections;
  MemoryCollectionsChanged({required this.newCollections});
}

final class MomentLikedByUser extends MemoryEvent {
  String memoryId;
  String userId;
  MomentLikedByUser(this.memoryId, this.userId);
}
