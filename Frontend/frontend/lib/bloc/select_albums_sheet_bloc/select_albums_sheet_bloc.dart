import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/model/album_model.dart';

part 'select_albums_sheet_state.dart';
part 'select_albums_sheet_event.dart';

class SelectAlbumsSheetBloc
    extends Bloc<SelectAlbumsSheetEvent, SelectAlbumsSheetState> {
  AlbumRepository albumRepository;

  int page = 0;
  int pageSize = 10;
  String userId = "";
  bool hasMoreData = true;

  Map<String, SimpleAlbum> albums = {};
  Map<String, SimpleAlbum> includedAlbums = {};

  List<SimpleAlbum> initiallyIncludedAlbums = [];

  SelectAlbumsSheetBloc(
      {required this.albumRepository, required this.initiallyIncludedAlbums})
      : super(SelectAlbumsSheetInitialState()) {
    for (SimpleAlbum initiallyIncludedAlbum in initiallyIncludedAlbums) {
      includedAlbums[initiallyIncludedAlbum.albumId] = initiallyIncludedAlbum;
    }
    on<NextAlbumsDatasetFetched>(_fetchNextDataset);
    on<AlbumAddedToIncluded>(_addAlbumToIncluded);
    on<AlbumRemovedFromIncluded>(_removeAlbumFromIncluded);
  }

  FutureOr<void> _fetchNextDataset(NextAlbumsDatasetFetched event,
      Emitter<SelectAlbumsSheetState> emit) async {
    userId = event.userId;
    if (hasMoreData) {
      // PaginatedResponse<AlbumPreview> newAlbums =
      //     await albumRepository.getAlbumPreviewOfUser(userId);
      List<AlbumPreview> albums =
          await albumRepository.getAlbumPreviewOfUser(userId);
      hasMoreData = false;
      page++;
      addToAlbums(albums.map((e) => SimpleAlbum.fromAlbumPreview(e)).toList());
    }
    List<String> idsToRemove = [];
    for (SimpleAlbum album in includedAlbums.values) {
      if (!event.includedAlbums.contains(album)) {
        idsToRemove.add(album.albumId);
        albums[album.albumId] = album;
      }
    }
    for (String id in idsToRemove) {
      includedAlbums.remove(id);
    }
    emit(SelectAlbumsSheetLoadedState(
        userId: userId,
        albums: albums,
        includedAlbums: includedAlbums,
        hasMoreData: hasMoreData));
  }

  void addToAlbums(List<SimpleAlbum> albumList) {
    for (SimpleAlbum album in albumList) {
      if (!initiallyIncludedAlbums.contains(album)) {
        albums[album.albumId] = album;
      }
    }
  }

  FutureOr<void> _addAlbumToIncluded(
      AlbumAddedToIncluded event, Emitter<SelectAlbumsSheetState> emit) {
    SimpleAlbum simpleAlbum = albums[event.albumId]!;
    albums.remove(event.albumId);
    includedAlbums[simpleAlbum.albumId] = simpleAlbum;
    emit(SelectAlbumsSheetLoadedState(
        userId: userId,
        albums: albums,
        includedAlbums: includedAlbums,
        hasMoreData: hasMoreData));
  }

  FutureOr<void> _removeAlbumFromIncluded(
      AlbumRemovedFromIncluded event, Emitter<SelectAlbumsSheetState> emit) {
    SimpleAlbum simpleAlbum = includedAlbums[event.albumId]!;
    includedAlbums.remove(simpleAlbum.albumId);
    albums[simpleAlbum.albumId] = simpleAlbum;
    emit(SelectAlbumsSheetLoadedState(
        userId: userId,
        albums: albums,
        includedAlbums: includedAlbums,
        hasMoreData: hasMoreData));
  }
}
