import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class StorageService {
  String _username = "kharzixen";
  String _userId = "";

  static const String _connectionString = "http://192.168.1.103:8080";
  String _pfp =
      "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  // Singleton instance
  static final StorageService _instance = StorageService._internal();

  // Private constructor
  StorageService._internal();

  // Factory constructor
  factory StorageService() {
    return _instance;
  }

  // Getter for username
  String get username => _username;

  // Getter for userId
  String get userId => _userId;

  // Setter for userId
  set userId(String value) {
    _userId = value;
  }

  // Save access token
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
    _extractUserIdFromToken(token);
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

  void _extractUserIdFromToken(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (decodedToken.containsKey('id')) {
        _userId = decodedToken['id'];
      }
    } catch (e) {
      print('Error decoding JWT: $e');
    }
  }

  // Static getter for connection string
  static String get connectionString => _connectionString;

  // Getter for profile picture
  String get pfp => _pfp;

  // Setter for profile picture (optional)
  set pfp(String value) {
    _pfp = value;
  }
}
