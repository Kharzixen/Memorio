import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/post_like_repository.dart';
import 'package:frontend/model/like_model.dart';

part 'post_likes_state.dart';

class PostLikesCubit extends Cubit<PostLikesState> {
  final PostLikeRepository likeRepository;
  late List<LikeModel> likes = [];

  PostLikesCubit(this.likeRepository) : super(PostLikesInitialState());

  void loadLikes(String postId) async {
    try {
      emit(PostLikesLoadingState());
      likes = await likeRepository.findAllLikesOfPost(postId);
      emit(PostLikesLoadedState(likes));
    } catch (e) {
      emit(PostLikesErrorState(e.toString()));
    }
  }
}
