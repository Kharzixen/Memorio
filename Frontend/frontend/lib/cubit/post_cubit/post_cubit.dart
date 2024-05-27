import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/post_like_repository.dart';
import 'package:frontend/data/repository/post_repository.dart';
import 'package:frontend/model/post_model.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;
  final PostLikeRepository postLikeRepository;
  late Post post;

  PostCubit(this.postRepository, this.postLikeRepository)
      : super(PostInitialState());

  void fetchPost(String postId) async {
    try {
      emit(PostLoadingState());
      post = await postRepository.getPostById(postId);
      emit(PostLoadedState(post, false));
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }

  void deletePost() async {
    try {
      emit(PostLoadedState(post, true));
      await postRepository.delePost(post.postId);
      emit(PostDeletedState());
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }

  void likePost(String userId, String postId) {
    postLikeRepository.createNewLikeForPost(userId, postId);
    emit(PostLoadedState(post, false));
  }
}
