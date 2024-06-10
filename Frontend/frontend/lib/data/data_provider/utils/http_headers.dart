import 'package:frontend/service/auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HttpHeadersFactory {
  static Future<Map<String, String>> getDefaultRequestHeader() async {
    bool hasExpired = JwtDecoder.isExpired(TokenManager().accessToken!);
    if (hasExpired) {
      bool refreshTokenHasExpired =
          JwtDecoder.isExpired(TokenManager().refreshToken!);
      if (!refreshTokenHasExpired) {
        await TokenManager().refreshAccessToken();
      }
    }
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${TokenManager().accessToken}',
      'ngrok-skip-browser-warning': "1"
    };

    return requestHeaders;
  }

  static Map<String, String> getDefaultRequestHeaderForImage(
      String accessToken) {
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $accessToken',
    };
    return requestHeaders;
  }
}
