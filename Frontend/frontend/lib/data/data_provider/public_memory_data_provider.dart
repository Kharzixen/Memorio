import 'dart:convert';
import 'dart:typed_data';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PublicMemoryDataProvider {
  static createMemory(String userId, String albumId, String caption,
      Uint8List fileBytes) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "${StorageService.connectionString}/api/public-albums/$albumId/memories"));
      request.files.add(
        http.MultipartFile.fromBytes('image', fileBytes,
            filename: "asd", contentType: MediaType('image', 'jpg')),
      );

      request.fields['uploaderId'] = userId;
      request.fields['albumId'] = albumId;
      request.fields['caption'] = caption;

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

  static Future<http.Response> getAlbumMemoriesOrderedByDate(
      String albumId, int page, int pageCount) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/public-albums/$albumId/memories?page=$page&pageSize=$pageCount"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static getHighlightedMemoriesOfAlbumOrderedByDate(
      String albumId, int page, int pageSize) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/public-albums/$albumId/highlighted-memories?page=$page&pageSize=$pageSize"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static getPublicMemoryById(String albumId, String memoryId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/public-albums/$albumId/memories/$memoryId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static patchMemory(
      String albumId, String memoryId, Map<String, dynamic> body) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();

    return http
        .patch(
            Uri.parse(
                "${StorageService.connectionString}/api/public-albums/$albumId/memories/$memoryId"),
            headers: headers,
            body: json.encode(body))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> deleteMemoryById(
      String albumId, String memoryId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse(
                "${StorageService.connectionString}/api/public-albums/$albumId/memories/$memoryId"),
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
}
