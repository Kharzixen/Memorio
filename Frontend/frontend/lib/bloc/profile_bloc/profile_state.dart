part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {
  final User user;
  ProfileLoadedState(this.user);
}

final class ProfileErrorState extends ProfileState {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}
