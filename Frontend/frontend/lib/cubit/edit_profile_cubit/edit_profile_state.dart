part of 'edit_profile_cubit.dart';

sealed class EditProfileState {}

class EditProfileInitialState extends EditProfileState {}

class EditProfileLoadedState extends EditProfileState {
  User user;
  Uint8List image;
  String bio;
  EditProfileLoadedState(this.user, this.image, this.bio);
}

class EditProfileErrorState extends EditProfileState {
  String message;
  EditProfileErrorState(this.message);
}

class EditProfileSuccessState extends EditProfileState {
  User user;
  EditProfileSuccessState(this.user);
}

class EditProfileLoadingState extends EditProfileState {}
