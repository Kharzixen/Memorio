part of 'post_cubit.dart';

sealed class PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  bool asyncMethodInProgress;
  Post post;
  PostLoadedState(this.post, this.asyncMethodInProgress);
}

class PostErrorState extends PostState {
  String error;
  PostErrorState(this.error);
}

class PostDeletedState extends PostState {}
