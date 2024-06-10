import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';

part 'discover_public_albums_state.dart';

class DiscoverPublicAlbumPreviewsCubit
    extends Cubit<DiscoverPublicAlbumPreviewsState> {
  final PublicAlbumRepository albumRepository;
  List<PublicAlbumPreview> albumPreview = [];
  String userId = "";
  int page = 0;
  int pageSize = 10;

  DiscoverPublicAlbumPreviewsCubit(this.albumRepository)
      : super(DiscoverPublicAlbumPreviewsInitialState());

  void loadAlbumPreview(String userId) async {
    emit(DiscoverPublicAlbumPreviewsLoadingState());
    this.userId = userId;
    try {
      albumPreview.addAll(await albumRepository.getAlbumSuggestionsForUser(
          userId, page, pageSize));
      page++;
      emit(DiscoverPublicAlbumPreviewsLoadedState(albumPreview));
    } catch (e) {
      emit(DiscoverPublicAlbumPreviewsErrorState(e.toString()));
    }
  }

  void addNewPhotoToAlbum(String albumId, PublicMemory data) {
    for (int i = 0; i < albumPreview.length; i++) {
      if (albumPreview[i].albumId == albumId) {
        albumPreview[i].previewImages.insert(0, data);
        emit(DiscoverPublicAlbumPreviewsLoadedState(albumPreview));
        return;
      }
    }
  }

  void refresh() async {
    albumPreview = [];
    page = 0;
    try {
      albumPreview.addAll(await albumRepository.getAlbumSuggestionsForUser(
          userId, page, pageSize));
      page++;
      emit(DiscoverPublicAlbumPreviewsLoadedState(albumPreview));
    } catch (e) {
      emit(DiscoverPublicAlbumPreviewsErrorState(e.toString()));
    }
  }
}
