import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/memory_like_repository.dart';
import 'package:frontend/model/like_model.dart';

part 'private_memory_likes_state.dart';

class PrivateMemoryLikesCubit extends Cubit<PrivateMemoryLikesState> {
  final MemoryLikeRepository likeRepository;
  late List<LikeModel> likes = [];

  PrivateMemoryLikesCubit(this.likeRepository)
      : super(PrivateMemoryLikesInitialState());

  void loadLikes(String albumId, String memoryId) async {
    try {
      emit(PrivateMemoryLikesLoadingState());
      likes = await likeRepository.findAllLikesOfMemory(albumId, memoryId);
      emit(PrivateMemoryLikesLoadedState(likes));
    } catch (e) {
      emit(PrivateMemoryLikesErrorState(e.toString()));
    }
  }
}
