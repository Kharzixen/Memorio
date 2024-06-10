import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/public_memory_repository.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'public_memories_state.dart';

class PublicMemoriesCubit extends Cubit<PublicMemoriesState> {
  final PublicMemoryRepository publicMemoryRepository;
  late String albumId;

  final List<String> _granularities = ["all", "year", "month", "day"];
  Set<String> includedImages = {};

  int _dateGranularityIndex = 2;

  Map<String, List<PublicMemory>> memories = {};

  int page = 0;
  int pageSize = 12;
  bool hasMoreData = true;

  PublicMemoriesCubit(this.publicMemoryRepository)
      : super(PublicMemoriesInitialState());

  void loadMemories(String albumId) async {
    try {
      //emit(PublicMemoriesLoadingState());
      this.albumId = albumId;
      PaginatedResponse<PublicMemory> memoriesBatch =
          await publicMemoryRepository.getMemoriesOfPublicAlbum(
              albumId, page, pageSize);
      _addToPhotoMap(memoriesBatch.content);
      page++;
      if (memoriesBatch.last) {
        hasMoreData = false;
      }
      emit(PublicMemoriesLoadedState(
          memories, hasMoreData, _dateGranularityIndex));
    } catch (e) {
      emit(PublicMemoriesErrorState(e.toString()));
    }
  }

  void addNewMemory(PublicMemory memory) {
    String displayDate = _getDisplayDate(memory.date);
    if (memories.containsKey(displayDate)) {
      memories[displayDate]!.insert(0, memory);
      includedImages.add(memory.memoryId);
    } else {
      memories[displayDate] = [memory];
      includedImages.add(memory.memoryId);
    }
    //true ?
    emit(PublicMemoriesLoadedState(
        memories, hasMoreData, _dateGranularityIndex));
  }

  void increaseGranularity() async {
    if (_dateGranularityIndex < _granularities.length - 1) {
      _dateGranularityIndex++;
      Map<String, List<PublicMemory>> newPhotosByDate = {};
      for (String key in memories.keys) {
        for (PublicMemory element in memories[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      memories = newPhotosByDate;
      emit(PublicMemoriesLoadedState(
          memories, hasMoreData, _dateGranularityIndex));
    }
  }

  void decreaseGranularity() {
    if (_dateGranularityIndex > 0) {
      _dateGranularityIndex--;
      Map<String, List<PublicMemory>> newPhotosByDate = {};
      for (String key in memories.keys) {
        for (PublicMemory element in memories[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      memories = newPhotosByDate;
      emit(PublicMemoriesLoadedState(
          memories, hasMoreData, _dateGranularityIndex));
    }
  }

  void refresh() async {
    memories = {};
    includedImages = {};
    page = 0;
    hasMoreData = true;
    try {
      PaginatedResponse<PublicMemory> memoriesBatch =
          await publicMemoryRepository.getMemoriesOfPublicAlbum(
              albumId, page, pageSize);
      _addToPhotoMap(memoriesBatch.content);
      page++;
      if (memoriesBatch.last) {
        hasMoreData = false;
      }
      emit(PublicMemoriesLoadedState(
          memories, hasMoreData, _dateGranularityIndex));
    } catch (e) {
      emit(PublicMemoriesErrorState(e.toString()));
    }
  }

  void removeMemory(String date, int index) {
    if (memories.isNotEmpty) {
      memories[date]!.removeAt(index);
      if (memories[date]!.isEmpty) {
        memories.remove(date);
      }
    }
    emit(PublicMemoriesLoadedState(
        memories, hasMoreData, _dateGranularityIndex));
  }

  void _addToPhotoMap(List<PublicMemory> entries) {
    for (PublicMemory element in entries) {
      String displayDate = _getDisplayDate(element.date);
      if (memories.containsKey(displayDate)) {
        if (!includedImages.contains(element.memoryId)) {
          memories[displayDate]!.add(element);
          includedImages.add(element.memoryId);
        }
      } else {
        memories[displayDate] = [element];
      }
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
}
