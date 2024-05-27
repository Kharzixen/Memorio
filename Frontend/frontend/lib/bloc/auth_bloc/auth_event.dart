part of 'auth_bloc.dart';

sealed class AuthEvent {}

class LoginRequestedEvent extends AuthEvent {
  final String username;
  final String password;

  LoginRequestedEvent({required this.username, required this.password});
}

class RegistrationRequestedEvent extends AuthEvent {
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  RegistrationRequestedEvent(
      {required this.username,
      required this.email,
      required this.phoneNumber,
      required this.password,
      required this.confirmPassword});
}