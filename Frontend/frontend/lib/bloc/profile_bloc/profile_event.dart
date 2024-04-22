part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileFetched extends ProfileEvent {
  String userId;
  ProfileFetched(this.userId);
}

final class FollowersNextPageFetched extends ProfileEvent {}

final class FollowingNextPageFetched extends ProfileEvent {}
