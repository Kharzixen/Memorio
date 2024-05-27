import 'dart:convert';

import 'package:frontend/data/data_provider/memory_comment_data_provider.dart';
import 'package:frontend/model/private-album_model.dart';

class MemoryCommentRepository {
  Future<Comment> createNewCommentForMemory(
      String albumId, String userId, String memoryId, String message) async {
    try {
      var response = await CommentDataProvider.createNewCommentForMemory(
          albumId, userId, memoryId, message);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        Comment comment = Comment.fromJson(responseJson);
        return comment;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Comment>> findAllCommentsOfMemory(
      String albumId, String memoryId) async {
    try {
      var response =
          await CommentDataProvider.getCommentsOfMemory(albumId, memoryId);
      if (response.statusCode == 200) {
        List<dynamic> responseJson = json.decode(response.body);
        List<Comment> comments =
            responseJson.map((e) => Comment.fromJson(e)).toList();
        return comments;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  deleteCommentFromMemory(
      String albumId, String memoryId, String commentId) async {
    try {
      var response = await CommentDataProvider.deleteCommentFromMemory(
          albumId, memoryId, commentId);
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
