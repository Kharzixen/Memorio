class Authentication {
  static bool TryLogIn(String email, String passwd) {
    String correctMail = "mellau.mark@gmail.com";
    String correctPasswd = "123456";
    if (correctMail == email && correctPasswd == passwd) {
      return true;
    } else {
      return false;
    }
  }
}
