import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  bool loggedIn = false;
  String username = "kharzixen";
  String userId = "1";

  static String connectionString = "http://192.168.1.103:8080";
  String pfp =
      "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
  bool isLoggedIn() {
    return loggedIn;
  }

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  // Save access token
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  // Retrieve access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  // Delete access token
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }

  // Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  // Retrieve refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  // Delete refresh token
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  // Clear all tokens
  Future<void> clearTokens() async {
    await _secureStorage.deleteAll();
  }
}
