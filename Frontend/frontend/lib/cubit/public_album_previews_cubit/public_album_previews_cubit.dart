import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';

part 'public_album_previews_state.dart';

class PublicAlbumPreviewsCubit extends Cubit<PublicAlbumPreviewsState> {
  final PublicAlbumRepository albumRepository;
  List<PublicAlbumPreview> albumPreview = [];
  String userId = "";

  PublicAlbumPreviewsCubit(this.albumRepository)
      : super(PublicAlbumPreviewsInitialState()) {}

  void loadAlbumPreview(String userId) async {
    emit(PublicAlbumPreviewsLoadingState());
    this.userId = userId;
    try {
      albumPreview.addAll(await albumRepository.getAlbumPreviewOfUser(userId));
      emit(PublicAlbumPreviewsLoadedState(albumPreview));
    } catch (e) {
      emit(PublicAlbumPreviewsErrorState(e.toString()));
    }
  }

  void addNewMemory(String albumId, PublicMemory publicMemory) {}

  void refresh() async {
    albumPreview = [];
    try {
      albumPreview.addAll(await albumRepository.getAlbumPreviewOfUser(userId));
      emit(PublicAlbumPreviewsLoadedState(albumPreview));
    } catch (e) {
      emit(PublicAlbumPreviewsErrorState(e.toString()));
    }
  }

  void removeAlbumFromList(String albumId) {
    for (int i = 0; i < albumPreview.length; i++) {
      if (albumPreview[i].albumId == albumId) {
        albumPreview.removeAt(i);
        break;
      }
    }
    emit(PublicAlbumPreviewsLoadedState(albumPreview));
  }

  void addToImagePreviewsNewImage(String albumId, PublicMemory memory) {
    for (int i = 0; i < albumPreview.length; i++) {
      if (albumPreview[i].albumId == albumId) {
        if (albumPreview[i].previewImages.isEmpty) {
          albumPreview[i].previewImages.add(memory);
        } else {
          albumPreview[i].previewImages.insert(0, memory);
          albumPreview[i].previewImages.removeLast();
        }
        break;
      }
    }
    emit(PublicAlbumPreviewsLoadedState(albumPreview));
  }

  void leaveAlbum(String albumId) async {
    emit(PublicAlbumPreviewsLoadedState(albumPreview));
    await albumRepository.removeUserFromAlbum(albumId, userId);
    for (int i = 0; i < albumPreview.length; i++) {
      if (albumPreview[i].albumId == albumId) {
        albumPreview.removeAt(i);
        break;
      }
    }
    emit(PublicAlbumPreviewsLoadedState(albumPreview));
  }
}
