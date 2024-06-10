import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/post_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository userRepository;
  final PostRepository postRepository;
  HomeCubit(this.userRepository, this.postRepository)
      : super(HomeInitialState());

  List<SimpleUser> users = [];
  int page = 0;
  int pageSize = 10;
  bool hasMoreData = true;
  Map<String, List<Post>> posts = {};

  void loadHomePageContent(String userId) async {
    try {
      PaginatedResponse<SimpleUser> response =
          await userRepository.getFollowing(userId, page, pageSize);
      users.addAll(response.content);
      for (int i = 0; i < response.content.length; i++) {
        List<Post> postsPage =
            (await postRepository.getPostsOfUserOrderedByDatePaginated(
                    response.content[i].userId, 0, 3))
                .content;
        posts[response.content[i].userId] = postsPage;
      }
      page++;
      if (response.last) {
        hasMoreData = false;
      }
      emit(HomeLoadedState(users, posts, hasMoreData));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
