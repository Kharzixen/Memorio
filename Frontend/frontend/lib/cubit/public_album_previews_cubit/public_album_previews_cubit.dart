import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/model/public_albums.dart';

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

  // FutureOr<void> _refreshAlbumsPage() async {
  //   albumPreview = [];
  //   albumPreview.addAll(await albumRepository.getAlbumPreviewOfUser(userId));
  //   emit(AlbumsPreviewLoadedState(albumPreview, false));
  // }

  // FutureOr<void> _removeAlbumFromList() {
  //   for (int i = 0; i < albumPreview.length; i++) {
  //     if (albumPreview[i].albumId == event.albumId) {
  //       albumPreview.removeAt(i);
  //       break;
  //     }
  //   }
  //   emit(AlbumsPreviewLoadedState(albumPreview, false));
  // }

  // FutureOr<void> _addToImagePreviewsNewImage() {
  //   for (int i = 0; i < albumPreview.length; i++) {
  //     if (albumPreview[i].albumId == event.albumId) {
  //       if (albumPreview[i].previewImages.isEmpty) {
  //         albumPreview[i].previewImages.add(event.memory);
  //       } else {
  //         albumPreview[i].previewImages.insert(0, event.memory);
  //         albumPreview[i].previewImages.removeLast();
  //       }
  //       break;
  //     }
  //   }
  //   emit(AlbumsPreviewLoadedState(albumPreview, false));
  // }

  // FutureOr<void> _leaveAlbum() async {
  //   emit(AlbumsPreviewLoadedState(albumPreview, true));
  //   await albumRepository.removeUserFromAlbum(event.albumId, userId);
  //   for (int i = 0; i < albumPreview.length; i++) {
  //     if (albumPreview[i].albumId == event.albumId) {
  //       albumPreview.removeAt(i);
  //       break;
  //     }
  //   }
  //   emit(AlbumsPreviewLoadedState(albumPreview, false));
  // }
}
