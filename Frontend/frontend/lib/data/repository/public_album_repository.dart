import 'dart:convert';

import 'package:frontend/data/data_provider/public_album_data_provider.dart';
import 'package:frontend/model/public_albums.dart';
import 'package:frontend/model/public_memory.dart';

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

  // Future<PrivateAlbumInfo> getAlbumHeaderInfo(String albumId) async {
  //   try {
  //     var response = await PrivateAlbumDataProvider.getAlbumInfo(albumId);
  //     Map<String, dynamic> responseJson = json.decode(response.body);
  //     PrivateAlbumInfo albumInfo = PrivateAlbumInfo.fromJson(responseJson);
  //     return albumInfo;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<PrivateAlbumPreview> createAlbum(
  //   String ownerId,
  //   String albumName,
  //   String caption,
  //   List<SimpleUser> contributors,
  //   Uint8List image,
  // ) async {
  //   try {
  //     var response = await PrivateAlbumDataProvider.createAlbum(
  //         ownerId: ownerId,
  //         albumName: albumName,
  //         caption: caption,
  //         invitedUserIds: contributors.map((e) => e.userId).toList(),
  //         albumImage: image);

  //     Map<String, dynamic> jsonResponse =
  //         json.decode(await response.stream.bytesToString());
  //     PrivateAlbumPreview album = PrivateAlbumPreview.fromJson(jsonResponse);
  //     return album;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<List<SimpleUser>> getContributorsOfAlbum(String albumId) async {
  //   try {
  //     final response =
  //         await PrivateAlbumDataProvider.getContributorsOfAlbum(albumId);
  //     if (response.statusCode == 200) {
  //       List<dynamic> contributorJsonList = json.decode(response.body);
  //       List<SimpleUser> contributors = [];
  //       for (var contributorJson in contributorJsonList) {
  //         SimpleUser user = SimpleUser.fromMap(contributorJson);
  //         contributors.add(user);
  //       }
  //       return contributors;
  //     } else {
  //       throw Exception(response.body);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

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

  // Future<void> removeUserFromAlbum(String albumId, String userId) async {
  //   try {
  //     final response =
  //         await PrivateAlbumDataProvider.removeUserFromAlbum(albumId, userId);
  //     if (!(response.statusCode == 204)) {
  //       throw Exception(response.body);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

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
