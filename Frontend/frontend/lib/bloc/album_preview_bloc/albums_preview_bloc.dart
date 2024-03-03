import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/model/album_model.dart';

part 'albums_preview_event.dart';
part 'albums_preview_state.dart';

class AlbumsPreviewBloc extends Bloc<AlbumPreviewEvent, AlbumsPreviewState> {
  final AlbumRepository albumRepository;
  AlbumsPreviewBloc(this.albumRepository) : super(AlbumsPreviewInitialState()) {
    on<AlbumsPreviewFetched>(_getAlbumPreview);
  }

  void _getAlbumPreview(
      AlbumsPreviewFetched event, Emitter<AlbumsPreviewState> emit) async {
    emit(AlbumsPreviewLoadingState());
    final List<AlbumPreview> albumPreview =
        await albumRepository.getAlbumPreviewById(event.userId);
    emit(AlbumsPreviewLoadedState(albumPreview));
  }
}
