import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  ProfileBloc(this.userRepository) : super(ProfileInitialState()) {
    on<ProfileFetched>(_getProfileUser);
  }

  void _getProfileUser(ProfileFetched event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final User user = await userRepository.getUser(event.userId);
    emit(ProfileLoadedState(user));
  }
}
