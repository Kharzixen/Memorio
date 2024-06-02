import 'dart:typed_data';

import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PostDataProvider {
  static Future<http.Response> getPostsOfUserOrderedByDate(
      String userId, int page, int pageSize) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$userId/posts?page=$page&pageSize=$pageSize"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.StreamedResponse> createPost(
      String userId, String caption, Uint8List image) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("${StorageService.connectionString}/api/posts"));
      request.files.add(
        http.MultipartFile.fromBytes('image', image,
            filename: "asd", contentType: MediaType('image', 'jpg')),
      );

      request.fields['uploaderId'] = userId;
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

  static Future<http.Response> getPostById(String postId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(Uri.parse("${StorageService.connectionString}/api/posts/$postId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> deletePostById(String postId) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .delete(
            Uri.parse("${StorageService.connectionString}/api/posts/$postId"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
