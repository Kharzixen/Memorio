import 'dart:convert';

import 'package:frontend/data/data_provider/private_collection_data_provider.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

class PrivateCollectionRepository {
  Future<PaginatedResponse<PrivateCollectionPreview>> getCollectionsOfAlbum(
      String albumId, int page, int pageSize) async {
    try {
      var response = await PrivateCollectionDataProvider.getCollectionsOfAlbum(
          albumId, page, pageSize, true);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<PrivateCollectionPreview> paginatedResponse =
            PaginatedResponse.fromJson(
                responseJson, PrivateCollectionPreview.fromJson);
        return paginatedResponse;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PrivateCollectionPreview> getCollectionPreviewById(
      String albumId, String collectionId) async {
    var response = await PrivateCollectionDataProvider.getCollectionPreviewById(
        albumId, collectionId);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return PrivateCollectionPreview.fromJson(responseJson);
    } else {
      throw Exception(response.body);
    }
  }

  Future<PrivateCollectionPreview> createCollection(
      String albumId,
      String userId,
      String collectionName,
      String collectionDescription) async {
    try {
      var response = await PrivateCollectionDataProvider.createCollection(
          albumId, userId, collectionName, collectionDescription);
      print(response.statusCode);
      if (response.statusCode == 201) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        return PrivateCollectionPreview.fromJson(responseJson);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<SimplePrivateCollection>>
      getSimpleCollectionsOfAlbum(
          String albumId, int page, int pageSize) async {
    try {
      var response = await PrivateCollectionDataProvider.getCollectionsOfAlbum(
          albumId, page, pageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<SimplePrivateCollection> paginatedResponse =
            PaginatedResponse.fromJson(
                responseJson, SimplePrivateCollection.fromJson);
        return paginatedResponse;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addMemoriesToCollection(
    String albumId,
    String collectionId,
    List<PrivateMemory> selectedMemories,
  ) async {
    try {
      var response =
          await PrivateCollectionDataProvider.patchCollectionAddImages(
              albumId, collectionId, selectedMemories);
      if (response.statusCode == 200) {
        return 200;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  void deleteCollection(String albumId, String collectionId) async {
    try {
      var response = await PrivateCollectionDataProvider.deleteCollection(
          albumId, collectionId);
      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
