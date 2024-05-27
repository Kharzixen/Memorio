import "dart:convert";

import "package:frontend/service/storage_service.dart";
import "package:http/http.dart" as http;

class PostLikeDataProvider {
  static getLikesOfPost(String postId) {
    return http
        .get(
      Uri.parse("${StorageService.connectionString}/api/posts/$postId/likes"),
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

  static createNewLikeForPost(String userId, String postId) {
    Map<String, dynamic> requestBody = {"userId": userId, "postId": postId};
    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/posts/$postId/likes"),
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
}
