import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/model/album_model.dart';

part 'albums_preview_event.dart';
part 'albums_preview_state.dart';

class AlbumsPreviewBloc extends Bloc<AlbumPreviewEvent, AlbumsPreviewState> {
  final AlbumRepository albumRepository;
  List<AlbumPreview> albumPreview = [];
  String userId = "";

  AlbumsPreviewBloc(this.albumRepository) : super(AlbumsPreviewInitialState()) {
    on<AlbumsPreviewFetched>(_getAlbumPreview);
    on<AlbumsRefreshRequested>(_refreshAlbumsPage);
    on<AlbumLeaved>(_removeAlbumFromList);
    on<NewImageCreatedForAlbum>(_addToImagePreviewsNewImage);
    on<LeaveAlbum>(_leaveAlbum);
  }

  void _getAlbumPreview(
      AlbumsPreviewFetched event, Emitter<AlbumsPreviewState> emit) async {
    emit(AlbumsPreviewLoadingState());
    userId = event.userId;
    try {
      albumPreview.addAll(await albumRepository.getAlbumPreviewOfUser(userId));
      emit(AlbumsPreviewLoadedState(albumPreview, false));
    } catch (e) {
      emit(AlbumsPreviewErrorState(e.toString()));
    }
  }

  FutureOr<void> _refreshAlbumsPage(
      AlbumsRefreshRequested event, Emitter<AlbumsPreviewState> emit) async {
    albumPreview = [];
    albumPreview.addAll(await albumRepository.getAlbumPreviewOfUser(userId));
    emit(AlbumsPreviewLoadedState(albumPreview, false));
  }

  FutureOr<void> _removeAlbumFromList(
      AlbumLeaved event, Emitter<AlbumsPreviewState> emit) {
    for (int i = 0; i < albumPreview.length; i++) {
      if (albumPreview[i].albumId == event.albumId) {
        albumPreview.removeAt(i);
        break;
      }
    }
    emit(AlbumsPreviewLoadedState(albumPreview, false));
  }

  FutureOr<void> _addToImagePreviewsNewImage(
      NewImageCreatedForAlbum event, Emitter<AlbumsPreviewState> emit) {
    for (int i = 0; i < albumPreview.length; i++) {
      if (albumPreview[i].albumId == event.albumId) {
        if (albumPreview[i].previewImages.isEmpty) {
          albumPreview[i].previewImages.add(event.memory);
        } else {
          albumPreview[i].previewImages.insert(0, event.memory);
          albumPreview[i].previewImages.removeLast();
        }
        break;
      }
    }
    emit(AlbumsPreviewLoadedState(albumPreview, false));
  }

  FutureOr<void> _leaveAlbum(
      LeaveAlbum event, Emitter<AlbumsPreviewState> emit) async {
    emit(AlbumsPreviewLoadedState(albumPreview, true));
    await albumRepository.removeUserFromAlbum(event.albumId, userId);
    for (int i = 0; i < albumPreview.length; i++) {
      if (albumPreview[i].albumId == event.albumId) {
        albumPreview.removeAt(i);
        break;
      }
    }
    emit(AlbumsPreviewLoadedState(albumPreview, false));
  }
}
