part of 'user_cubit.dart';

sealed class UserPageState {}

class UserPageInitialState extends UserPageState {}

class UserPageLoadingState extends UserPageState {}

class UserPageLoadedState extends UserPageState {
  User user;
  UserPageLoadedState({required this.user});
}

class UserPageErrorState extends UserPageState {
  String message;
  UserPageErrorState({required this.message});
}
