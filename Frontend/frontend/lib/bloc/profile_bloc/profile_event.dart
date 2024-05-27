part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileFetched extends ProfileEvent {
  String userId;
  ProfileFetched(this.userId);
}

final class FollowersNextPageFetched extends ProfileEvent {}

final class FollowingNextPageFetched extends ProfileEvent {}

final class NewPostCreated extends ProfileEvent {
  Post post;
  NewPostCreated(this.post);
}

final class PostDeleted extends ProfileEvent {
  String postId;
  PostDeleted(this.postId);
}

final class RefreshProfile extends ProfileEvent {}
