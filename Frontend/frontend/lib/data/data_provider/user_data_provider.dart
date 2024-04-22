import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;

class UserDataProvider {
  static Future<http.Response> getProfileUser(String userId) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '<Your token>',
      'ngrok-skip-browser-warning': "1"
    };
    return http
        .get(Uri.parse("${StorageService.connectionString}/api/users/$userId"),
            headers: requestHeaders)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getFollowers(
      String userId, int followersPage, int followersPageSize) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/users/$userId/followers?page=$followersPage&pageSize=$followersPageSize"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static getFollowing(String userId, int followingPage, int followingPageSize) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/users/$userId/following?page=$followingPage&pageSize=$followingPageSize"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
