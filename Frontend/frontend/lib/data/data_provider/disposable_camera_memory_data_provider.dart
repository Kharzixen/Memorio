import 'dart:typed_data';

import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class DisposableCameraMemoryDataProvider {
  static Future<http.Response> getMemoriesOfUserInDisposableCamera(
      String albumId, String userId, int page, int pageCount) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/disposable-camera/memories?uploaderId=$userId&page=$page&pageSize=$pageCount"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getAllMemoriesInDisposableCamera(
      String albumId, int page, int pageCount) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/disposable-camera/memories?page=$page&pageSize=$pageCount"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getDisposableCameraMemoryById(
      String albumId, String memoryId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/disposable-camera/memories/$memoryId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.StreamedResponse> createDisposableCameraMemory(
      String userId, String albumId, String caption, Uint8List image) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "${StorageService.connectionString}/api/private-albums/$albumId/disposable-camera/memories"));
      request.files.add(
        http.MultipartFile.fromBytes('image', image,
            filename: "image_file", contentType: MediaType('image', 'jpg')),
      );

      request.fields['uploaderId'] = userId;
      request.fields['albumId'] = albumId;
      request.fields['collectionIds'] = "";
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

  static deleteDisposableCameraMemoryById(
      String albumId, String memoryId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse(
                "${StorageService.connectionString}/api/private-albums/$albumId/disposable-camera/memories/$memoryId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
