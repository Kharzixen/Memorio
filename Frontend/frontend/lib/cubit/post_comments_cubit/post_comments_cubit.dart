import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/post_comment_repository.dart';
import 'package:frontend/model/private-album_model.dart';

part 'post_comments_state.dart';

class PostCommentsCubit extends Cubit<PostCommentsState> {
  final PostCommentRepository commentRepository;
  late List<Comment> comments = [];
  late String postId;

  PostCommentsCubit(this.commentRepository) : super(PostCommentsInitialState());

  void loadComments(String postId) async {
    try {
      this.postId = postId;
      emit(PostCommentsLoadingState());
      comments = await commentRepository.findAllCommentsOfPost(postId);
      emit(PostCommentsLoadedState(comments, false));
    } catch (e) {
      emit(PostCommentsErrorState(e.toString()));
    }
  }

  void createNewCommentForPost(
      String userId, String postId, String message) async {
    try {
      emit(PostCommentsLoadedState(comments, true));
      Comment comment = await commentRepository.createNewCommentForPost(
          userId, postId, message);
      comments.insert(0, comment);
      emit(PostCommentsLoadedState(comments, false));
    } catch (e) {
      emit(PostCommentsErrorState(e.toString()));
    }
  }

  void deleteComment(int index) async {
    try {
      emit(PostCommentsLoadedState(comments, true));
      bool isDeletedSuccessfully = await commentRepository
          .deleteCommentFromPost(postId, comments[index].id);
      if (isDeletedSuccessfully) {
        comments.removeAt(index);
        emit(PostCommentsLoadedState(comments, false));
      } else {
        throw Exception("Unsuccessful deletion");
      }
    } catch (e) {
      emit(PostCommentsErrorState(e.toString()));
    }
  }
}
