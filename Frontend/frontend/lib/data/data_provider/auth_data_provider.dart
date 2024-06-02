import 'dart:convert';

import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;

class AuthDataProvider {
  static Future<http.Response> login(String username, String password) {
    Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
    };

    return http
        .post(Uri.parse("${StorageService.connectionString}/api/auth/login"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static refreshToken(String refreshToken) {
    Map<String, dynamic> requestBody = {
      'refreshToken': refreshToken,
    };

    return http
        .post(Uri.parse("${StorageService.connectionString}/api/auth/refresh"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
