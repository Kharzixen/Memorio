import "dart:convert";

import "package:frontend/service/storage_service.dart";
import "package:http/http.dart" as http;

class PostCommentDataProvider {
  static createNewCommentForPost(String userId, String postId, String message) {
    Map<String, dynamic> requestBody = {
      "userId": userId,
      "postId": postId,
      "message": message
    };
    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/posts/$postId/comments"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
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

  static getCommentsOfPost(String postId) {
    return http
        .get(
      Uri.parse(
          "${StorageService.connectionString}/api/posts/$postId/comments"),
    )
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

  static deleteCommentFromPost(String postId, String commentId) {
    return http
        .delete(Uri.parse(
            "${StorageService.connectionString}/api/posts/$postId/comments/$commentId"))
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
