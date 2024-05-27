import 'dart:convert';

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

  static Future<http.Response> getFollowing(
      String userId, int followingPage, int followingPageSize) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/users/$userId/following?page=$followingPage&pageSize=$followingPageSize"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getFriendsOfUser(
      String userId, int friendPage, int friendPageSize) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/users/$userId/friends?page=$friendPage&pageSize=$friendPageSize"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static getSuggestionsForUser(String userId, int page, int pageSize) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/users/$userId/suggestions?page=$page&pageSize=$pageSize"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> addUserToFollowing(String fromId, String toId) {
    Map<String, dynamic> requestBody = {
      'fromId': fromId,
      'toId': toId,
    };

    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$fromId/following"),
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

  static unfollowUser(String userId, String followingId) {
    return http
        .delete(Uri.parse(
            "${StorageService.connectionString}/api/users/$userId/following/$followingId"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static isUserFollowed(String userId) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/users/${StorageService().userId}/following/$userId"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
