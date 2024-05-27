import 'dart:convert';
import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;

class LikeDataProvider {
  static createNewLikeForPost(String albumId, String userId, String memoryId) {
    Map<String, dynamic> requestBody = {"userId": userId, "memoryId": memoryId};
    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId/likes"),
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

  static getLikesOfMemory(String albumId, String memoryId) {
    return http
        .get(
      Uri.parse(
          "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId/likes"),
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
}
