import 'dart:convert';

import 'package:frontend/data/data_provider/memory_like_data_provider.dart';
import 'package:frontend/model/like_model.dart';

class MemoryLikeRepository {
  Future<LikeModel> createNewLikeForMemory(
      String albumId, String userId, String memoryId) async {
    try {
      var response = await LikeDataProvider.createNewLikeForPost(
          albumId, userId, memoryId);
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

  Future<List<LikeModel>> findAllLikesOfMemory(
      String albumId, String memoryId) async {
    try {
      var response = await LikeDataProvider.getLikesOfMemory(albumId, memoryId);
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
