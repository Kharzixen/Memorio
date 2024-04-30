part of 'invitation_cubit.dart';

sealed class InvitationPageState {}

class InvitationPageInitialState extends InvitationPageState {}

class InvitationPageLoadingState extends InvitationPageState {}

class InvitationPageLoadedState extends InvitationPageState {
  List<SimpleUser> friends;
  List<bool> isSelectedFriend;
  bool friendsHasMoreData;
  Set<SimpleUser> selectedUsers;
  bool isAsyncMethodInProgress;
  InvitationPageLoadedState(this.friends, this.friendsHasMoreData,
      this.isSelectedFriend, this.selectedUsers, this.isAsyncMethodInProgress);
}

class InvitationPageFinishedState extends InvitationPageState {
  int nrOfSelectedUsers;
  InvitationPageFinishedState(this.nrOfSelectedUsers);
}

class InvitationPageErrorState extends InvitationPageState {
  String message;
  InvitationPageErrorState(this.message);
}
