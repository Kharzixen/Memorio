import 'dart:convert';

import 'package:frontend/model/album_model.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;

class CollectionDataProvider {
  static Future<http.Response> getCollectionsOfAlbum(
      String albumId, int page, int pageSize,
      [bool containLatestMemories = false]) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/albums/$albumId/collections?page=$page&pageSize=$pageSize&containLatestMemories=$containLatestMemories"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getCollectionPreviewById(
      String albumId, String collectionId) {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/albums/$albumId/collections/$collectionId"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> createCollection(String albumId, String userId,
      String collectionName, String collectionDescription) {
    Map<String, dynamic> requestBody = {
      'albumId': albumId,
      'creatorId': userId,
      'collectionName': collectionName,
      'collectionDescription': collectionDescription,
    };

    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/albums/$albumId/collections"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> patchCollectionAddImages(
      String albumId, String collectionId, List<Memory> selectedMemories) {
    Map<String, dynamic> requestBody = {
      'method': "ADD",
      'memoryIds': selectedMemories.map((e) => e.memoryId).toList(),
    };

    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/albums/$albumId/collections/$collectionId/memories"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> deleteCollection(
      String albumId, String collectionId) {
    return http
        .delete(Uri.parse(
            "${StorageService.connectionString}/api/albums/$albumId/collections/$collectionId"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
