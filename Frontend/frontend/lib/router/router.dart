import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/ui/pages/auth/auth_page.dart';
import 'package:frontend/ui/pages/auth/login_page.dart';
import 'package:frontend/ui/pages/auth/registration_page.dart';
import 'package:frontend/ui/pages/main/home_page.dart';
import 'package:frontend/ui/widgets/navbar.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

class AppRouter {
  final GoRouter router = GoRouter(
      initialLocation: '/',
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          name: "auth",
          builder: (context, state) => const AuthPage(),
          routes: [
            GoRoute(
              name:
                  'login', // Optional, add name to your routes. Allows you navigate by name instead of path
              path: 'login',
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              name:
                  'register', // Optional, add name to your routes. Allows you navigate by name instead of path
              path: 'register',
              builder: (context, state) => const RegistrationPage(),
            ),
          ],
        ),
        ShellRoute(
            navigatorKey: _shellKey,
            builder: (context, state, child) {
              return Scaffold(
                backgroundColor: Colors.black,
                bottomNavigationBar: const CustomNavBar(),
                body: child,
              );
            },
            routes: [
              GoRoute(
                  path: "/discover",
                  builder: ((context, state) {
                    //return DiscoverPage();
                    return const Placeholder();
                  })),
              GoRoute(
                  path: "/gallery",
                  builder: ((context, state) {
                    //return GalleryPage();
                    return const Placeholder();
                  })),
              GoRoute(
                  path: "/create",
                  builder: ((context, state) {
                    //return AddContentPage();
                    return const Placeholder();
                  })),
              GoRoute(
                  path: "/profile",
                  builder: ((context, state) {
                    //return ProfilePage();
                    return const Placeholder();
                  })),
              GoRoute(
                path: '/users/:userID',
                builder: (BuildContext context, GoRouterState state) {
                  //final id = state.pathParameters['userID']!;
                  //return UserProfilePage(id: id);
                  return const Placeholder();
                },
              ),
              GoRoute(
                path: '/locations/:locationID',
                builder: (BuildContext context, GoRouterState state) {
                  //final id = state.pathParameters['locationID']!;
                  //return LocationPage(id: id);
                  return const Placeholder();
                },
              ),
              GoRoute(
                path: "/home",
                builder: (context, state) {
                  //return HomePage();
                  return const HomePage();
                },
                routes: [
                  GoRoute(
                      path: "announcements",
                      builder: (context, state) {
                        //return AnnouncementsPage();
                        return const Placeholder();
                      }),
                  GoRoute(
                      path: "thoughts",
                      builder: (context, state) {
                        //return ThoughtsPage();
                        return const Placeholder();
                      }),
                  GoRoute(
                      path: "stories",
                      builder: (context, state) {
                        //return StoriesPage();
                        return const Placeholder();
                      }),
                ],
              ),
            ])
      ],
      redirect: (context, state) {
        AuthState authState = context.read<AuthBloc>().state;
        if (authState is AuthSuccess) {
          if (state.uri.toString() == "/" ||
              state.uri.toString() == "/login" ||
              state.uri.toString() == "/register") {
            return "/home";
          }
        }
        return state.uri.toString();
      });
}
