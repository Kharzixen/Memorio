import 'dart:convert';

import 'package:frontend/data/data_provider/user_data_provider.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/model/user_model.dart';

class UserRepository {
  Future<User> getUser(String userId) async {
    try {
      final rawData = await UserDataProvider.getProfileUser(userId);

      //print(data);
      if (rawData.statusCode == 200) {
        String response = utf8.decode(rawData.bodyBytes);
        return User.fromJson(response);
      } else {
        throw "Unexpected error occurred";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<PaginatedResponse<SimpleUser>> getFollowers(
      String userId, int followersPage, int followersPageSize) async {
    try {
      final response = await UserDataProvider.getFollowers(
          userId, followersPage, followersPageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        return PaginatedResponse.fromJson(responseJson, SimpleUser.fromMap);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<PaginatedResponse<SimpleUser>> getFollowing(
      String userId, int followingPage, int followingPageSize) async {
    try {
      final response = await UserDataProvider.getFollowing(
          userId, followingPage, followingPageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        return PaginatedResponse.fromJson(responseJson, SimpleUser.fromMap);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<PaginatedResponse<SimpleUser>> getFriendsOfUser(
      String userId, int friendPage, int friendPageSize) async {
    try {
      final response = await UserDataProvider.getFriendsOfUser(
          userId, friendPage, friendPageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        return PaginatedResponse.fromJson(responseJson, SimpleUser.fromMap);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
