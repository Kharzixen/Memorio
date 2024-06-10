class LoginResponse {
  String accessToken;
  String refreshToken;

  LoginResponse({required this.accessToken, required this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String);
  }

  factory LoginResponse.fromRefreshJson(Map<String, dynamic> json) {
    return LoginResponse(
        accessToken: json['newAccessToken'] as String,
        refreshToken: json['newRefreshToken'] as String);
  }
}

class RegisterResponse {
  String userId;
  String username;

  RegisterResponse({required this.userId, required this.username});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
        userId: json['userId'].toString(),
        username: json['username'] as String);
  }

  // factory LoginResponse.fromRefreshJson(Map<String, dynamic> json) {
  //   return LoginResponse(
  //       accessToken: json['newAccessToken'] as String,
  //       refreshToken: json['newRefreshToken'] as String);
  // }
}
