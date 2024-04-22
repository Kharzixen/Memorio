import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/memory_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'timeline_event.dart';
part 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final MemoryRepository memoryRepository;
  int page = 0;
  //this field indicates if the first load is made,
  // if it is "" string, the first load is not yet made
  String albumId = "";
  Map<String, List<Memory>> photosByDate = {};
  bool hasMoreData = true;

  final List<String> _granularities = ["all", "year", "month", "day"];
  int _dateGranularityIndex = 2;

  TimelineBloc({required this.memoryRepository})
      : super(TimelineInitialState()) {
    on<NextDatasetTimelineFetched>(_getNextPageOfMemories);
    on<IncreaseGranularity>(_increaseGranularity);
    on<DecreaseGranularity>(_decreaseGranularity);
    on<RefreshRequested>(_refreshState);
    on<MemoryRemovedFromTimeline>(_removeMemoryFromTimeline);
    on<NewMemoryCreatedTimeline>(_addNewMemoryToTimeline);
  }

  void _getNextPageOfMemories(
      NextDatasetTimelineFetched event, Emitter<TimelineState> emit) async {
    if (albumId == "") {
      albumId = event.albumId;
    }
    PaginatedResponse<Memory> memories =
        await memoryRepository.getMemoriesOrderedByDatePaginated(albumId, page);
    if (memories.last) {
      hasMoreData = false;
    }
    page++;
    _addSortedEntriesToPhotoMap(memories.content);

    emit(TimelineLoadedState(
        albumId: albumId,
        photosByDate: photosByDate,
        hasMoreData: hasMoreData,
        granularityIndex: _dateGranularityIndex));
  }

  void _increaseGranularity(
      IncreaseGranularity event, Emitter<TimelineState> emit) async {
    if (_dateGranularityIndex < _granularities.length - 1) {
      _dateGranularityIndex++;
      Map<String, List<Memory>> newPhotosByDate = {};
      for (String key in photosByDate.keys) {
        for (Memory element in photosByDate[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      photosByDate = newPhotosByDate;
      emit(TimelineLoadedState(
          albumId: albumId,
          photosByDate: photosByDate,
          hasMoreData: hasMoreData,
          granularityIndex: _dateGranularityIndex));
    }
  }

  void _decreaseGranularity(
      DecreaseGranularity event, Emitter<TimelineState> emit) {
    if (_dateGranularityIndex > 0) {
      _dateGranularityIndex--;
      Map<String, List<Memory>> newPhotosByDate = {};
      for (String key in photosByDate.keys) {
        for (Memory element in photosByDate[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      photosByDate = newPhotosByDate;
      emit(TimelineLoadedState(
          albumId: albumId,
          photosByDate: photosByDate,
          hasMoreData: hasMoreData,
          granularityIndex: _dateGranularityIndex));
    }
  }

  FutureOr<void> _refreshState(
      RefreshRequested event, Emitter<TimelineState> emit) async {
    page = 0;
    photosByDate = {};
    hasMoreData = true;

    _dateGranularityIndex = 2;

    PaginatedResponse<Memory> memories =
        await memoryRepository.getMemoriesOrderedByDatePaginated(albumId, page);
    if (memories.last) {
      hasMoreData = false;
    }
    page++;
    _addSortedEntriesToPhotoMap(memories.content);

    emit(TimelineLoadedState(
        albumId: albumId,
        photosByDate: photosByDate,
        hasMoreData: hasMoreData,
        granularityIndex: _dateGranularityIndex));
  }

//------------------------------------------------------------------------------------------------------//
  void _addSortedEntriesToPhotoMap(List<Memory> entries) {
    for (Memory element in entries) {
      String displayDate = _getDisplayDate(element.date);
      if (photosByDate.containsKey(displayDate)) {
        photosByDate[displayDate]!.add(element);
      } else {
        photosByDate[displayDate] = [element];
      }
    }
  }

  void _addNewMemoryToPhotoMap(Memory memory) {
    String displayDate = _getDisplayDate(memory.date);
    if (photosByDate.containsKey(displayDate)) {
      photosByDate[displayDate]!.insert(0, memory);
    } else {
      photosByDate[displayDate] = [memory];
    }
  }

  String _getDisplayDate(DateTime date) {
    String monthName = _getMonthName(date.month);
    //String formattedDate = '$monthName ${element.date.day}';

    switch (_granularities[_dateGranularityIndex]) {
      case 'year':
        return '${date.year}';
      case 'month':
        return '${date.year} $monthName';
      case 'day':
        return '${date.year} $monthName ${date.day}';
      default:
        return 'All Photos';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case DateTime.january:
        return 'January';
      case DateTime.february:
        return 'February';
      case DateTime.march:
        return 'March';
      case DateTime.april:
        return 'April';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'June';
      case DateTime.july:
        return 'July';
      case DateTime.august:
        return 'August';
      case DateTime.september:
        return 'September';
      case DateTime.october:
        return 'October';
      case DateTime.november:
        return 'November';
      case DateTime.december:
        return 'December';
      default:
        return '';
    }
  }

  //memory from the server via repository is removed by the memoryBloc,
  //this is only visual update;
  FutureOr<void> _removeMemoryFromTimeline(
      MemoryRemovedFromTimeline event, Emitter<TimelineState> emit) {
    if (photosByDate.isNotEmpty) {
      for (int i = 0; i < photosByDate[event.date]!.length; i++) {
        if (photosByDate[event.date]![i].memoryId == event.memoryId) {
          photosByDate[event.date]!.removeAt(i);
          if (photosByDate[event.date]!.isEmpty) {
            photosByDate.remove(event.date);
          }
          break;
        }
      }
      emit(TimelineLoadedState(
          albumId: albumId,
          photosByDate: photosByDate,
          hasMoreData: hasMoreData,
          granularityIndex: _dateGranularityIndex));
    }
  }

  FutureOr<void> _addNewMemoryToTimeline(
      NewMemoryCreatedTimeline event, Emitter<TimelineState> emit) {
    _addNewMemoryToPhotoMap(event.memory);
    emit(TimelineLoadedState(
        albumId: albumId,
        photosByDate: photosByDate,
        hasMoreData: hasMoreData,
        granularityIndex: _dateGranularityIndex));
  }
}
