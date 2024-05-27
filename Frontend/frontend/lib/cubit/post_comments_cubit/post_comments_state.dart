part of 'post_comments_cubit.dart';

sealed class PostCommentsState {}

class PostCommentsInitialState extends PostCommentsState {}

class PostCommentsLoadingState extends PostCommentsState {}

class PostCommentsLoadedState extends PostCommentsState {
  List<Comment> comments;
  bool isNewCommentInMaking;
  PostCommentsLoadedState(this.comments, this.isNewCommentInMaking);
}

class PostCommentsErrorState extends PostCommentsState {
  String error;
  PostCommentsErrorState(this.error);
}
