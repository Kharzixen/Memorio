part of 'user_cubit.dart';

sealed class UserPageState {}

class UserPageInitialState extends UserPageState {}

class UserPageLoadingState extends UserPageState {}

class UserPageLoadedState extends UserPageState {
  User user;
  List<Post> posts;
  bool isFollowInitiated;
  bool isFollowed;
  UserPageLoadedState(
      {required this.user,
      required this.posts,
      required this.isFollowed,
      required this.isFollowInitiated});
}

class UserPageErrorState extends UserPageState {
  String message;
  UserPageErrorState({required this.message});
}
