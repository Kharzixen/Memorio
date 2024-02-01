part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthSuccess extends AuthState {
  final String userId;
  AuthSuccess({required this.userId});
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

final class RegistrationSuccess extends AuthState {
  final String userId;
  RegistrationSuccess({required this.userId});
}

final class RegistrationFailure extends AuthState {
  final String error;
  RegistrationFailure({required this.error});
}

final class AuthLoading extends AuthState {}

final class RegistrationLoading extends AuthState {}
