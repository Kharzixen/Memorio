import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationPageState> {
  late String albumId;
  final AlbumRepository albumRepository;
  final UserRepository userRepository;

  Set<String> contributorIds = {};
  Set<SimpleUser> selectedUsers = {};

  List<SimpleUser> friends = [];
  List<bool> isSelectedFriend = [];
  bool friendsHasMoreData = true;
  int friendPage = 0;
  int friendPageSize = 10;

  InvitationCubit(this.albumRepository, this.userRepository)
      : super(InvitationPageInitialState());

  void startInvitations(String albumId, String userId) async {
    emit(InvitationPageLoadingState());
    this.albumId = albumId;
    List<SimpleUser> contributorsList =
        await albumRepository.getContributorsOfAlbum(albumId);
    _initializeContributorsSet(contributorsList);
    PaginatedResponse<SimpleUser> friendsPage = await userRepository
        .getFriendsOfUser(userId, friendPage, friendPageSize);
    if (friendsPage.last) {
      friendsHasMoreData = false;
    }
    _addNewFriends(friendsPage.content);
    for (int i = 0; i < friendsPage.content.length; i++) {
      isSelectedFriend.add(false);
    }
    emit(InvitationPageLoadedState(
        friends, friendsHasMoreData, isSelectedFriend, selectedUsers, false));
  }

  void selectFriendAtIndex(int index) {
    isSelectedFriend[index] = true;
    selectedUsers.add(friends[index]);
    emit(InvitationPageLoadedState(
        friends, friendsHasMoreData, isSelectedFriend, selectedUsers, false));
  }

  void unselectFriendAtIndex(int index) {
    isSelectedFriend[index] = false;
    selectedUsers.remove(friends[index]);
    emit(InvitationPageLoadedState(
        friends, friendsHasMoreData, isSelectedFriend, selectedUsers, false));
  }

  void addSelectedUsersToContributors() async {
    try {
      emit(InvitationPageLoadedState(
          friends, friendsHasMoreData, isSelectedFriend, selectedUsers, true));
      int status =
          await albumRepository.addUsersToAlbum(albumId, selectedUsers);
      print(status);
      emit(InvitationPageFinishedState(selectedUsers.length));
    } catch (e) {
      emit(InvitationPageErrorState("An error occured: ${e}"));
    }
  }

  void _initializeContributorsSet(List<SimpleUser> contributorsList) {
    for (var contributor in contributorsList) {
      contributorIds.add(contributor.userId);
    }
  }

  void _addNewFriends(List<SimpleUser> newFriends) {
    for (var user in newFriends) {
      if (!contributorIds.contains(user.userId)) {
        friends.add(user);
        isSelectedFriend.add(false);
      }
    }
  }
}
