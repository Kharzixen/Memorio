import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/post_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/model/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final PostRepository postRepository;
  String userId = "";
  bool isFollowingLoading = false;
  List<SimpleUser> followers = [];
  List<bool> isFollowed = [];
  int followersPage = 0;
  int followersPageSize = 20;
  bool followersHasMoreData = true;
  List<SimpleUser> following = [];
  int followingPage = 0;
  int followingPageSize = 20;
  bool followingHasMoreData = true;
  late User user;

  List<Post> posts = [];
  int page = 0;
  int pageSize = 10;

  ProfileBloc(this.userRepository, this.postRepository)
      : super(ProfileInitialState()) {
    on<ProfileFetched>(_getProfileUser);
    on<FollowersNextPageFetched>(_getFollowers);
    on<FollowingNextPageFetched>(_getFollowing);
    on<NewPostCreated>(_addNewPost);
    on<PostDeleted>(_removePost);
    on<RefreshProfile>(_refreshProfile);
  }

  void _getProfileUser(ProfileFetched event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    user = await userRepository.getUser(event.userId);
    userId = user.userId;
    PaginatedResponse<Post> postsBatch = await postRepository
        .getPostsOfUserOrderedByDatePaginated(userId, page, pageSize);
    posts.addAll(postsBatch.content);
    page++;
    emit(ProfileLoadedState(user, followers, isFollowed, following,
        followersHasMoreData, followingHasMoreData, posts));
  }

  void _getFollowers(
      FollowersNextPageFetched event, Emitter<ProfileState> emit) async {
    if (followersHasMoreData) {
      PaginatedResponse<SimpleUser> paginatedResponse = await userRepository
          .getFollowers(userId, followersPage, followersPageSize);
      followersPage++;
      followers.addAll(paginatedResponse.content);
      followersHasMoreData = !paginatedResponse.last;
      emit(ProfileLoadedState(user, followers, isFollowed, following,
          followersHasMoreData, followingHasMoreData, posts));
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
      for (int i = 0; i < paginatedResponse.content.length; i++) {
        isFollowed.add(true);
      }
      followingHasMoreData = !paginatedResponse.last;
      emit(ProfileLoadedState(user, followers, isFollowed, following,
          followersHasMoreData, followingHasMoreData, posts));
    }
  }

  void _addNewPost(NewPostCreated event, Emitter<ProfileState> emit) async {
    posts.insert(0, event.post);
    emit(ProfileLoadedState(user, followers, isFollowed, following,
        followersHasMoreData, followingHasMoreData, posts));
  }

  void _removePost(PostDeleted event, Emitter<ProfileState> emit) async {
    posts.removeWhere((element) => element.postId == event.postId);
    emit(ProfileLoadedState(user, followers, isFollowed, following,
        followersHasMoreData, followingHasMoreData, posts));
  }

  FutureOr<void> _refreshProfile(
      RefreshProfile event, Emitter<ProfileState> emit) async {
    isFollowingLoading = false;
    followers = [];
    followersPage = 0;
    followersHasMoreData = true;
    following = [];
    followingPage = 0;
    followingHasMoreData = true;

    posts = [];
    page = 0;
    user = await userRepository.getUser(userId);
    userId = user.userId;
    PaginatedResponse<Post> postsBatch = await postRepository
        .getPostsOfUserOrderedByDatePaginated(userId, page, pageSize);
    posts.addAll(postsBatch.content);
    page++;
    emit(ProfileLoadedState(user, followers, isFollowed, following,
        followersHasMoreData, followingHasMoreData, posts));
  }
}
