import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/data/data_provider/private_memory_data_provider.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

class PrivateMemoryRepository {
  int pageCount = 12;

  Future<DetailedPrivateMemory> getMomentById(
      String albumId, String memoryId) async {
    try {
      var response =
          await PrivateMemoryDataProvider.getMemoryById(albumId, memoryId);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        DetailedPrivateMemory memory =
            DetailedPrivateMemory.fromJson(responseJson);
        return memory;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<PrivateMemory>> getMemoriesOrderedByDatePaginated(
      String albumId, int page,
      [String? collectionId]) async {
    try {
      if (collectionId == null) {
        var response =
            await PrivateMemoryDataProvider.getAlbumMemoriesOrderedByDate(
                albumId, page, pageCount);
        if (response.statusCode == 200) {
          Map<String, dynamic> responseJson = json.decode(response.body);
          PaginatedResponse<PrivateMemory> paginatedMemories =
              PaginatedResponse.fromJson(responseJson, PrivateMemory.fromJson);
          return paginatedMemories;
        } else {
          throw Exception(response.body);
        }
      } else {
        var response =
            await PrivateMemoryDataProvider.getCollectionMemoriesOrderedByDate(
                albumId, collectionId, page, pageCount);
        if (response.statusCode == 200) {
          Map<String, dynamic> responseJson = json.decode(response.body);
          PaginatedResponse<PrivateMemory> paginatedMemories =
              PaginatedResponse.fromJson(responseJson, PrivateMemory.fromJson);
          return paginatedMemories;
        } else {
          throw Exception(response.body);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PrivateMemory> createMemory(String userId, String albumId,
      String caption, List<String> collectionIds, Uint8List fileBytes) async {
    try {
      var response = await PrivateMemoryDataProvider.createMemory(
          userId, albumId, caption, collectionIds, fileBytes);
      String jsonBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        Map<String, dynamic> responseJson = json.decode(jsonBody);
        PrivateMemory createdMemory = PrivateMemory.fromJson(responseJson);
        return createdMemory;
      } else {
        throw Exception(jsonBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteMemory(String albumId, String memoryId) async {
    try {
      var response =
          await PrivateMemoryDataProvider.deleteMemoryById(albumId, memoryId);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<DetailedPrivateMemory> changeCollectionsOfMemory(String albumId,
      String collectionId, List<SimplePrivateCollection> newCollections) async {
    try {
      var response = await PrivateMemoryDataProvider.patchCollectionsOfMemory(
          albumId, collectionId, newCollections);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        DetailedPrivateMemory memory =
            DetailedPrivateMemory.fromJson(responseJson);
        return memory;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<PrivateMemory>>
      getMemoriesWhichCanBeAddedToCollection(
          String albumId, String collectionId, String userId, int page) async {
    try {
      var response = await PrivateMemoryDataProvider
          .getMemoriesOfUserNotIncludedInCollectionOrderedByDate(
              albumId, collectionId, userId, page, pageCount);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<PrivateMemory> paginatedMemories =
            PaginatedResponse.fromJson(responseJson, PrivateMemory.fromJson);
        return paginatedMemories;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<PrivateCollectionMemory>>
      getMemoriesOfCollectionOrderedByAddedDate(
          String albumId, int page, String collectionId) async {
    try {
      var response = await PrivateMemoryDataProvider
          .getCollectionMemoriesOrderedByAddedDate(
              albumId, collectionId, page, pageCount);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<PrivateCollectionMemory> paginatedMemories =
            PaginatedResponse.fromJson(
                responseJson, PrivateCollectionMemory.fromJson);
        return paginatedMemories;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<PrivateMemory>> getMemoriesOfUserInAlbum(
      String albumId, String contributorId, int page, int pageSize) async {
    try {
      var response = await PrivateMemoryDataProvider.getMemoriesOfUserInAlbum(
          albumId, contributorId, page, pageCount);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<PrivateMemory> paginatedMemories =
            PaginatedResponse.fromJson(responseJson, PrivateMemory.fromJson);
        return paginatedMemories;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
