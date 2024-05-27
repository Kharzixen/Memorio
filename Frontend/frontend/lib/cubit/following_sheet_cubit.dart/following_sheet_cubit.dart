import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/model/utils/simple_user_with_following.dart';

part 'following_sheet_state.dart';

class FollowingSheetCubit extends Cubit<FollowingSheetState> {
  UserRepository userRepository;

  late List<SimpleUserWithFollowedStatus> following = [];
  int page = 0;
  int pageSize = 16;
  bool hasMoreData = true;
  late String userId;
  FollowingSheetCubit(this.userRepository)
      : super(FollowingSheetInitialState());

  void getFollowing(String userId) async {
    try {
      if (following.isEmpty) {
        emit(FollowingSheetLoadingState());
      }
      this.userId = userId;
      if (hasMoreData) {
        PaginatedResponse<SimpleUser> paginatedResponse =
            await userRepository.getFollowing(userId, page, pageSize);
        page++;
        following.addAll(paginatedResponse.content.map((e) =>
            SimpleUserWithFollowedStatus(
                user: e, isFollowed: true, isFollowInitiated: false)));
        hasMoreData = !paginatedResponse.last;
        emit(FollowingSheetLoadedState(following, hasMoreData));
      }
    } catch (e) {
      emit(FollowingSheetErrorState(e.toString()));
    }
  }

  void followUser(int index) async {
    try {
      following[index].isFollowInitiated = true;
      emit(FollowingSheetLoadedState(following, hasMoreData));
      await Future.delayed(Duration(milliseconds: 500));
      userRepository.followUser(userId, following[index].user.userId);
      following[index].isFollowInitiated = false;
      following[index].isFollowed = true;
      emit(FollowingSheetLoadedState(following, hasMoreData));
    } catch (e) {
      emit(FollowingSheetErrorState(e.toString()));
    }
  }

  void unfollowUser(int index) async {
    try {
      following[index].isFollowInitiated = true;
      emit(FollowingSheetLoadedState(following, hasMoreData));
      await Future.delayed(Duration(milliseconds: 500));
      userRepository.unfollowUser(userId, following[index].user.userId);
      following[index].isFollowInitiated = false;
      following[index].isFollowed = false;
      emit(FollowingSheetLoadedState(following, hasMoreData));
    } catch (e) {
      emit(FollowingSheetErrorState(e.toString()));
    }
  }

  void refreshFollowStatus({required int index, required bool isFollowed}) {
    following[index].isFollowed = isFollowed;
    emit(FollowingSheetLoadedState(following, hasMoreData));
  }
}
