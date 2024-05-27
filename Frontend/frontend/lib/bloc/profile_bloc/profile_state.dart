part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {
  final User user;
  final List<SimpleUser> followers;
  final List<bool> isFollowed;
  final List<SimpleUser> following;
  bool followersHasMoreData;
  bool followingHasMoreData;
  List<Post> posts;
  ProfileLoadedState(this.user, this.followers, this.isFollowed, this.following,
      this.followersHasMoreData, this.followingHasMoreData, this.posts);
}

final class ProfileErrorState extends ProfileState {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}
