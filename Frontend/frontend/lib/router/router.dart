import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_bloc/album_bloc.dart';
import 'package:frontend/bloc/album_preview_bloc/albums_preview_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/bloc/moment_bloc/moment_bloc.dart';
import 'package:frontend/bloc/profile_bloc/profile_bloc.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/data/repository/moment_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/ui/pages/auth/auth_page.dart';
import 'package:frontend/ui/pages/auth/login_page.dart';
import 'package:frontend/ui/pages/auth/registration_page.dart';
import 'package:frontend/ui/pages/main/albums_page.dart';
import 'package:frontend/ui/pages/main/home_page.dart';
import 'package:frontend/ui/pages/main/profile_page.dart';
import 'package:frontend/ui/pages/main/single_album_page.dart';
import 'package:frontend/ui/pages/main/single_moment_page.dart';
import 'package:frontend/ui/widgets/navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
                  path: "/albums",
                  builder: ((context, state) {
                    //return GalleryPage();
                    return Provider(
                        create: (context) => (AlbumRepository()),
                        child: BlocProvider(
                            create: (context) => AlbumsPreviewBloc(
                                context.read<AlbumRepository>()),
                            child: const AlbumsPreviewPage()));
                  }),
                  routes: [
                    GoRoute(
                      path: ':albumId',
                      builder: (context, state) {
                        final String id = state.pathParameters['albumId']!;
                        return Provider(
                          create: (context) => (AlbumRepository()),
                          child: BlocProvider(
                              create: (context) => AlbumBloc(
                                  albumRepository:
                                      context.read<AlbumRepository>()),
                              child: AlbumPage(albumId: id)),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: ':momentId',
                          builder: (context, state) {
                            final String albumId =
                                state.pathParameters['albumId']!;
                            final String momentId =
                                state.pathParameters['momentId']!;
                            return Provider(
                                create: (context) => (MomentRepository()),
                                child: BlocProvider(
                                    create: (context) => (MomentBloc(
                                        context.read<MomentRepository>())),
                                    child: MomentPage(
                                        albumId: albumId, momentId: momentId)));
                          },
                        ),
                      ],
                    )
                  ]),
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
                    return BlocProvider(
                      create: (context) =>
                          ProfileBloc(context.read<UserRepository>()),
                      child: const ProfilePage(),
                    );
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
