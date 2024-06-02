import 'dart:convert';

import 'package:admin_panel/service/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static StorageService storageService = StorageService();

  AuthCubit() : super(AuthInitialState());

  Future<void> login(String username, String password) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var uri = Uri.parse('http://localhost:8080/api/auth/login');
    var requestBody = {"username": username, "password": password};

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode(requestBody));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        String accessToken = jsonResponse['accessToken'] as String;
        await storageService.saveAccessToken(accessToken);
        emit(AuthSuccess(accessToken));
      } else {
        emit(AuthFailure(error: response.body));
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> logout() async {
    await storageService.deleteAccessToken();
    emit(AuthInitialState());
  }
}
