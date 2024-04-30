import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/data/data_provider/album_data_provider.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/user_model.dart';

class AlbumRepository {
  Future<List<AlbumPreview>> getAlbumPreviewOfUser(String userId) async {
    try {
      final response =
          await AlbumDataProvider.getAlbumPreviewPage(userId, 0, 10);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        List<AlbumPreview> previews = [];
        for (var content in responseJson["content"]) {
          List<Memory> recentMemories = [];
          for (var memoryMap in content["recentMemories"]) {
            Memory memory = Memory.fromJson(memoryMap);
            recentMemories.add(memory);
          }
          AlbumPreview preview = AlbumPreview.fromJson(content);
          preview.previewImages = recentMemories;
          previews.add(preview);
        }
        return previews;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AlbumInfo> getAlbumHeaderInfo(String albumId) async {
    try {
      var response = await AlbumDataProvider.getAlbumInfo(albumId);
      Map<String, dynamic> responseJson = json.decode(response.body);
      AlbumInfo albumInfo = AlbumInfo.fromJson(responseJson);
      return albumInfo;
    } catch (e) {
      rethrow;
    }
  }

  Future<SimpleAlbum> createAlbum(
    String ownerId,
    String albumName,
    String caption,
    List<SimpleUser> contributors,
    Uint8List image,
  ) async {
    try {
      var response = await AlbumDataProvider.createAlbum(
          ownerId: ownerId,
          albumName: albumName,
          caption: caption,
          invitedUserIds: contributors.map((e) => e.userId).toList(),
          albumImage: image);

      Map<String, dynamic> jsonResponse =
          json.decode(await response.stream.bytesToString());
      SimpleAlbum album = SimpleAlbum.fromJson(jsonResponse);
      return album;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SimpleUser>> getContributorsOfAlbum(String albumId) async {
    try {
      final response = await AlbumDataProvider.getContributorsOfAlbum(albumId);
      if (response.statusCode == 200) {
        List<dynamic> contributorJsonList = json.decode(response.body);
        List<SimpleUser> contributors = [];
        for (var contributorJson in contributorJsonList) {
          SimpleUser user = SimpleUser.fromMap(contributorJson);
          contributors.add(user);
        }
        return contributors;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addUsersToAlbum(
      String albumId, Set<SimpleUser> selectedUsers) async {
    try {
      final response = await AlbumDataProvider.addUsersToContributors(
          albumId, selectedUsers);
      if (response.statusCode == 200) {
        return 200;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUserFromAlbum(String albumId, String userId) async {
    try {
      final response =
          await AlbumDataProvider.removeUserFromAlbum(albumId, userId);
      if (!(response.statusCode == 204)) {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
