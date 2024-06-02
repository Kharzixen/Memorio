import "dart:convert";

import "package:frontend/data/data_provider/utils/http_headers.dart";
import "package:frontend/service/storage_service.dart";
import "package:http/http.dart" as http;

class PostCommentDataProvider {
  static createNewCommentForPost(
      String userId, String postId, String message) async {
    Map<String, dynamic> requestBody = {
      "userId": userId,
      "postId": postId,
      "message": message
    };

    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/posts/$postId/comments"),
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

  static getCommentsOfPost(String postId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/posts/$postId/comments"),
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

  static deleteCommentFromPost(String postId, String commentId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse(
                "${StorageService.connectionString}/api/posts/$postId/comments/$commentId"),
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
