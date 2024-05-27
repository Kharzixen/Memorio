import 'dart:convert';

import 'package:frontend/data/data_provider/post_comment_data_provider.dart';
import 'package:frontend/model/private-album_model.dart';

class PostCommentRepository {
  Future<Comment> createNewCommentForPost(
      String userId, String postId, String message) async {
    try {
      var response = await PostCommentDataProvider.createNewCommentForPost(
          userId, postId, message);
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

  Future<List<Comment>> findAllCommentsOfPost(String postId) async {
    try {
      var response = await PostCommentDataProvider.getCommentsOfPost(postId);
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

  deleteCommentFromPost(String postId, String commentId) async {
    try {
      var response = await PostCommentDataProvider.deleteCommentFromPost(
          postId, commentId);
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
