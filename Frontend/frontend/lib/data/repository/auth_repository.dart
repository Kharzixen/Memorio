import 'dart:convert';

import 'package:frontend/data/data_provider/auth_data_provider.dart';
import 'package:frontend/model/utils/auth_response.dart';

class AuthRepository {
  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await AuthDataProvider.login(username, password);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        LoginResponse loginResponse = LoginResponse.fromJson(jsonResponse);
        return loginResponse;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  refreshToken(String refreshToken) async {
    try {
      final response = await AuthDataProvider.refreshToken(refreshToken);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        LoginResponse loginResponse =
            LoginResponse.fromRefreshJson(jsonResponse);
        return loginResponse;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
