import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';

class AuthBlocSingleton {
  static final AuthBlocSingleton _singleton = AuthBlocSingleton._internal();
  AuthBloc? _authBloc;

  factory AuthBlocSingleton() {
    return _singleton;
  }

  AuthBlocSingleton._internal();

  void initialize(AuthBloc authBloc) {
    _authBloc = authBloc;
  }

  AuthBloc get authBloc {
    if (_authBloc == null) {
      throw Exception("AuthBloc is not initialized");
    }
    return _authBloc!;
  }
}
