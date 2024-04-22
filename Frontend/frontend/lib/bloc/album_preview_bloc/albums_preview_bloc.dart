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
  }

  void _getAlbumPreview(
      AlbumsPreviewFetched event, Emitter<AlbumsPreviewState> emit) async {
    emit(AlbumsPreviewLoadingState());
    userId = event.userId;
    try {
      albumPreview.addAll(await albumRepository.getAlbumPreviewOfUser(userId));
      emit(AlbumsPreviewLoadedState(albumPreview));
    } catch (e) {
      emit(AlbumsPreviewErrorState(e.toString()));
    }
  }

  FutureOr<void> _refreshAlbumsPage(
      AlbumsRefreshRequested event, Emitter<AlbumsPreviewState> emit) async {
    albumPreview = [];
    albumPreview.addAll(await albumRepository.getAlbumPreviewOfUser(userId));
    emit(AlbumsPreviewLoadedState(albumPreview));
  }
}
