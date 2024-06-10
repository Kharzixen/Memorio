import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/private-album_model.dart';

part 'select_albums_sheet_state.dart';
part 'select_albums_sheet_event.dart';

class SelectAlbumsSheetBloc
    extends Bloc<SelectAlbumsSheetEvent, SelectAlbumsSheetState> {
  PrivateAlbumRepository albumRepository;

  int page = 0;
  int pageSize = 10;
  String userId = "";
  bool hasMoreData = true;

  Map<String, SimplePrivateAlbum> albums = {};
  Map<String, SimplePrivateAlbum> includedAlbums = {};

  List<SimplePrivateAlbum> initiallyIncludedAlbums = [];

  SelectAlbumsSheetBloc(
      {required this.albumRepository, required this.initiallyIncludedAlbums})
      : super(SelectAlbumsSheetInitialState()) {
    for (SimplePrivateAlbum initiallyIncludedAlbum in initiallyIncludedAlbums) {
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
      List<PrivateAlbumPreview> albums =
          await albumRepository.getAlbumPreviewOfUser(userId);
      hasMoreData = false;
      page++;
      addToAlbums(
          albums.map((e) => SimplePrivateAlbum.fromAlbumPreview(e)).toList());
    }
    List<String> idsToRemove = [];
    for (SimplePrivateAlbum album in includedAlbums.values) {
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

  void addToAlbums(List<SimplePrivateAlbum> albumList) {
    for (SimplePrivateAlbum album in albumList) {
      if (!initiallyIncludedAlbums.contains(album)) {
        albums[album.albumId] = album;
      }
    }
  }

  FutureOr<void> _addAlbumToIncluded(
      AlbumAddedToIncluded event, Emitter<SelectAlbumsSheetState> emit) {
    SimplePrivateAlbum simpleAlbum = albums[event.albumId]!;
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
    SimplePrivateAlbum simpleAlbum = includedAlbums[event.albumId]!;
    includedAlbums.remove(simpleAlbum.albumId);
    albums[simpleAlbum.albumId] = simpleAlbum;
    emit(SelectAlbumsSheetLoadedState(
        userId: userId,
        albums: albums,
        includedAlbums: includedAlbums,
        hasMoreData: hasMoreData));
  }
}
