import 'dart:typed_data';
import 'package:frontend/service/storage_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class AlbumDataProvider {
  static Future<http.Response> getAlbumInfo(String albumId) async {
    return http
        .get(
            Uri.parse("${StorageService.connectionString}/api/albums/$albumId"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.Response> getAlbumPreviewPage(
      String userId, int page, int pageSize) async {
    return http
        .get(Uri.parse(
            "${StorageService.connectionString}/api/albums/users/$userId/album-previews?page=$page&pageSize=$pageSize"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  static Future<http.StreamedResponse> createAlbum(
      {required String ownerId,
      required String albumName,
      String caption = "",
      required List<String> invitedUserIds,
      required Uint8List albumImage}) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("${StorageService.connectionString}/api/albums"));
      request.files.add(
        http.MultipartFile.fromBytes('image', albumImage,
            filename: "albumImage", contentType: MediaType('image', 'jpg')),
      );

      request.fields['ownerId'] = ownerId;
      request.fields['albumName'] = albumName;
      request.fields['caption'] = caption;
      var concatenatedString = invitedUserIds.join(',');
      request.fields['invitedUserIds'] = concatenatedString;

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
}
