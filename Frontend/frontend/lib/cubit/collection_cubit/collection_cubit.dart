import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/private_collection_repository.dart';
import 'package:frontend/data/repository/private_memory_repository.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'collection_state.dart';

class CollectionPageCubit extends Cubit<CollectionPageState> {
  final PrivateCollectionRepository collectionRepository;
  final PrivateMemoryRepository memoryRepository;

  Set<String> includedImages = {};

  Map<String, List<PrivateMemory>> memoriesByDate = {};
  int page = 0;
  bool hasMoreData = true;

  final List<String> _granularities = ["all", "year", "month", "day"];
  int _dateGranularityIndex = 2;

  late PrivateCollectionPreview collectionPreview;
  String albumId = "";
  String collectionId = "";

  CollectionPageCubit(this.collectionRepository, this.memoryRepository)
      : super(CollectionPageInitialState());

  Future<void> loadCollection(String albumId, String collectionId) async {
    try {
      emit(CollectionPageLoadingState());
      this.albumId = albumId;
      this.collectionId = collectionId;
      collectionPreview = await collectionRepository.getCollectionPreviewById(
          albumId, collectionId);

      PaginatedResponse<PrivateCollectionMemory> nextPageMemoriesOfAlbum =
          await memoryRepository.getMemoriesOfCollectionOrderedByAddedDate(
              albumId, page, collectionId);
      _addToPhotoMap(nextPageMemoriesOfAlbum.content);

      emit(CollectionPageLoadedState(collectionPreview, memoriesByDate,
          hasMoreData, _dateGranularityIndex, false));
    } catch (e) {
      // Emit error state if an error occurs
      emit(CollectionPageErrorState('Failed to fetch collection data: $e'));
    }
  }

  Future<void> refreshCollection() async {
    memoriesByDate = {};
    page = 0;
    hasMoreData = true;
    includedImages = {};
    try {
      collectionPreview = await collectionRepository.getCollectionPreviewById(
          albumId, collectionId);
      PaginatedResponse<PrivateCollectionMemory> nextPageMemoriesOfAlbum =
          await memoryRepository.getMemoriesOfCollectionOrderedByAddedDate(
              albumId, page, collectionId);
      _addToPhotoMap(nextPageMemoriesOfAlbum.content);

      emit(CollectionPageLoadedState(collectionPreview, memoriesByDate,
          hasMoreData, _dateGranularityIndex, false));
    } catch (e) {
      // Emit error state if an error occurs
      emit(CollectionPageErrorState('Failed to fetch collection data: $e'));
    }
  }

  void addNewMemory(PrivateMemory memory) {
    String displayDate = _getDisplayDate(memory.date);
    if (memoriesByDate.containsKey(displayDate)) {
      memoriesByDate[displayDate]!.insert(0, memory);
      includedImages.add(memory.memoryId);
    } else {
      memoriesByDate[displayDate] = [memory];
      includedImages.add(memory.memoryId);
    }
    //true ?
    emit(CollectionPageLoadedState(collectionPreview, memoriesByDate,
        hasMoreData, _dateGranularityIndex, false));
  }

  void removeMemory(String date, PrivateMemory memoryToRemove) {
    for (int i = 0; i < memoriesByDate[date]!.length; i++) {
      if (memoriesByDate[date]![i].memoryId == memoryToRemove.memoryId) {
        memoriesByDate[date]!.removeAt(i);
        includedImages.remove(memoryToRemove.memoryId);
        break;
      }
    }
    emit(CollectionPageLoadedState(collectionPreview, memoriesByDate,
        hasMoreData, _dateGranularityIndex, false));
  }

  void deleteCollection() {
    emit(CollectionPageLoadedState(collectionPreview, memoriesByDate,
        hasMoreData, _dateGranularityIndex, true));
    collectionRepository.deleteCollection(albumId, collectionId);
    emit(CollectionPageDeletedState());
  }

//   void _getNextPageOfMemories(
//     NextDatasetTimelineFetched event, Emitter<TimelineState> emit) async {
//   //emit(TimelineLoadingState());
//   albumId = event.albumId;
//   PaginatedResponse<Memory> memories =
//       await memoryRepository.getMemoriesForTimeline(albumId, page);
//   if (memories.last) {
//     hasMoreData = false;
//   }
//   page++;
//   _addToPhotoMap(memories.content);

//   emit(CollectionPageLoadedState(
//       collection
//       photosByDate: photosByDate,
//       hasMoreData: hasMoreData,
//       granularityIndex: _dateGranularityIndex));
// }

  void increaseGranularity() async {
    if (_dateGranularityIndex < _granularities.length - 1) {
      _dateGranularityIndex++;
      Map<String, List<PrivateMemory>> newPhotosByDate = {};
      for (String key in memoriesByDate.keys) {
        for (PrivateMemory element in memoriesByDate[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      memoriesByDate = newPhotosByDate;
      emit(CollectionPageLoadedState(collectionPreview, memoriesByDate,
          hasMoreData, _dateGranularityIndex, false));
    }
  }

  void decreaseGranularity() {
    if (_dateGranularityIndex > 0) {
      _dateGranularityIndex--;
      Map<String, List<PrivateMemory>> newPhotosByDate = {};
      for (String key in memoriesByDate.keys) {
        for (PrivateMemory element in memoriesByDate[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      memoriesByDate = newPhotosByDate;
      emit(CollectionPageLoadedState(collectionPreview, memoriesByDate,
          hasMoreData, _dateGranularityIndex, false));
    }
  }

//   PaginatedResponse<Memory> memories =
//       await memoryRepository.getMemoriesForTimeline(albumId, page);
//   if (memories.last) {
//     hasMoreData = false;
//   }
//   page++;
//   _addToPhotoMap(memories.content);

//   emit(TimelineLoadedState(
//       albumId: albumId,
//       photosByDate: photosByDate,
//       hasMoreData: hasMoreData,
//       granularityIndex: _dateGranularityIndex));
// }

//------------------------------------------------------------------------------------------------------//
  void _addToPhotoMap(List<PrivateCollectionMemory> entries) {
    for (PrivateCollectionMemory element in entries) {
      String displayDate = _getDisplayDate(element.addedToCollectionDate);
      if (memoriesByDate.containsKey(displayDate)) {
        if (!includedImages.contains(element.memory.memoryId)) {
          memoriesByDate[displayDate]!.add(element.memory);
          includedImages.add(element.memory.memoryId);
        }
      } else {
        memoriesByDate[displayDate] = [element.memory];
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

  void addExistingMemories(List<PrivateMemory> memories) {}
}
