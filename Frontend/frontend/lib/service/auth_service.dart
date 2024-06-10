import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/model/utils/auth_response.dart';
import 'package:frontend/service/storage_service.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();

  // Factory constructor to return the same instance every time
  factory TokenManager() {
    return _instance;
  }

  // Private constructor
  TokenManager._internal();

  void initialize({required AuthRepository authRepository}) {
    _authRepository = authRepository;
  }

  // Fields to store tokens
  String? accessToken;
  String? refreshToken;
  AuthRepository? _authRepository;

  // // Method to get access token
  // Future<String> getAccessToken() async {
  //   if (JwtDecoder.isExpired(accessToken!)) {
  //     await refreshAccessToken();
  //   }
  //   return accessToken!;
  // }

  // Method to refresh the access token using the refresh token
  Future<void> refreshAccessToken() async {
    if (refreshToken == null) {
      throw Exception("Refresh token is null");
    }

    LoginResponse response = await _authRepository!.refreshToken(refreshToken!);
    if (response.accessToken != "") {
      await StorageService().saveAccessToken(response.accessToken);
      await StorageService().saveRefreshToken(response.refreshToken);
      accessToken = response.accessToken;
      refreshToken = response.refreshToken;
    }
  }
}
