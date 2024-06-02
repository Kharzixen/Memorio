import 'dart:convert';

import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;

class PrivateCollectionDataProvider {
  static Future<http.Response> getCollectionsOfAlbum(
      String albumId, int page, int pageSize,
      [bool containLatestMemories = false]) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/collections?page=$page&pageSize=$pageSize&containLatestMemories=$containLatestMemories"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getCollectionPreviewById(
      String albumId, String collectionId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/collections/$collectionId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> createCollection(String albumId, String userId,
      String collectionName, String collectionDescription) async {
    Map<String, dynamic> requestBody = {
      'albumId': albumId,
      'creatorId': userId,
      'collectionName': collectionName,
      'collectionDescription': collectionDescription,
    };

    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();

    return http
        .post(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/collections"),
            headers: headers,
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> patchCollectionAddImages(String albumId,
      String collectionId, List<PrivateMemory> selectedMemories) async {
    Map<String, dynamic> requestBody = {
      'method': "ADD",
      'memoryIds': selectedMemories.map((e) => e.memoryId).toList(),
    };

    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();

    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/collections/$collectionId/memories"),
            headers: headers,
            body: jsonEncode(requestBody))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> deleteCollection(
      String albumId, String collectionId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/collections/$collectionId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
