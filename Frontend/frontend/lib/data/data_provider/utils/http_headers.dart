import 'package:frontend/service/auth_service.dart';

class HttpHeadersFactory {
  static Future<Map<String, String>> getDefaultRequestHeader() async {
    // bool hasExpired = JwtDecoder.isExpired(TokenManager().accessToken!);
    // if (hasExpired) {
    //   bool refreshTokenHasExpired =
    //       JwtDecoder.isExpired(TokenManager().refreshToken!);
    //   if (!refreshTokenHasExpired) {
    //     await TokenManager().refreshAccessToken();
    //   }
    // }
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
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
