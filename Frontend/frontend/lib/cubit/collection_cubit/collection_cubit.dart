import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/collection_repository.dart';
import 'package:frontend/data/repository/memory_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'collection_state.dart';

class CollectionPageCubit extends Cubit<CollectionPageState> {
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;

  Map<String, List<Memory>> memoriesByDate = {};
  int page = 0;
  bool hasMoreData = true;

  final List<String> _granularities = ["all", "year", "month", "day"];
  int _dateGranularityIndex = 2;

  late CollectionPreview collectionPreview;
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

      PaginatedResponse<Memory> nextPageMemoriesOfAlbum = await memoryRepository
          .getMemoriesOrderedByDatePaginated(albumId, page, collectionId);
      _addToPhotoMap(nextPageMemoriesOfAlbum.content);

      emit(CollectionPageLoadedState(collectionPreview, memoriesByDate,
          hasMoreData, _dateGranularityIndex));
    } catch (e) {
      // Emit error state if an error occurs
      emit(CollectionPageErrorState('Failed to fetch collection data: $e'));
    }
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
      Map<String, List<Memory>> newPhotosByDate = {};
      for (String key in memoriesByDate.keys) {
        for (Memory element in memoriesByDate[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      memoriesByDate = newPhotosByDate;
      emit(CollectionPageLoadedState(
        collectionPreview,
        memoriesByDate,
        hasMoreData,
        _dateGranularityIndex,
      ));
    }
  }

  void decreaseGranularity() {
    if (_dateGranularityIndex > 0) {
      _dateGranularityIndex--;
      Map<String, List<Memory>> newPhotosByDate = {};
      for (String key in memoriesByDate.keys) {
        for (Memory element in memoriesByDate[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      memoriesByDate = newPhotosByDate;
      emit(CollectionPageLoadedState(
        collectionPreview,
        memoriesByDate,
        hasMoreData,
        _dateGranularityIndex,
      ));
    }
  }

// FutureOr<void> _refreshState(
//     RefreshRequested event, Emitter<TimelineState> emit) async {
//   page = 0;
//   photosByDate = {};
//   hasMoreData = true;

//   _dateGranularityIndex = 2;

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
  void _addToPhotoMap(List<Memory> entries) {
    for (Memory element in entries) {
      String displayDate = _getDisplayDate(element.date);
      if (memoriesByDate.containsKey(displayDate)) {
        memoriesByDate[displayDate]!.add(element);
      } else {
        memoriesByDate[displayDate] = [element];
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
