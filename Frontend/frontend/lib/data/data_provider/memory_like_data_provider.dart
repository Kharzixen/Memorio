import 'dart:convert';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;

class LikeDataProvider {
  static createNewLikeForPost(
      String albumId, String userId, String memoryId) async {
    Map<String, dynamic> requestBody = {"userId": userId, "memoryId": memoryId};
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId/likes"),
            headers: headers,
            body: jsonEncode(requestBody))
        .then(
      (value) {
        return value;
      },
    ).catchError(
      (error) {
        throw Exception(error);
      },
    );
  }

  static getLikesOfMemory(String albumId, String memoryId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId/likes"),
            headers: headers)
        .then(
      (value) {
        return value;
      },
    ).catchError(
      (error) {
        throw Exception(error);
      },
    );
  }

  static deleteLikeFromMemory(String albumId, String memoryId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId/likes?userId=${StorageService().userId}"),
            headers: headers)
        .then(
      (value) {
        return value;
      },
    ).catchError(
      (error) {
        throw Exception(error);
      },
    );
  }
}
