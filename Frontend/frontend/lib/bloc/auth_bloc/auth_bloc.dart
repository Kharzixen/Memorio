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
        StorageService().userId = getUserIdFromJwt(response.accessToken);
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
      if (event.password == event.confirmPassword) {
        Map<String, dynamic> registerRequestBody = {};
        registerRequestBody['username'] = event.username;
        registerRequestBody['name'] = event.name;
        registerRequestBody['email'] = event.email;
        registerRequestBody['phoneNumber'] = event.phoneNumber;
        registerRequestBody['password'] = event.password;
        registerRequestBody['confirmPassword'] = event.confirmPassword;
        registerRequestBody['birthday'] = new DateTime(2001, 8, 24);
        await authRepository.register(registerRequestBody);
        emit(RegistrationSuccess());
      }
    } catch (e) {
      return emit(RegistrationFailure(
          error: e.toString(),
          username: event.username,
          name: event.name,
          email: event.email,
          phoneNumber: event.phoneNumber));
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
            StorageService().userId = getUserIdFromJwt(response.accessToken);
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
        emit(AuthInitialState());
      } else {
        TokenManager().accessToken = (await StorageService().getAccessToken())!;
        TokenManager().refreshToken =
            (await StorageService().getRefreshToken())!;
        StorageService().initStorageService(TokenManager().accessToken!);
        emit(AuthSuccess());
      }
    } catch (e) {
      return emit(AuthFailure(error: e.toString()));
    }
  }

  bool _isJwtExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  String getUserIdFromJwt(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['id'].toString();
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> _logout(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await StorageService().deleteAccessToken();
      await StorageService().deleteRefreshToken();
      StorageService().userId = "";
      emit(AuthInitialState());
    } catch (e) {
      return emit(AuthFailure(error: e.toString()));
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
