import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:licence_frontend/components/scaffold%20components/navBar.dart';
import 'package:licence_frontend/pages/auth/authPage.dart';
import 'package:licence_frontend/pages/auth/loginPage.dart';
import 'package:licence_frontend/pages/auth/registerPage.dart';
import 'package:licence_frontend/pages/content/announcements.dart';
import 'package:licence_frontend/pages/content/main/addContent.dart';
import 'package:licence_frontend/pages/content/main/discover.dart';
import 'package:licence_frontend/pages/content/main/galleryPage.dart';
import 'package:licence_frontend/pages/content/main/homePage.dart';
import 'package:licence_frontend/pages/content/nonUserProfilePage.dart';
import 'package:licence_frontend/pages/content/settings.dart';
import 'package:licence_frontend/pages/content/storiesPage.dart';
import 'package:licence_frontend/pages/content/thoughts.dart';
import 'package:licence_frontend/pages/content/main/profilePage.dart';

import '../pages/content/locationPage.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

class AppRouter {
  final GoRouter router =
      GoRouter(initialLocation: '/', navigatorKey: _rootNavigatorKey, routes: [
    GoRoute(
        path: "/settings",
        name: "settings",
        builder: (context, state) => SettingsPage()),
    GoRoute(
      name:
          'auth', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => AuthPage(),
      routes: [
        GoRoute(
          name:
              'login', // Optional, add name to your routes. Allows you navigate by name instead of path
          path: 'login',
          builder: (context, state) => LoginForm(),
        ),
        GoRoute(
          name:
              'register', // Optional, add name to your routes. Allows you navigate by name instead of path
          path: 'register',
          builder: (context, state) => RegistrationForm(),
        ),
      ],
    ),
    ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            bottomNavigationBar: MyNavBar(),
            body: child,
          );
        },
        routes: [
          GoRoute(
              path: "/discover",
              builder: ((context, state) {
                return DiscoverPage();
              })),
          GoRoute(
              path: "/gallery",
              builder: ((context, state) {
                return GalleryPage();
              })),
          GoRoute(
              path: "/create",
              builder: ((context, state) {
                return AddConetntPage();
              })),
          GoRoute(
              path: "/profile",
              builder: ((context, state) {
                return ProfilePage();
              })),
          GoRoute(
            path: '/users/:userID',
            builder: (BuildContext context, GoRouterState state) {
              final id = state.pathParameters['userID']!;
              return NonUserProfilePage(id: id);
            },
          ),
          GoRoute(
            path: '/locations/:locationID',
            builder: (BuildContext context, GoRouterState state) {
              final id = state.pathParameters['locationID']!;
              return LocationPage(id: id);
            },
          ),
          GoRoute(
            path: "/home",
            builder: (context, state) {
              return HomePage();
            },
            routes: [
              GoRoute(
                  path: "announcements",
                  builder: (context, state) {
                    return AnnouncementsPage();
                  }),
              GoRoute(
                  path: "thoughts",
                  builder: (context, state) {
                    return ThoughtsPage();
                  }),
              GoRoute(
                  path: "stories",
                  builder: (context, state) {
                    return StoriessPage();
                  }),
            ],
          ),
        ])
  ]);
}

Widget _leadButton(BuildContext context) {
  return IconButton(
    icon: const Icon(
      Icons.navigate_before,
      size: 20,
    ),
    onPressed: () {
      context.pop();
    },
  );
}
