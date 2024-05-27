part of 'following_sheet_cubit.dart';

sealed class FollowingSheetState {}

class FollowingSheetInitialState extends FollowingSheetState {}

class FollowingSheetLoadingState extends FollowingSheetState {}

class FollowingSheetLoadedState extends FollowingSheetState {
  List<SimpleUserWithFollowedStatus> followers;
  bool hasMoreData;
  FollowingSheetLoadedState(this.followers, this.hasMoreData);
}

class FollowingSheetErrorState extends FollowingSheetState {
  String message;
  FollowingSheetErrorState(this.message);
}
