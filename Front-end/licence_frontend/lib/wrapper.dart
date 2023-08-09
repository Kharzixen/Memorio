import 'package:flutter/material.dart';
import 'package:licence_frontend/pages/auth/authPage.dart';
import 'package:licence_frontend/pages/content/announcements.dart';
import 'package:licence_frontend/pages/content/main/homePage.dart';
import 'package:licence_frontend/pages/auth/loginPage.dart';
import 'package:licence_frontend/pages/content/thoughts.dart';
import 'package:licence_frontend/pages/content/main/profilePage.dart';
import 'package:licence_frontend/pages/auth/registerPage.dart';

class WrapperWidget extends StatelessWidget {
  const WrapperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String state = "thoughts";
    switch (state) {
      case "profile":
        return ProfilePage();
      case "register":
        return RegistrationForm();
      case "login":
        return LoginForm();
      case "auth":
        return AuthPage();
      case "home":
        return HomePage();
      case "announcements":
        return AnnouncementsPage();
      case "thoughts":
        return ThoughtsPage();
      default:
        return AuthPage();
    }
  }
}
