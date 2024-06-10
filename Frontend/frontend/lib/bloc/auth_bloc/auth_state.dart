part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthSuccess extends AuthState {
  AuthSuccess();
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

final class RegistrationSuccess extends AuthState {
  RegistrationSuccess();
}

final class RegistrationFailure extends AuthState {
  String username;
  String name;
  String email;
  String phoneNumber;
  final String error;
  RegistrationFailure(
      {required this.error,
      required this.username,
      required this.name,
      required this.email,
      required this.phoneNumber});
}

final class AuthLoading extends AuthState {}

final class RegistrationLoading extends AuthState {}

final class AuthTokenExpiredState extends AuthState {}
