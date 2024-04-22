import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserPageState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserPageInitialState());

  Future<void> fetchUserData(String userId) async {
    try {
      emit(UserPageLoadingState());

      final User userData = await userRepository.getUser(userId);

      emit(UserPageLoadedState(user: userData));
    } catch (e) {
      // Emit error state if an error occurs
      emit(UserPageErrorState(message: 'Failed to fetch user data: $e'));
    }
  }
}
