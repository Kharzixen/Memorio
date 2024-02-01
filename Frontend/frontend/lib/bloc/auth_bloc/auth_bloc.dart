import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/service/storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final StorageService storageService;
  AuthBloc(this.storageService)
      : super(storageService.isLoggedIn()
            ? AuthSuccess(userId: storageService.userId)
            : AuthInitialState()) {
    on<LoginRequestedEvent>(_onLoginRequestedEvent);
    on<RegistrationRequestedEvent>(_onRegistrationRequested);
  }

  // @override
  // void onChange(Change<AuthState> change) {
  //   super.onChange(change);
  //   print('AuthBloc - Change - $change');
  // }

  // @override
  // void onTransition(Transition<AuthEvent, AuthState> transition) {
  //   super.onTransition(transition);
  //   print('AuthBloc - Transition - $transition');
  // }

  void _onLoginRequestedEvent(
      LoginRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // final String username = event.username;
      // final String password = event.password;

      //if (password.length < 6) {
      //  return emit(
      //      AuthFailure(error: 'Password cannot be less than 6 characters!'));
      //}

      await Future.delayed(const Duration(seconds: 2), () {
        return emit(AuthSuccess(userId: '65afd4c1a82d224ef7c41fc8'));
      });
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void _onRegistrationRequested(
      RegistrationRequestedEvent event, Emitter<AuthState> emit) async {
    //create userRegistrationDto from event;
    emit(RegistrationLoading());
    try {
      if (event.password != event.confirmPassword) {
        return emit(RegistrationFailure(
            error: "Password and confirm password doesn't match!"));
      }

      await Future.delayed(const Duration(seconds: 2), () {
        return emit(RegistrationSuccess(userId: '65afd4c1a82d224ef7c41fc8'));
      });
    } catch (e) {
      return emit(RegistrationFailure(error: e.toString()));
    }
  }
}
