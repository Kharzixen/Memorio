import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/memory_repository.dart';
import 'package:frontend/model/album_model.dart';

part 'moment_event.dart';
part 'moment_state.dart';

class MomentBloc extends Bloc<MemoryEvent, MomentState> {
  final MemoryRepository momentRepository;
  late DetailedMemory moment;

  MomentBloc(this.momentRepository) : super(MomentInitialState()) {
    on<MemoryFetched>(_loadMomentById);
    on<MemoryRemoved>(_deleteMomentById);
    on<MemoryCollectionsChanged>(_changeMemoryCollections);
  }

  void _loadMomentById(MemoryFetched event, Emitter<MomentState> emit) async {
    emit(MomentLoadingState());
    moment =
        await momentRepository.getMomentById(event.albumId, event.momentId);
    emit(MomentLoadedState(moment, false));
  }

  void _deleteMomentById(MemoryRemoved event, Emitter<MomentState> emit) async {
    emit(MomentLoadedState(moment, true));
    await momentRepository.deleteMemory(moment.album.albumId, moment.memoryId);
    emit(MomentDeletedState());
  }

  FutureOr<void> _changeMemoryCollections(
      MemoryCollectionsChanged event, Emitter<MomentState> emit) async {
    emit(MomentLoadedState(moment, true));
    await momentRepository.changeCollectionsOfMemory(
        moment.album.albumId, moment.memoryId, event.newCollections);
    moment.collections = event.newCollections;
    emit(MomentLoadedState(moment, false));
  }
}
