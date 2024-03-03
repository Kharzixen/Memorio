import 'package:http/http.dart' as http;

class UserDataProvider {
  Future<http.Response> getProfileUser(String userId) async {
    return http
        .get(Uri.parse("http://192.168.1.101:8080/api/users/$userId"))
        .then((value) {
      return value;
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
