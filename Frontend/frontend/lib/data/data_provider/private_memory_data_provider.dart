import 'dart:convert';
import 'dart:typed_data';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class PrivateMemoryDataProvider {
  static Future<http.Response> getAlbumMemoriesOrderedByDate(
      String albumId, int page, int pageCount) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories?page=$page&pageSize=$pageCount"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getCollectionMemoriesOrderedByDate(
      String albumId, String collectionId, int page, int pageCount) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/collections/$collectionId/memories?page=$page&pageSize=$pageCount"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getMemoryById(
      String albumId, String memoryId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.StreamedResponse> createMemory(
      String userId,
      String albumId,
      String caption,
      List<String> collectionIds,
      Uint8List fileBytes) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "${StorageService.connectionString}/api/private-albums/$albumId/memories"));
      request.files.add(
        http.MultipartFile.fromBytes('image', fileBytes,
            filename: "asd", contentType: MediaType('image', 'jpg')),
      );

      request.fields['uploaderId'] = userId;
      request.fields['albumId'] = albumId;
      request.fields['caption'] = caption;
      var concatenatedString = collectionIds.join(',');
      request.fields['collectionIds'] = concatenatedString;

      Map<String, String> headers =
          await HttpHeadersFactory.getDefaultRequestHeader();

      request.headers.addAll(headers);

      return await request.send().then((value) {
        return value;
      }).catchError((error) {
        throw Exception(error);
      });
    } catch (e) {
      // Handle errors
      print('Error uploading file: $e');
      rethrow;
    }
  }

  static Future<http.Response> deleteMemoryById(
      String albumId, String memoryId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId"),
            headers: headers)
        .then(
      (value) {
        return value;
      },
    ).catchError(
      (error) {
        throw Exception(error);
      },
    );
  }

  static Future<http.Response> patchCollectionsOfMemory(String albumId,
      String memoryId, List<SimplePrivateCollection> newCollections) async {
    Map<String, dynamic> requestBody = {
      "collectionIds": newCollections.map((e) => e.collectionId).toList()
    };
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories/$memoryId/collections"),
            headers: headers,
            body: jsonEncode(requestBody))
        .then(
      (value) {
        return value;
      },
    ).catchError(
      (error) {
        throw Exception(error);
      },
    );
  }

  static Future<http.Response>
      getMemoriesOfUserNotIncludedInCollectionOrderedByDate(String albumId,
          String collectionId, String userId, int page, int pageCount) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories?uploaderId=$userId&notIncludedInCollectionId=$collectionId&page=$page&pageSize=$pageCount"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getMemoriesOfUserInAlbum(
      String albumId, String contributorId, int page, int pageCount) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/memories?uploaderId=$contributorId&page=$page&pageSize=$pageCount"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getCollectionMemoriesOrderedByAddedDate(
      String albumId, String collectionId, int page, int pageCount) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/collections/$collectionId/memories?page=$page&pageSize=$pageCount"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
