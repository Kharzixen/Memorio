part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileFetched extends ProfileEvent {
  String userId;
  ProfileFetched(this.userId);
}
