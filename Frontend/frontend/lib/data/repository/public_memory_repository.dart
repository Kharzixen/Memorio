import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/data/data_provider/public_memory_data_provider.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

class PublicMemoryRepository {
  Future<PublicMemory> createMemory(String userId, String albumId,
      String caption, Uint8List fileBytes) async {
    try {
      var response = await PublicMemoryDataProvider.createMemory(
          userId, albumId, caption, fileBytes);
      String jsonBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        Map<String, dynamic> responseJson = json.decode(jsonBody);
        PublicMemory createdMemory = PublicMemory.fromJson(responseJson);
        return createdMemory;
      } else {
        throw Exception(jsonBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  getMemoriesOfPublicAlbum(String albumId, int page, int pageSize) async {
    try {
      var response =
          await PublicMemoryDataProvider.getAlbumMemoriesOrderedByDate(
              albumId, page, pageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<PublicMemory> paginatedMemories =
            PaginatedResponse.fromJson(responseJson, PublicMemory.fromJson);
        return paginatedMemories;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  getHighlightedMemoriesOfPublicAlbum(
      String albumId, int page, int pageSize) async {
    try {
      var response = await PublicMemoryDataProvider
          .getHighlightedMemoriesOfAlbumOrderedByDate(albumId, page, pageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<PublicMemory> paginatedMemories =
            PaginatedResponse.fromJson(responseJson, PublicMemory.fromJson);
        return paginatedMemories;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DetailedPublicMemory> getMemoryById(
      String albumId, String memoryId) async {
    try {
      var response =
          await PublicMemoryDataProvider.getPublicMemoryById(albumId, memoryId);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        DetailedPublicMemory memory =
            DetailedPublicMemory.fromJson(responseJson);
        return memory;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  changeHighlightStatusOfMemory(
      String albumId, String memoryId, bool newHighlightStatus) async {
    try {
      Map<String, dynamic> body = {"isHighlighted": newHighlightStatus};
      var response =
          await PublicMemoryDataProvider.patchMemory(albumId, memoryId, body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        DetailedPublicMemory memory =
            DetailedPublicMemory.fromJson(responseJson);
        return memory;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteMemory(String albumId, String memoryId) async {
    try {
      var response =
          await PublicMemoryDataProvider.deleteMemoryById(albumId, memoryId);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
