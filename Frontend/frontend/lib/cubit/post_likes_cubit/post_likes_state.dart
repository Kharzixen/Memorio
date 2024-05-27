part of 'post_likes_cubit.dart';

sealed class PostLikesState {}

class PostLikesInitialState extends PostLikesState {}

class PostLikesLoadingState extends PostLikesState {}

class PostLikesLoadedState extends PostLikesState {
  List<LikeModel> likes;
  PostLikesLoadedState(this.likes);
}

class PostLikesErrorState extends PostLikesState {
  String error;
  PostLikesErrorState(this.error);
}
