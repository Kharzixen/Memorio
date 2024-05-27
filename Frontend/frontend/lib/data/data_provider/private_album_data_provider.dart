import 'dart:convert';
import 'dart:typed_data';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class PrivateAlbumDataProvider {
  static Future<http.Response> getAlbumInfo(String albumId) async {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/private-albums/$albumId"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getAlbumPreviewPage(
      String userId, int page, int pageSize) async {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/users/$userId/private-albums?page=$page&pageSize=$pageSize"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.StreamedResponse> createAlbum(
      {required String ownerId,
      required String albumName,
      String caption = "",
      required List<String> invitedUserIds,
      required Uint8List albumImage}) async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse("${StorageService.connectionString}/api/private-albums"));
      request.files.add(
        http.MultipartFile.fromBytes('image', albumImage,
            filename: "albumImage", contentType: MediaType('image', 'jpg')),
      );

      request.fields['ownerId'] = ownerId;
      request.fields['albumName'] = albumName;
      request.fields['caption'] = caption;
      var concatenatedString = invitedUserIds.join(',');
      request.fields['invitedUserIds'] = concatenatedString;

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

  static Future<http.Response> getContributorsOfAlbum(String albumId) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/private-albums/$albumId/contributors"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> addUsersToContributors(
      String albumId, Set<SimpleUser> selectedUsers) {
    Map<String, dynamic> requestBody = {
      'method': "ADD",
      'userIds': selectedUsers.map((e) => e.userId).toList(),
    };

    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/contributors"),
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

  static Future<http.Response> removeUserFromAlbum(
      String albumId, String userId) {
    return http
        .delete(Uri.parse(
            "${StorageService.connectionString}/api/private-albums/$albumId/contributors/$userId"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getContributorOfAlbumById(
      String albumId, String contributorId) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/private-albums/$albumId/contributors/$contributorId"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static activateDisposableCamera(String albumId, String description) {
    Map<String, dynamic> requestBody = {
      'description': description,
      'isActive': true,
    };
    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/disposable-camera"),
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

  static deactivateDisposableCamera(String albumId) {
    Map<String, dynamic> requestBody = {
      'description': "",
      'isActive': false,
    };
    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/disposable-camera"),
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
