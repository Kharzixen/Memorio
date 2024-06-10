import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/data/data_provider/public_album_data_provider.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/user_model.dart';

class PublicAlbumRepository {
  Future<List<PublicAlbumPreview>> getAlbumPreviewOfUser(String userId) async {
    try {
      final response =
          await PublicAlbumDataProvider.getAlbumPreviewPage(userId, 0, 10);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        List<PublicAlbumPreview> previews = [];
        for (var content in responseJson["content"]) {
          List<PublicMemory> recentMemories = [];
          for (var memoryMap in content["recentMemories"]) {
            PublicMemory memory = PublicMemory.fromJson(memoryMap);
            recentMemories.add(memory);
          }
          PublicAlbumPreview preview = PublicAlbumPreview.fromJson(content);
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

  Future<PublicAlbumInfo> getAlbumHeaderInfo(String albumId) async {
    try {
      var response = await PublicAlbumDataProvider.getAlbumInfo(albumId);
      Map<String, dynamic> responseJson = json.decode(response.body);
      PublicAlbumInfo albumInfo = PublicAlbumInfo.fromJson(responseJson);
      return albumInfo;
    } catch (e) {
      rethrow;
    }
  }

  Future<PublicAlbumPreview> createAlbum(
    String ownerId,
    String albumName,
    String caption,
    List<SimpleUser> contributors,
    Uint8List image,
  ) async {
    try {
      var response = await PublicAlbumDataProvider.createAlbum(
          ownerId: ownerId,
          albumName: albumName,
          caption: caption,
          invitedUserIds: contributors.map((e) => e.userId).toList(),
          albumImage: image);

      Map<String, dynamic> jsonResponse =
          json.decode(await response.stream.bytesToString());
      PublicAlbumPreview album = PublicAlbumPreview.fromJson(jsonResponse);
      return album;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SimpleUser>> getContributorsOfAlbum(String albumId) async {
    try {
      final response =
          await PublicAlbumDataProvider.getContributorsOfAlbum(albumId);
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

  // Future<int> addUsersToAlbum(
  //     String albumId, Set<SimpleUser> selectedUsers) async {
  //   try {
  //     final response = await PrivateAlbumDataProvider.addUsersToContributors(
  //         albumId, selectedUsers);
  //     if (response.statusCode == 200) {
  //       return 200;
  //     } else {
  //       throw Exception(response.body);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> removeUserFromAlbum(String albumId, String userId) async {
    try {
      final response =
          await PublicAlbumDataProvider.removeUserFromAlbum(albumId, userId);
      if (!(response.statusCode == 204)) {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  getAlbumSuggestionsForUser(String userId, int page, int pageSize) async {
    try {
      final response = await PublicAlbumDataProvider.getAlbumSuggestionsForUser(
          userId, page, pageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        List<PublicAlbumPreview> previews = [];
        for (var content in responseJson["content"]) {
          List<PublicMemory> recentMemories = [];
          for (var memoryMap in content["recentMemories"]) {
            PublicMemory memory = PublicMemory.fromJson(memoryMap);
            recentMemories.add(memory);
          }
          PublicAlbumPreview preview = PublicAlbumPreview.fromJson(content);
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

  // Future<SimpleUser> getContributorOfAlbumById(
  //     String albumId, String contributorId) async {
  //   try {
  //     final response = await PrivateAlbumDataProvider.getContributorOfAlbumById(
  //         albumId, contributorId);
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseJson = json.decode(response.body);
  //       SimpleUser user = SimpleUser.fromMap(responseJson);
  //       return user;
  //     } else {
  //       throw Exception(response.body);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<DisposableCamera> activateDisposableCamera(
  //     String albumId, String description) async {
  //   try {
  //     final response = await PrivateAlbumDataProvider.activateDisposableCamera(
  //         albumId, description);
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseJson = json.decode(response.body);
  //       DisposableCamera disposableCamera =
  //           DisposableCamera.fromJson(responseJson);
  //       return disposableCamera;
  //     } else {
  //       throw Exception(response.body);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // deactivateDisposableCamera(String albumId) async {
  //   try {
  //     final response =
  //         await PrivateAlbumDataProvider.deactivateDisposableCamera(albumId);
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseJson = json.decode(response.body);
  //       DisposableCamera disposableCamera =
  //           DisposableCamera.fromJson(responseJson);
  //       return disposableCamera;
  //     } else {
  //       throw Exception(response.body);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
