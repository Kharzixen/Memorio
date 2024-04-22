import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/model/album_model.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  late AlbumInfo albumInfo;

  AlbumBloc({required this.albumRepository}) : super(AlbumInitialState()) {
    on<AlbumFetched>(_getAlbumInitialLoad);
  }

  //fetch album header and initial load of photos ordered by timeline
  void _getAlbumInitialLoad(
      AlbumFetched event, Emitter<AlbumState> emit) async {
    emit(AlbumLoadingState());
    albumInfo = await albumRepository.getAlbumHeaderInfo(event.albumId);
    emit(
      AlbumLoadedState(
        albumInfo: albumInfo,
      ),
    );
  }
}
