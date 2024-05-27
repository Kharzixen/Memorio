import 'dart:convert';

import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;

class CommentDataProvider {
  static getCommentsOfMemory(String albumId, String memoryId) {
    return http
        .get(
      Uri.parse(
          "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId/comments"),
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

  static createNewCommentForMemory(
      String albumId, String userId, String memoryId, String message) {
    Map<String, dynamic> requestBody = {
      "userId": userId,
      "memoryId": memoryId,
      "message": message
    };
    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId/comments"),
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

  static deleteCommentFromMemory(
      String albumId, String memoryId, String commentId) {
    return http
        .delete(Uri.parse(
            "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId/comments/$commentId"))
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
