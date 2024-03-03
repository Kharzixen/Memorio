import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/model/album_model.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  String currentState = "timeline";

  final List<String> _granularities = ["all", "year", "month", "day"];
  int _dateGranularityIndex = 2;

  int timelinePage = 1;
  bool timelineHasMoreData = true;
  bool collectionHasMoreData = true;
  bool timelineFirstFetch = true;
  bool collectionFirstFetch = true;
  int fooCounter = 0;

  late AlbumHeaderInfo albumInfo;
  Map<String, List<Moment>> photosByDate = {};
  List<CollectionPreview> collections = [];
  int collectionPage = 1;

  double timelinePosition = 0.0;
  double collectionsPosition = 0.0;

  AlbumBloc({required this.albumRepository}) : super(AlbumInitialState()) {
    on<AlbumFetched>(_getAlbumInitialLoad);
    on<AlbumDisplayChangedToCollection>(_changeToCollection);
    on<AlbumDisplayChangedToTimeline>(_changeToTimeline);
    on<AlbumTimelineNewChunkFetched>(_getNextPageTimeline);
    on<IncreaseGranularity>(_increaseGranularity);
    on<DecreaseGranularity>(_decreaseGranularity);
  }

  //fetch album header and initial load of photos ordered by timeline
  void _getAlbumInitialLoad(
      AlbumFetched event, Emitter<AlbumState> emit) async {
    emit(AlbumLoadingState());
    albumInfo = await albumRepository.getAlbumHeaderInfo(event.albumId);
    emit(
      AlbumLoadedState(
        content: currentState,
        albumInfo: albumInfo,
        animationEnabled: false,
        timelineHasMoreData: timelineHasMoreData,
        collectionHasMoreData: collectionHasMoreData,
        photosByDate: photosByDate,
        collections: collections,
        timelinePosition: timelinePosition,
        collectionsPosition: collectionsPosition,
        timelineFirstFetch: timelineFirstFetch,
        collectionFirstFetch: collectionFirstFetch,
      ),
    );
    List<Moment> entries =
        await albumRepository.getEntriesByTimeline(event.albumId, 0);
    _addToPhotoMap(entries);
    if (timelineFirstFetch) {
      timelineFirstFetch = false;
    }
    if (currentState == "timeline") {
      emit(AlbumLoadedState(
        content: currentState,
        albumInfo: albumInfo,
        animationEnabled: false,
        timelineHasMoreData: timelineHasMoreData,
        collectionHasMoreData: collectionHasMoreData,
        photosByDate: photosByDate,
        collections: collections,
        timelinePosition: timelinePosition,
        collectionsPosition: collectionsPosition,
        timelineFirstFetch: timelineFirstFetch,
        collectionFirstFetch: collectionFirstFetch,
      ));
    }
  }

  //change to collection
  void _changeToCollection(
      AlbumDisplayChangedToCollection event, Emitter<AlbumState> emit) async {
    switch (event.contentBefore) {
      case "timeline":
        timelinePosition = event.position;
    }
    currentState = "collection";
    emit(AlbumLoadedState(
      content: currentState,
      albumInfo: albumInfo,
      animationEnabled: false,
      timelineHasMoreData: timelineHasMoreData,
      collectionHasMoreData: collectionHasMoreData,
      photosByDate: photosByDate,
      collections: collections,
      timelinePosition: timelinePosition,
      collectionsPosition: collectionsPosition,
      timelineFirstFetch: timelineFirstFetch,
      collectionFirstFetch: collectionFirstFetch,
    ));
    if (collections.isEmpty) {
      collections
          .addAll(await albumRepository.getCollections(albumInfo.albumId, 0));
    }
    if (collectionFirstFetch) {
      collectionFirstFetch = false;
    }
    emit(AlbumLoadedState(
      content: currentState,
      albumInfo: albumInfo,
      animationEnabled: false,
      timelineHasMoreData: timelineHasMoreData,
      collectionHasMoreData: collectionHasMoreData,
      photosByDate: photosByDate,
      collections: collections,
      timelinePosition: timelinePosition,
      collectionsPosition: collectionsPosition,
      timelineFirstFetch: timelineFirstFetch,
      collectionFirstFetch: collectionFirstFetch,
    ));
  }

  //change to timeline
  void _changeToTimeline(
      AlbumDisplayChangedToTimeline event, Emitter<AlbumState> emit) async {
    switch (event.contentBefore) {
      case "collection":
        collectionsPosition = event.position;
    }
    currentState = "timeline";
    emit(AlbumLoadedState(
      content: currentState,
      albumInfo: albumInfo,
      animationEnabled: false,
      timelineHasMoreData: timelineHasMoreData,
      collectionHasMoreData: collectionHasMoreData,
      photosByDate: photosByDate,
      collections: collections,
      timelinePosition: timelinePosition,
      collectionsPosition: collectionsPosition,
      timelineFirstFetch: timelineFirstFetch,
      collectionFirstFetch: collectionFirstFetch,
    ));
  }

  //get next batch of data for timeline
  void _getNextPageTimeline(
      AlbumTimelineNewChunkFetched event, Emitter<AlbumState> emit) async {
    if (fooCounter < 3 && timelineHasMoreData) {
      // emit(AlbumTimelineNextPageLoading(
      //     albumHeaderInfo: albumInfo, earlierEntries: entriesForTimeline));

      List<Moment> entries = await albumRepository.getEntriesByTimeline(
          event.albumId, timelinePage);
      timelinePage++;
      if (entries.isEmpty || entries.length < 6) {
        timelineHasMoreData = false;
      }
      _addToPhotoMap(entries);

      if (currentState == "timeline") {
        emit(AlbumLoadedState(
          content: currentState,
          albumInfo: albumInfo,
          animationEnabled: false,
          timelineHasMoreData: timelineHasMoreData,
          collectionHasMoreData: collectionHasMoreData,
          photosByDate: photosByDate,
          collections: collections,
          timelinePosition: timelinePosition,
          collectionsPosition: collectionsPosition,
          timelineFirstFetch: timelineFirstFetch,
          collectionFirstFetch: collectionFirstFetch,
        ));
      }
    }
  }

  void _increaseGranularity(
      IncreaseGranularity event, Emitter<AlbumState> emit) async {
    if (_dateGranularityIndex < _granularities.length - 1) {
      _dateGranularityIndex++;
      Map<String, List<Moment>> newPhotosByDate = {};
      for (String key in photosByDate.keys) {
        for (Moment element in photosByDate[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      photosByDate = newPhotosByDate;
      emit(AlbumLoadedState(
        content: currentState,
        albumInfo: albumInfo,
        animationEnabled: true,
        timelineHasMoreData: timelineHasMoreData,
        collectionHasMoreData: collectionHasMoreData,
        photosByDate: photosByDate,
        collections: collections,
        timelinePosition: timelinePosition,
        collectionsPosition: collectionsPosition,
        timelineFirstFetch: timelineFirstFetch,
        collectionFirstFetch: collectionFirstFetch,
      ));
    }
  }

  void _decreaseGranularity(
      DecreaseGranularity event, Emitter<AlbumState> emit) {
    if (_dateGranularityIndex > 0) {
      _dateGranularityIndex--;
      Map<String, List<Moment>> newPhotosByDate = {};
      for (String key in photosByDate.keys) {
        for (Moment element in photosByDate[key]!) {
          String displayDate = _getDisplayDate(element.date);
          if (newPhotosByDate.containsKey(displayDate)) {
            newPhotosByDate[displayDate]!.add(element);
          } else {
            newPhotosByDate[displayDate] = [element];
          }
        }
      }
      photosByDate = newPhotosByDate;
      emit(AlbumLoadedState(
        content: currentState,
        albumInfo: albumInfo,
        animationEnabled: true,
        timelineHasMoreData: timelineHasMoreData,
        collectionHasMoreData: collectionHasMoreData,
        photosByDate: photosByDate,
        collections: collections,
        timelinePosition: timelinePosition,
        collectionsPosition: collectionsPosition,
        timelineFirstFetch: timelineFirstFetch,
        collectionFirstFetch: collectionFirstFetch,
      ));
    }
  }

  //------------------------------------------------------------------------
  // aux methods
  //------------------------------------------------------------------------

  void _addToPhotoMap(List<Moment> entries) {
    for (Moment element in entries) {
      String displayDate = _getDisplayDate(element.date);
      if (photosByDate.containsKey(displayDate)) {
        photosByDate[displayDate]!.add(element);
      } else {
        photosByDate[displayDate] = [element];
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
