import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:http/http.dart' as http;

class PublicAlbumDataProvider {
  static Future<http.Response> getAlbumPreviewPage(
      String userId, int page, int pageSize) async {
    Map<String, String> headers =
        await HttpHeadersFactory.getDefaultRequestHeader();
    return http
        .get(
            Uri.parse(
                "${StorageService.connectionString}/api/users/$userId/public-albums?page=$page&pageSize=$pageSize"),
            headers: headers)
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
