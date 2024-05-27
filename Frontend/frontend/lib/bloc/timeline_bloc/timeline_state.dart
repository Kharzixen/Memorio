part of 'timeline_bloc.dart';

sealed class TimelineState {}

final class TimelineInitialState extends TimelineState {}

final class TimelineLoadingState extends TimelineState {}

final class TimelineLoadedState extends TimelineState {
  final String albumId;
  final Map<String, List<PrivateMemory>> photosByDate;
  final bool hasMoreData;
  final int granularityIndex;
  TimelineLoadedState(
      {required this.photosByDate,
      required this.hasMoreData,
      required this.albumId,
      required this.granularityIndex});
}
