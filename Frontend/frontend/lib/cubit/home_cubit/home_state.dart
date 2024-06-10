part of 'home_cubit.dart';

sealed class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  List<SimpleUser> users;
  Map<String, List<Post>> posts;
  bool hasMoreData;
  HomeLoadedState(this.users, this.posts, this.hasMoreData);
}

class HomeErrorState extends HomeState {
  String message;
  HomeErrorState(this.message);
}
