import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/auth_page.dart';
import 'package:frontend/ui/pages/login_page.dart';
import 'package:frontend/ui/pages/registration_page.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

class AppRouter {
  final GoRouter router =
      GoRouter(initialLocation: '/', navigatorKey: _rootNavigatorKey, routes: [
    GoRoute(
      path: '/',
      name: "auth",
      builder: (context, state) => const AuthPage(),
      routes: [
        GoRoute(
          name:
              'login', // Optional, add name to your routes. Allows you navigate by name instead of path
          path: 'login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          name:
              'register', // Optional, add name to your routes. Allows you navigate by name instead of path
          path: 'register',
          builder: (context, state) => RegistrationPage(),
        ),
      ],
    ),
  ]);
}
