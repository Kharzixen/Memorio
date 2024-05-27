part of 'private_memory_likes_cubit.dart';

sealed class PrivateMemoryLikesState {}

class PrivateMemoryLikesInitialState extends PrivateMemoryLikesState {}

class PrivateMemoryLikesLoadingState extends PrivateMemoryLikesState {}

class PrivateMemoryLikesLoadedState extends PrivateMemoryLikesState {
  List<LikeModel> likes;
  PrivateMemoryLikesLoadedState(this.likes);
}

class PrivateMemoryLikesErrorState extends PrivateMemoryLikesState {
  String error;
  PrivateMemoryLikesErrorState(this.error);
}
