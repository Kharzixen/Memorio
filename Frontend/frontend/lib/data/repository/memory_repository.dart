import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/data/data_provider/memory_data_provider.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

class MemoryRepository {
  int pageCount = 12;

  Future<DetailedMemory> getMomentById(String albumId, String memoryId) async {
    try {
      var response = await MemoryDataProvider.getMemoryById(albumId, memoryId);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        DetailedMemory memory = DetailedMemory.fromJson(responseJson);
        return memory;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<Memory>> getMemoriesOrderedByDatePaginated(
      String albumId, int page,
      [String? collectionId]) async {
    try {
      if (collectionId == null) {
        var response = await MemoryDataProvider.getAlbumMemoriesOrderedByDate(
            albumId, page, pageCount);
        if (response.statusCode == 200) {
          Map<String, dynamic> responseJson = json.decode(response.body);
          PaginatedResponse<Memory> paginatedMemories =
              PaginatedResponse.fromJson(responseJson, Memory.fromJson);
          return paginatedMemories;
        } else {
          throw Exception(response.body);
        }
      } else {
        var response =
            await MemoryDataProvider.getCollectionMemoriesOrderedByDate(
                albumId, collectionId, page, pageCount);
        if (response.statusCode == 200) {
          Map<String, dynamic> responseJson = json.decode(response.body);
          PaginatedResponse<Memory> paginatedMemories =
              PaginatedResponse.fromJson(responseJson, Memory.fromJson);
          return paginatedMemories;
        } else {
          throw Exception(response.body);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Memory> createMemory(String userId, String albumId, String caption,
      List<String> collectionIds, Uint8List fileBytes) async {
    try {
      var response = await MemoryDataProvider.createMemory(
          userId, albumId, caption, collectionIds, fileBytes);
      String jsonBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        Map<String, dynamic> responseJson = json.decode(jsonBody);
        Memory createdMemory = Memory.fromJson(responseJson);
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
          await MemoryDataProvider.deleteMemoryById(albumId, memoryId);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<DetailedMemory> changeCollectionsOfMemory(String albumId,
      String collectionId, List<SimpleCollection> newCollections) async {
    try {
      var response = await MemoryDataProvider.patchCollectionsOfMemory(
          albumId, collectionId, newCollections);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        DetailedMemory memory = DetailedMemory.fromJson(responseJson);
        return memory;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<Memory>> getMemoriesWhichCanBeAddedToCollection(
      String albumId, String collectionId, String userId, int page) async {
    try {
      var response = await MemoryDataProvider
          .getMemoriesOfUserNotIncludedInCollectionOrderedByDate(
              albumId, collectionId, userId, page, pageCount);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<Memory> paginatedMemories =
            PaginatedResponse.fromJson(responseJson, Memory.fromJson);
        return paginatedMemories;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
