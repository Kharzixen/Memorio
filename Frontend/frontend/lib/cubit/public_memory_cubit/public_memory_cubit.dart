import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/public_memory_repository.dart';
import 'package:frontend/model/memory_model.dart';

part 'public_memory_state.dart';

class PublicMemoryCubit extends Cubit<PublicMemoryState> {
  PublicMemoryRepository publicMemoryRepository;
  PublicMemoryCubit(this.publicMemoryRepository)
      : super(PublicMemoryInitialState());

  late String albumId;
  late String memoryId;

  void fetchMemory(String albumId, String memoryId) async {
    try {
      this.albumId = albumId;
      this.memoryId = memoryId;
      emit(PublicMemoryLoadingState());
      DetailedPublicMemory memory =
          await publicMemoryRepository.getMemoryById(albumId, memoryId);
      emit(PublicMemoryLoadedState(memory, false));
    } catch (e) {
      emit(PublicMemoryErrorState(e.toString()));
    }
  }

  void like() {}

  void deleteMemory() async {
    try {
      await publicMemoryRepository.deleteMemory(albumId, memoryId);
      emit(PublicMemoryDeletedState());
    } catch (e) {
      emit(PublicMemoryErrorState(e.toString()));
    }
  }

  void highlightMemory(String albumId, String memoryId) async {
    try {
      DetailedPublicMemory memory = await publicMemoryRepository
          .changeHighlightStatusOfMemory(albumId, memoryId, true);
      emit(PublicMemoryLoadedState(memory, false));
    } catch (e) {
      emit(PublicMemoryErrorState(e.toString()));
    }
  }

  void removeMemoryFromHighlights(String albumId, String memoryId) async {
    try {
      DetailedPublicMemory memory = await publicMemoryRepository
          .changeHighlightStatusOfMemory(albumId, memoryId, false);
      emit(PublicMemoryLoadedState(memory, false));
    } catch (e) {
      emit(PublicMemoryErrorState(e.toString()));
    }
  }

  // void deletePost() async {
  //   try {
  //     emit(PostLoadedState(post, true));
  //     await postRepository.delePost(post.postId);
  //     emit(PostDeletedState());
  //   } catch (e) {
  //     emit(PostErrorState(e.toString()));
  //   }
  // }

  // void likePost(String userId, String postId) {
  //   postLikeRepository.createNewLikeForPost(userId, postId);
  //   post.isLikedByUser = true;
  //   emit(PostLoadedState(post, false));
  // }

  // void dislikePost(String userId, String postId) {
  //   postLikeRepository.deleteLike(userId, postId);
  //   post.isLikedByUser = false;
  //   emit(PostLoadedState(post, false));
  // }
}
