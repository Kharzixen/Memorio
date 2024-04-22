import 'dart:convert';

import 'package:frontend/data/data_provider/collection_data_provider.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

class CollectionRepository {
  Future<PaginatedResponse<CollectionPreview>> getCollectionsOfAlbum(
      String albumId, int page, int pageSize) async {
    try {
      var response = await CollectionDataProvider.getCollectionsOfAlbum(
          albumId, page, pageSize, true);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<CollectionPreview> paginatedResponse =
            PaginatedResponse.fromJson(
                responseJson, CollectionPreview.fromJson);
        return paginatedResponse;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CollectionPreview> getCollectionPreviewById(
      String albumId, String collectionId) async {
    var response = await CollectionDataProvider.getCollectionPreviewById(
        albumId, collectionId);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      return CollectionPreview.fromJson(responseJson);
    } else {
      throw Exception(response.body);
    }
  }

  Future<SimpleCollection> createCollection(String albumId, String userId,
      String collectionName, String collectionDescription) async {
    try {
      var response = await CollectionDataProvider.createCollection(
          albumId, userId, collectionName, collectionDescription);
      print(response.statusCode);
      if (response.statusCode == 201) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        return SimpleCollection.fromJson(responseJson);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<SimpleCollection>> getSimpleCollectionsOfAlbum(
      String albumId, int page, int pageSize) async {
    try {
      var response = await CollectionDataProvider.getCollectionsOfAlbum(
          albumId, page, pageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<SimpleCollection> paginatedResponse =
            PaginatedResponse.fromJson(responseJson, SimpleCollection.fromJson);
        return paginatedResponse;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }
}
