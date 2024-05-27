import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/data/data_provider/post_data_provider.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

class PostRepository {
  Future<PaginatedResponse<Post>> getPostsOfUserOrderedByDatePaginated(
      String userId, int page, int pageSize) async {
    try {
      var response = await PostDataProvider.getPostsOfUserOrderedByDate(
          userId, page, pageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<Post> paginatedMemories =
            PaginatedResponse.fromJson(responseJson, Post.fromJson);
        return paginatedMemories;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Post> createPost(
      String userId, Uint8List image, String caption) async {
    try {
      var response = await PostDataProvider.createPost(userId, caption, image);
      String jsonBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        Map<String, dynamic> responseJson = json.decode(jsonBody);
        Post createdPost = Post.fromJson(responseJson);
        return createdPost;
      } else {
        throw Exception(jsonBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Post> getPostById(String postId) async {
    try {
      var response = await PostDataProvider.getPostById(postId);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        Post createdPost = Post.fromJson(responseJson);
        return createdPost;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delePost(String postId) async {
    var response = await PostDataProvider.deletePostById(postId);
    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(response.body);
    }
  }
}
