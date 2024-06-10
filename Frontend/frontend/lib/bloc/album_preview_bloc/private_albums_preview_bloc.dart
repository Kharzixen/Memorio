import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';

part 'private_albums_preview_event.dart';
part 'private_albums_preview_state.dart';

class PrivateAlbumsPreviewBloc
    extends Bloc<PrivateAlbumPreviewEvent, AlbumsPreviewState> {
  final PrivateAlbumRepository albumRepository;
  List<PrivateAlbumPreview> albumPreview = [];
  String userId = "";

  PrivateAlbumsPreviewBloc(this.albumRepository)
      : super(AlbumsPreviewInitialState()) {
    on<PrivateAlbumsPreviewFetched>(_getAlbumPreview);
    on<PrivateAlbumsRefreshRequested>(_refreshAlbumsPage);
    on<PrivateAlbumLeaved>(_removeAlbumFromList);
    on<PrivateNewImageCreatedForAlbum>(_addToImagePreviewsNewImage);
    on<PrivateLeaveAlbum>(_leaveAlbum);
  }

  void _getAlbumPreview(PrivateAlbumsPreviewFetched event,
      Emitter<AlbumsPreviewState> emit) async {
    emit(AlbumsPreviewLoadingState());
    userId = event.userId;
    try {
      albumPreview.addAll(await albumRepository.getAlbumPreviewOfUser(userId));
      emit(AlbumsPreviewLoadedState(albumPreview, false));
    } catch (e) {
      emit(AlbumsPreviewErrorState(e.toString()));
    }
  }

  FutureOr<void> _refreshAlbumsPage(PrivateAlbumsRefreshRequested event,
      Emitter<AlbumsPreviewState> emit) async {
    albumPreview = [];
    albumPreview.addAll(await albumRepository.getAlbumPreviewOfUser(userId));
    emit(AlbumsPreviewLoadedState(albumPreview, false));
  }

  FutureOr<void> _removeAlbumFromList(
      PrivateAlbumLeaved event, Emitter<AlbumsPreviewState> emit) {
    for (int i = 0; i < albumPreview.length; i++) {
      if (albumPreview[i].albumId == event.albumId) {
        albumPreview.removeAt(i);
        break;
      }
    }
    emit(AlbumsPreviewLoadedState(albumPreview, false));
  }

  FutureOr<void> _addToImagePreviewsNewImage(
      PrivateNewImageCreatedForAlbum event, Emitter<AlbumsPreviewState> emit) {
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
      PrivateLeaveAlbum event, Emitter<AlbumsPreviewState> emit) async {
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
