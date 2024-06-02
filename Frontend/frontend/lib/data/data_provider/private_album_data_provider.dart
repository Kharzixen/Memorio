import 'dart:convert';
import 'dart:typed_data';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class PrivateAlbumDataProvider {
  static Future<http.Response> getAlbumInfo(String albumId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getAlbumPreviewPage(
      String userId, int page, int pageSize) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$userId/private-albums?page=$page&pageSize=$pageSize"),
            headers: headers)
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
          Uri.parse("${StorageService.connectionString}/api/public-albums"));
      request.files.add(
        http.MultipartFile.fromBytes('image', albumImage,
            filename: "albumImage", contentType: MediaType('image', 'jpg')),
      );

      request.fields['ownerId'] = ownerId;
      request.fields['albumName'] = albumName;
      request.fields['caption'] = caption;
      var concatenatedString = invitedUserIds.join(',');
      request.fields['invitedUserIds'] = concatenatedString;

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

  static Future<http.Response> getContributorsOfAlbum(String albumId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/contributors"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> addUsersToContributors(
      String albumId, Set<SimpleUser> selectedUsers) async {
    Map<String, dynamic> requestBody = {
      'method': "ADD",
      'userIds': selectedUsers.map((e) => e.userId).toList(),
    };

    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();

    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/contributors"),
            headers: headers,
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> removeUserFromAlbum(
      String albumId, String userId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/contributors/$userId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getContributorOfAlbumById(
      String albumId, String contributorId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/contributors/$contributorId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static activateDisposableCamera(String albumId, String description) async {
    Map<String, dynamic> requestBody = {
      'description': description,
      'isActive': true,
    };

    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/disposable-camera"),
            headers: headers,
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static deactivateDisposableCamera(String albumId) async {
    Map<String, dynamic> requestBody = {
      'description': "",
      'isActive': false,
    };

    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/disposable-camera"),
            headers: headers,
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
