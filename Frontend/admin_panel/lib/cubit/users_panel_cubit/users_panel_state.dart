part of 'users_panel_cubit.dart';

sealed class UsersPanelState {}

class UsersPanelLoading extends UsersPanelState {}

class UsersPanelInitialState extends UsersPanelState {}

class UsersPanelLoaded extends UsersPanelState {
  List<User> users;
  int currentPage;
  int totalPages;
  UsersPanelLoaded(this.users, this.currentPage, this.totalPages);
}

class UsersPanelErrorState extends UsersPanelState {
  String message;
  UsersPanelErrorState(this.message);
}
