import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

part 'private-album_event.dart';
part 'private-album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final PrivateAlbumRepository albumRepository;

  late PrivateAlbumInfo albumInfo;
  List<SimpleUser> contributors = [];

  AlbumBloc({required this.albumRepository}) : super(AlbumInitialState()) {
    on<AlbumFetched>(_getAlbumInitialLoad);
    on<RemoveUserFromAlbumInitiated>(_removeUserFromAlbum);
    on<Refresh>(_refreshAlbumInfoPage);
  }

  //fetch album header and initial load of photos ordered by timeline
  void _getAlbumInitialLoad(
      AlbumFetched event, Emitter<AlbumState> emit) async {
    emit(AlbumLoadingState());
    albumInfo = await albumRepository.getAlbumHeaderInfo(event.albumId);
    contributors
        .addAll(await albumRepository.getContributorsOfAlbum(event.albumId));
    emit(
      AlbumLoadedState(
          albumInfo: albumInfo,
          contributors: contributors,
          isAsyncActionRunning: false),
    );
  }

  FutureOr<void> _removeUserFromAlbum(
      RemoveUserFromAlbumInitiated event, Emitter<AlbumState> emit) async {
    if (StorageService().userId == event.userId) {
      emit(
        AlbumLoadedState(
            albumInfo: albumInfo,
            contributors: contributors,
            isAsyncActionRunning: true),
      );

      await albumRepository.removeUserFromAlbum(
          albumInfo.albumId, event.userId);
      emit(LeavedAlbumState());
      return;
    }

    if (albumInfo.owner.userId == StorageService().userId) {
      emit(
        AlbumLoadedState(
            albumInfo: albumInfo,
            contributors: contributors,
            isAsyncActionRunning: true),
      );
      await albumRepository.removeUserFromAlbum(
          albumInfo.albumId, event.userId);
      for (int i = 0; i < contributors.length; i++) {
        if (contributors[i].userId == event.userId) {
          contributors.removeAt(i);
          break;
        }
      }
      emit(
        AlbumLoadedState(
            albumInfo: albumInfo,
            contributors: contributors,
            isAsyncActionRunning: false),
      );
    }
  }

  FutureOr<void> _refreshAlbumInfoPage(
      Refresh event, Emitter<AlbumState> emit) async {
    contributors = [];
    albumInfo = await albumRepository.getAlbumHeaderInfo(albumInfo.albumId);
    contributors.addAll(
        await albumRepository.getContributorsOfAlbum(albumInfo.albumId));
    emit(
      AlbumLoadedState(
          albumInfo: albumInfo,
          contributors: contributors,
          isAsyncActionRunning: false),
    );
  }
}
