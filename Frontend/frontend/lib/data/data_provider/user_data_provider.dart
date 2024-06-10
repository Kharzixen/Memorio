import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserDataProvider {
  static Future<http.Response> getProfileUser(String userId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(Uri.parse("${StorageService.connectionString}/api/users/$userId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getFollowers(
      String userId, int followersPage, int followersPageSize) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$userId/followers?page=$followersPage&pageSize=$followersPageSize"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getFollowing(
      String userId, int followingPage, int followingPageSize) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$userId/following?page=$followingPage&pageSize=$followingPageSize"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getFriendsOfUser(
      String userId, int friendPage, int friendPageSize) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$userId/friends?page=$friendPage&pageSize=$friendPageSize"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static getSuggestionsForUser(String userId, int page, int pageSize) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$userId/suggestions?page=$page&pageSize=$pageSize"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> addUserToFollowing(
      String fromId, String toId) async {
    Map<String, dynamic> requestBody = {
      'fromId': fromId,
      'toId': toId,
    };
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();

    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$fromId/following"),
            headers: headers,
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static unfollowUser(String userId, String followingId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$userId/following/$followingId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static isUserFollowed(String userId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/users/${StorageService().userId}/following/$userId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static patchUserProfileImage(
      String userId, Uint8List image, String? newBio) async {
    try {
      var request = http.MultipartRequest('PATCH',
          Uri.parse("${StorageService.connectionString}/api/users/$userId"));
      if (image.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes('image', image,
              filename: "asd", contentType: MediaType('image', 'jpg')),
        );
      }

      if (newBio != null) {
        request.fields["bio"] = newBio;
      }

      Map<String, String> headers =
          await HttpHeadersFactory.getDefaultRequestHeader();

      request.headers.addAll(headers);

      return await request.send().then((value) {
        return value;
      }).catchError((error) {
        throw Exception(error);
      });
    } catch (e) {
      // Handle errors
      print('Error uploading file: $e');
      rethrow;
    }
  }
}
