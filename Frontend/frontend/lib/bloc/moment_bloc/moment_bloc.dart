import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/memory_like_repository.dart';
import 'package:frontend/data/repository/private_memory_repository.dart';
import 'package:frontend/model/like_model.dart';
import 'package:frontend/model/private-album_model.dart';

part 'moment_event.dart';
part 'moment_state.dart';

class MomentBloc extends Bloc<MemoryEvent, MomentState> {
  final PrivateMemoryRepository momentRepository;
  final MemoryLikeRepository likeRepository;
  late DetailedPrivateMemory moment;

  MomentBloc(this.momentRepository, this.likeRepository)
      : super(MomentInitialState()) {
    on<MemoryFetched>(_loadMomentById);
    on<MemoryRemoved>(_deleteMomentById);
    on<MemoryCollectionsChanged>(_changeMemoryCollections);
    on<MomentLikedByUser>(_likeMoment);
  }

  void _loadMomentById(MemoryFetched event, Emitter<MomentState> emit) async {
    emit(MomentLoadingState());
    moment =
        await momentRepository.getMomentById(event.albumId, event.momentId);
    emit(MomentLoadedState(moment, false));
  }

  void _deleteMomentById(MemoryRemoved event, Emitter<MomentState> emit) async {
    try {
      emit(MomentLoadedState(moment, true));
      await momentRepository.deleteMemory(
          moment.album.albumId, moment.memoryId);
      emit(MomentDeletedState());
    } catch (e) {
      emit(MomentErrorState(e.toString()));
    }
  }

  FutureOr<void> _changeMemoryCollections(
      MemoryCollectionsChanged event, Emitter<MomentState> emit) async {
    emit(MomentLoadedState(moment, true));
    await momentRepository.changeCollectionsOfMemory(
        moment.album.albumId, moment.memoryId, event.newCollections);
    moment.collections = event.newCollections;
    emit(MomentLoadedState(moment, false));
  }

  FutureOr<void> _likeMoment(
      MomentLikedByUser event, Emitter<MomentState> emit) async {
    LikeModel like = await likeRepository.createNewLikeForMemory(
        moment.album.albumId, event.userId, event.memoryId);
    print(like);
    emit(MomentLoadedState(moment, false));
  }
}
