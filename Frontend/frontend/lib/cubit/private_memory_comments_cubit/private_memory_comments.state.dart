part of 'private_memory_comments_cubit.dart';

sealed class PrivateMemoryCommentsState {}

class PrivateMemoryCommentsInitialState extends PrivateMemoryCommentsState {}

class PrivateMemoryCommentsLoadingState extends PrivateMemoryCommentsState {}

class PrivateMemoryCommentsLoadedState extends PrivateMemoryCommentsState {
  List<Comment> comments;
  bool isNewCommentInMaking;
  PrivateMemoryCommentsLoadedState(this.comments, this.isNewCommentInMaking);
}

class PrivateMemoryCommentsErrorState extends PrivateMemoryCommentsState {
  String error;
  PrivateMemoryCommentsErrorState(this.error);
}
