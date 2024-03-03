import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/moment_repository.dart';
import 'package:frontend/model/album_model.dart';

part 'moment_event.dart';
part 'moment_state.dart';

class MomentBloc extends Bloc<MomentEvent, MomentState> {
  final MomentRepository momentRepository;
  late DetailedMoment moment;
  late String contentToShow;

  MomentBloc(this.momentRepository) : super(MomentInitialState()) {
    on<MomentFetched>(_loadMomentById);
    on<ContentChangedToComments>(_changeContentToComments);
    on<ContentChangedToLikes>(_changeContentToLikes);
  }

  void _loadMomentById(MomentFetched event, Emitter<MomentState> emit) async {
    emit(MomentLoadingState());
    moment =
        await momentRepository.getMomentById(event.albumId, event.momentId);
    contentToShow = "comments";
    emit(MomentLoadedState(moment, contentToShow));
  }

  FutureOr<void> _changeContentToComments(
      ContentChangedToComments event, Emitter<MomentState> emit) {
    contentToShow = "comments";
    emit(
        MomentLoadedState(moment, contentToShow));
  }

  FutureOr<void> _changeContentToLikes(
      ContentChangedToLikes event, Emitter<MomentState> emit) {
    contentToShow = "likes";
    emit(
        MomentLoadedState(moment, contentToShow));
  }
}
