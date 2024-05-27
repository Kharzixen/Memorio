import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/memory_comment_repository.dart';
import 'package:frontend/model/private-album_model.dart';

part 'private_memory_comments.state.dart';

class PrivateMemoryCommentsCubit extends Cubit<PrivateMemoryCommentsState> {
  final MemoryCommentRepository commentRepository;
  late List<Comment> comments = [];
  late String albumId;
  late String memoryId;

  PrivateMemoryCommentsCubit(this.commentRepository)
      : super(PrivateMemoryCommentsInitialState());

  void loadLikes(String albumId, String memoryId) async {
    try {
      this.albumId = albumId;
      this.memoryId = memoryId;
      emit(PrivateMemoryCommentsLoadingState());
      comments =
          await commentRepository.findAllCommentsOfMemory(albumId, memoryId);
      emit(PrivateMemoryCommentsLoadedState(comments, false));
    } catch (e) {
      emit(PrivateMemoryCommentsErrorState(e.toString()));
    }
  }

  void createNewCommentForMemory(
      String albumId, String userId, String memoryId, String message) async {
    try {
      emit(PrivateMemoryCommentsLoadedState(comments, true));
      Comment comment = await commentRepository.createNewCommentForMemory(
          albumId, userId, memoryId, message);
      comments.insert(0, comment);
      emit(PrivateMemoryCommentsLoadedState(comments, false));
    } catch (e) {
      emit(PrivateMemoryCommentsErrorState(e.toString()));
    }
  }

  void deleteComment(int index) async {
    try {
      emit(PrivateMemoryCommentsLoadedState(comments, true));
      bool isDeletedSuccessfully = await commentRepository
          .deleteCommentFromMemory(albumId, memoryId, comments[index].id);
      if (isDeletedSuccessfully) {
        comments.removeAt(index);
        emit(PrivateMemoryCommentsLoadedState(comments, false));
      } else {
        throw Exception("Unsuccessful deletion");
      }
    } catch (e) {
      emit(PrivateMemoryCommentsErrorState(e.toString()));
    }
  }
}
