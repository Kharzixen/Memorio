import "dart:convert";

import "package:frontend/data/data_provider/utils/http_headers.dart";
import "package:frontend/service/storage_service.dart";
import "package:http/http.dart" as http;

class PostLikeDataProvider {
  static getLikesOfPost(String postId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/posts/$postId/likes"),
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

  static createNewLikeForPost(String userId, String postId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    Map<String, dynamic> requestBody = {"userId": userId, "postId": postId};
    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/posts/$postId/likes"),
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

  static deleteLike(String userId, String postId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse(
                "${StorageService.connectionString}/api/posts/$postId/likes?userId=$userId"),
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
