part of 'create_post_cubit.dart';

sealed class CreatePostState {}

class CreatePostInitialState extends CreatePostState {}

class PostCreationLoadingState extends CreatePostState {}

class PostCreationInProgressState extends CreatePostState {
  Uint8List image;
  String caption;
  bool saveInProgress;
  bool savedToGallery;
  PostCreationInProgressState(
      {required this.image,
      required this.caption,
      required this.saveInProgress,
      required this.savedToGallery});
}

class PostCreationNoImageSelectedState extends CreatePostState {}

class PostCreationFinishedState extends CreatePostState {
  Post post;
  PostCreationFinishedState({required this.post});
}

class PostCreationErrorState extends CreatePostState {
  final String message;
  PostCreationErrorState({required this.message});
}
