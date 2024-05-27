import 'dart:convert';

import 'package:frontend/data/data_provider/post_like_data_provider.dart';
import 'package:frontend/model/like_model.dart';

class PostLikeRepository {
  Future<LikeModel> createNewLikeForPost(String userId, String postId) async {
    try {
      var response =
          await PostLikeDataProvider.createNewLikeForPost(userId, postId);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        LikeModel like = LikeModel.fromJson(responseJson);
        return like;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LikeModel>> findAllLikesOfPost(String postId) async {
    try {
      var response = await PostLikeDataProvider.getLikesOfPost(postId);
      if (response.statusCode == 200) {
        List<dynamic> responseJson = json.decode(response.body);
        List<LikeModel> likes =
            responseJson.map((e) => LikeModel.fromJson(e)).toList();
        return likes;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
