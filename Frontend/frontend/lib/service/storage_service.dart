class StorageService {
  bool loggedIn = true;
  String username = "kharzixen";
  String userId = "1";

  static String connectionString = "http://192.168.1.103:8080";
  String pfp =
      "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
  bool isLoggedIn() {
    return loggedIn;
  }
}
