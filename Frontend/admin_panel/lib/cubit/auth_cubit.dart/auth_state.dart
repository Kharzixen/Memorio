part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthSuccess extends AuthState {
  String accessToken;
  AuthSuccess(this.accessToken);
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

final class AuthLoading extends AuthState {}
