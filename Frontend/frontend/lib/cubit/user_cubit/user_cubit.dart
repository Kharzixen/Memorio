import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/post_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/service/storage_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserPageState> {
  final UserRepository userRepository;
  final PostRepository postRepository;

  late User userData;
  late String userId;
  late List<Post> posts = [];
  int postCount = 0;
  int page = 0;
  int pageSize = 10;

  bool isFollowed = false;
  bool isFollowInitiated = false;

  bool isFollowStatusChanged = false;

  UserCubit(this.userRepository, this.postRepository)
      : super(UserPageInitialState());

  Future<void> fetchUserData(String userId) async {
    try {
      emit(UserPageLoadingState());
      this.userId = userId;
      userData = await userRepository.getUser(userId);
      PaginatedResponse<Post> postsBatch = await postRepository
          .getPostsOfUserOrderedByDatePaginated(userId, page, pageSize);
      posts.addAll(postsBatch.content);
      postCount = postsBatch.totalElements;
      isFollowed = await userRepository.isFollowed(userId);
      emit(UserPageLoadedState(
          user: userData,
          posts: posts,
          postsCount: postCount,
          isFollowed: isFollowed,
          isFollowInitiated: isFollowInitiated));
    } catch (e) {
      // Emit error state if an error occurs
      emit(UserPageErrorState(message: 'Failed to fetch user data: $e'));
    }
  }

  Future<void> refreshPage() async {
    posts = [];
    page = 0;
    userData = await userRepository.getUser(userId);
    PaginatedResponse<Post> postsBatch = await postRepository
        .getPostsOfUserOrderedByDatePaginated(userId, page, pageSize);
    posts.addAll(postsBatch.content);

    emit(UserPageLoadedState(
        user: userData,
        posts: posts,
        postsCount: postCount,
        isFollowed: isFollowed,
        isFollowInitiated: isFollowInitiated));
  }

  void followUser() async {
    try {
      isFollowInitiated = true;
      emit(UserPageLoadedState(
          user: userData,
          posts: posts,
          postsCount: postCount,
          isFollowed: isFollowed,
          isFollowInitiated: isFollowInitiated));
      userRepository.followUser(StorageService().userId, userData.userId);
      isFollowInitiated = false;
      isFollowed = true;
      isFollowStatusChanged = !isFollowStatusChanged;
      emit(UserPageLoadedState(
          user: userData,
          posts: posts,
          postsCount: postCount,
          isFollowed: isFollowed,
          isFollowInitiated: isFollowInitiated));
    } catch (e) {
      emit(UserPageErrorState(message: e.toString()));
    }
  }

  void unfollowUser() async {
    try {
      isFollowInitiated = true;
      emit(UserPageLoadedState(
          user: userData,
          posts: posts,
          postsCount: postCount,
          isFollowed: isFollowed,
          isFollowInitiated: isFollowInitiated));
      userRepository.unfollowUser(StorageService().userId, userData.userId);
      isFollowInitiated = false;
      isFollowed = false;
      isFollowStatusChanged = !isFollowStatusChanged;
      emit(UserPageLoadedState(
          user: userData,
          posts: posts,
          postsCount: postCount,
          isFollowed: isFollowed,
          isFollowInitiated: isFollowInitiated));
    } catch (e) {
      emit(UserPageErrorState(message: e.toString()));
    }
  }

  bool getIsFollowStatusChanged() {
    return isFollowStatusChanged;
  }
}
