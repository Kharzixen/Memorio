import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

part 'public_album_state.dart';

class PublicAlbumCubit extends Cubit<PublicAlbumState> {
  final PublicAlbumRepository albumRepository;

  late PublicAlbumInfo albumInfo;
  List<SimpleUser> contributors = [];
  PublicAlbumCubit({required this.albumRepository})
      : super(PublicAlbumInitialState());

  //fetch album header and initial load of photos ordered by timeline
  void getAlbumInitialLoad(String albumId) async {
    emit(PublicAlbumLoadingState());
    albumInfo = await albumRepository.getAlbumHeaderInfo(albumId);
    contributors.addAll(await albumRepository.getContributorsOfAlbum(albumId));
    emit(
      PublicAlbumLoadedState(
          albumInfo: albumInfo,
          contributors: contributors,
          isAsyncActionRunning: false),
    );
  }

  FutureOr<void> removeUserFromAlbum(String userId) async {
    if (StorageService().userId == userId) {
      emit(
        PublicAlbumLoadedState(
            albumInfo: albumInfo,
            contributors: contributors,
            isAsyncActionRunning: true),
      );

      await albumRepository.removeUserFromAlbum(albumInfo.albumId, userId);
      emit(LeavedPublicAlbumState());
      return;
    }

    if (albumInfo.owner.userId == StorageService().userId) {
      emit(
        PublicAlbumLoadedState(
            albumInfo: albumInfo,
            contributors: contributors,
            isAsyncActionRunning: true),
      );
      await albumRepository.removeUserFromAlbum(albumInfo.albumId, userId);
      for (int i = 0; i < contributors.length; i++) {
        if (contributors[i].userId == userId) {
          contributors.removeAt(i);
          break;
        }
      }
      emit(
        PublicAlbumLoadedState(
            albumInfo: albumInfo,
            contributors: contributors,
            isAsyncActionRunning: false),
      );
    }
  }

  FutureOr<void> refreshAlbumInfoPage() async {
    contributors = [];
    albumInfo = await albumRepository.getAlbumHeaderInfo(albumInfo.albumId);
    contributors.addAll(
        await albumRepository.getContributorsOfAlbum(albumInfo.albumId));
    emit(
      PublicAlbumLoadedState(
          albumInfo: albumInfo,
          contributors: contributors,
          isAsyncActionRunning: false),
    );
  }
}
