import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/model/utils/simple_user_with_following.dart';

part 'following_suggestion_state.dart';

class FollowingSuggestionCubit extends Cubit<FollowingSuggestionState> {
  UserRepository userRepository;

  late List<SimpleUserWithFollowedStatus> users = [];
  int page = 0;
  int pageSize = 16;
  late String userId;
  FollowingSuggestionCubit(this.userRepository)
      : super(FollowingSuggestionInitialState());

  void loadSuggestionsOfUser(String userId) async {
    try {
      this.userId = userId;
      emit(FollowingSuggestionLoadingState());
      PaginatedResponse<SimpleUser> newBatchOfUsers =
          await userRepository.loadSuggestionsForUser(userId, page, pageSize);
      users.addAll(newBatchOfUsers.content.map((e) =>
          SimpleUserWithFollowedStatus(
              user: e, isFollowed: false, isFollowInitiated: false)));
      emit(FollowingSuggestionLoadedState(users));
    } catch (e) {
      emit(FollowingSuggestionErrorState(e.toString()));
    }
  }

  void followUser(int index) async {
    try {
      users[index].isFollowInitiated = true;
      emit(FollowingSuggestionLoadedState(users));
      await Future.delayed(Duration(milliseconds: 500));
      userRepository.followUser(userId, users[index].user.userId);
      users[index].isFollowInitiated = false;
      users[index].isFollowed = true;
      emit(FollowingSuggestionLoadedState(users));
    } catch (e) {
      emit(FollowingSuggestionErrorState(e.toString()));
    }
  }

  void unfollowUser(int index) async {
    try {
      users[index].isFollowInitiated = true;
      emit(FollowingSuggestionLoadedState(users));
      await Future.delayed(Duration(milliseconds: 500));
      userRepository.unfollowUser(userId, users[index].user.userId);
      users[index].isFollowInitiated = false;
      users[index].isFollowed = false;
      emit(FollowingSuggestionLoadedState(users));
    } catch (e) {
      emit(FollowingSuggestionErrorState(e.toString()));
    }
  }

  void refreshFollowStatus({required int index, required bool isFollowed}) {
    users[index].isFollowed = isFollowed;
    emit(FollowingSuggestionLoadedState(users));
  }
}
