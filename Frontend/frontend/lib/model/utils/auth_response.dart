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
