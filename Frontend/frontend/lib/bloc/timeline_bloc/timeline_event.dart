part of 'timeline_bloc.dart';

sealed class TimelineEvent {}

final class NextDatasetTimelineFetched extends TimelineEvent {
  String albumId;
  NextDatasetTimelineFetched({required this.albumId});
}

final class IncreaseGranularity extends TimelineEvent {}

final class DecreaseGranularity extends TimelineEvent {}

final class RefreshRequested extends TimelineEvent {}

final class MemoryRemovedFromTimeline extends TimelineEvent {
  String memoryId;
  String date;
  MemoryRemovedFromTimeline({required this.memoryId, required this.date});
}

final class NewMemoryCreatedTimeline extends TimelineEvent {
  Memory memory;
  NewMemoryCreatedTimeline(this.memory);
}
