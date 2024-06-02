import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/model/utils/auth_response.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitialState()) {
    on<LoginRequestedEvent>(_onLoginRequestedEvent);
    on<RegistrationRequestedEvent>(_onRegistrationRequested);
    on<VerifyIfUserLoggedIn>(_checkIfUserLoggedIn);
    on<LogoutRequested>(_logout);
    on<TokenExpired>(_refreshToken);
  }

  void _onLoginRequestedEvent(
      LoginRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      LoginResponse response =
          await authRepository.login(event.username, event.password);
      if (response.accessToken != "") {
        await StorageService().saveAccessToken(response.accessToken);
        await StorageService().saveRefreshToken(response.refreshToken);
        TokenManager().accessToken = response.accessToken;
        TokenManager().refreshToken = response.refreshToken;
        emit(AuthSuccess());
      }
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

  FutureOr<void> _checkIfUserLoggedIn(
      VerifyIfUserLoggedIn event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      String? accessToken = await StorageService().getAccessToken();
      String? refreshToken = await StorageService().getRefreshToken();
      if (accessToken == null || refreshToken == null) {
        emit(AuthInitialState());
        return;
      }

      // Check if the token is expired
      bool expired = _isJwtExpired(accessToken);

      if (expired) {
        if (!_isJwtExpired(refreshToken)) {
          LoginResponse response =
              await authRepository.refreshToken(refreshToken);
          if (response.accessToken != "" && response.refreshToken != "") {
            await StorageService().saveAccessToken(response.accessToken);
            await StorageService().saveRefreshToken(response.refreshToken);
            TokenManager().accessToken = response.accessToken;
            TokenManager().refreshToken = response.refreshToken;
            emit(AuthSuccess());
            return;
          }
        } else {
          emit(AuthInitialState());
        }
      } else {
        await Future.delayed(Duration(milliseconds: 500));
        TokenManager().accessToken = (await StorageService().getAccessToken())!;
        TokenManager().refreshToken =
            (await StorageService().getRefreshToken())!;

        emit(AuthSuccess());
      }
    } catch (e) {
      return emit(RegistrationFailure(error: e.toString()));
    }
  }

  bool _isJwtExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  FutureOr<void> _logout(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await StorageService().deleteAccessToken();
      await StorageService().deleteRefreshToken();
      emit(AuthInitialState());
    } catch (e) {
      return emit(RegistrationFailure(error: e.toString()));
    }
  }

  FutureOr<void> _refreshToken(
      TokenExpired event, Emitter<AuthState> emit) async {
    try {
      LoginResponse response = await authRepository
          .refreshToken((await StorageService().getRefreshToken())!);
      if (response.accessToken != "") {
        await StorageService().saveAccessToken(response.accessToken);
        await StorageService().saveRefreshToken(response.refreshToken);
        emit(AuthSuccess());
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
