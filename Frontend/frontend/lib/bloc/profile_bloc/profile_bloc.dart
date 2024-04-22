import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/model/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  String userId = "";
  bool isFollowingLoading = false;
  List<SimpleUser> followers = [];
  int followersPage = 0;
  int followersPageSize = 20;
  bool followersHasMoreData = true;
  List<SimpleUser> following = [];
  int followingPage = 0;
  int followingPageSize = 20;
  bool followingHasMoreData = true;
  late User user;
  ProfileBloc(this.userRepository) : super(ProfileInitialState()) {
    on<ProfileFetched>(_getProfileUser);
    on<FollowersNextPageFetched>(_getFollowers);
    on<FollowingNextPageFetched>(_getFollowing);
  }

  void _getProfileUser(ProfileFetched event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    user = await userRepository.getUser(event.userId);
    userId = user.userId;
    emit(ProfileLoadedState(user, followers, following, followersHasMoreData,
        followingHasMoreData));
  }

  void _getFollowers(
      FollowersNextPageFetched event, Emitter<ProfileState> emit) async {
    if (followersHasMoreData) {
      print("followers fetched");
      PaginatedResponse<SimpleUser> paginatedResponse = await userRepository
          .getFollowers(userId, followersPage, followersPageSize);
      followersPage++;
      followers.addAll(paginatedResponse.content);
      followersHasMoreData = !paginatedResponse.last;
      emit(ProfileLoadedState(user, followers, following, followersHasMoreData,
          followingHasMoreData));
    }
  }

  void _getFollowing(
      FollowingNextPageFetched event, Emitter<ProfileState> emit) async {
    if (followingHasMoreData) {
      print("following fetched");
      PaginatedResponse<SimpleUser> paginatedResponse = await userRepository
          .getFollowing(userId, followingPage, followingPageSize);
      followingPage++;
      following.addAll(paginatedResponse.content);
      followingHasMoreData = !paginatedResponse.last;
      emit(ProfileLoadedState(user, followers, following, followersHasMoreData,
          followingHasMoreData));
    }
  }
}
