import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_bloc/album_bloc.dart';
import 'package:frontend/bloc/album_creation_bloc/album_creation_bloc.dart';
import 'package:frontend/bloc/album_preview_bloc/albums_preview_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/bloc/collection_preview_bloc/collections_preview_bloc.dart';
import 'package:frontend/bloc/memory_creation_bloc/memory_creation_bloc.dart';
import 'package:frontend/bloc/moment_bloc/moment_bloc.dart';
import 'package:frontend/bloc/profile_bloc/profile_bloc.dart';
import 'package:frontend/bloc/select_collections_sheet_bloc/select_collections_sheet_bloc.dart';
import 'package:frontend/bloc/timeline_bloc/timeline_bloc.dart';
import 'package:frontend/cubit/add_memories_to_collection_cubit/add_memories_to_collection_cubit.dart';
import 'package:frontend/cubit/collection_creation_cubit/collection_creation_cubit.dart';
import 'package:frontend/cubit/collection_cubit/collection_cubit.dart';
import 'package:frontend/cubit/invitation_cubit/invitation_cubit.dart';
import 'package:frontend/cubit/user_cubit/user_cubit.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/data/repository/collection_repository.dart';
import 'package:frontend/data/repository/memory_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_creation_details.dart';
import 'package:frontend/ui/pages/auth/auth_page.dart';
import 'package:frontend/ui/pages/auth/login_page.dart';
import 'package:frontend/ui/pages/auth/registration_page.dart';
import 'package:frontend/ui/pages/main/add_memories_to_collection_page.dart';
import 'package:frontend/ui/pages/main/album_info_page.dart';
import 'package:frontend/ui/pages/main/album_invitation_page.dart';
import 'package:frontend/ui/pages/main/albums_page.dart';
import 'package:frontend/ui/pages/main/create_album_page.dart';
import 'package:frontend/ui/pages/main/create_collection_page.dart';
import 'package:frontend/ui/pages/main/create_memory_page.dart';
import 'package:frontend/ui/pages/main/edit_collections_of_memory_page.dart';
import 'package:frontend/ui/pages/main/home_page.dart';
import 'package:frontend/ui/pages/main/profile_page.dart';
import 'package:frontend/ui/pages/main/single_album_page.dart';
import 'package:frontend/ui/pages/main/single_collection_page.dart';
import 'package:frontend/ui/pages/main/single_moment_page.dart';
import 'package:frontend/ui/pages/main/user_page.dart';
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
                  path: "/albums",
                  builder: ((context, state) {
                    //return GalleryPage();
                    return BlocProvider(
                        create: (context) =>
                            AlbumsPreviewBloc(context.read<AlbumRepository>()),
                        child: const AlbumsPreviewPage());
                  }),
                  routes: [
                    GoRoute(
                      path: ':albumId',
                      builder: (context, state) {
                        final String id = state.pathParameters['albumId']!;
                        SimpleAlbum simpleAlbum = state.extra as SimpleAlbum;
                        state.extra as SimpleAlbum;
                        return BlocProvider(
                          create: (context) => TimelineBloc(
                              memoryRepository:
                                  context.read<MemoryRepository>()),
                          child: BlocProvider(
                            create: (context) => CollectionsPreviewBloc(
                                collectionRepository:
                                    context.read<CollectionRepository>()),
                            child: AlbumPage(
                              albumId: id,
                              simpleAlbum: simpleAlbum,
                            ),
                          ),
                        );
                      },
                      routes: [
                        GoRoute(
                            path: 'memories/:memoryId',
                            builder: (context, state) {
                              final String albumId =
                                  state.pathParameters['albumId']!;
                              final String memoryId =
                                  state.pathParameters['memoryId']!;
                              return BlocProvider(
                                  create: (context) => (MomentBloc(
                                      context.read<MemoryRepository>())),
                                  child: MemoryPage(
                                      albumId: albumId, memoryId: memoryId));
                            },
                            routes: [
                              GoRoute(
                                  path: 'edit-collections',
                                  builder: (context, state) {
                                    final DetailedMemory memory =
                                        state.extra as DetailedMemory;
                                    return BlocProvider(
                                        create: (context) =>
                                            SelectCollectionsSheetBloc(
                                                collectionRepository:
                                                    context.read<
                                                        CollectionRepository>(),
                                                initiallyIncludedCollections:
                                                    memory.collections),
                                        child: EditCollectionOfMemoryPage(
                                            memory: memory));
                                  })
                            ]),
                        GoRoute(
                            path: 'collections/:collectionId',
                            builder: (context, state) {
                              final String albumId =
                                  state.pathParameters['albumId']!;
                              final String collectionId =
                                  state.pathParameters['collectionId']!;
                              return BlocProvider(
                                create: (context) => CollectionPageCubit(
                                    context.read<CollectionRepository>(),
                                    context.read<MemoryRepository>()),
                                child: SingleCollectionPage(
                                  albumId: albumId,
                                  collectionId: collectionId,
                                ),
                              );
                            },
                            routes: [
                              GoRoute(
                                path: 'add-photos',
                                builder: (context, state) {
                                  final String albumId =
                                      state.pathParameters['albumId']!;
                                  final String collectionId =
                                      state.pathParameters['collectionId']!;
                                  return BlocProvider(
                                    create: (context) =>
                                        AddMemoriesToCollectionCubit(
                                            context
                                                .read<CollectionRepository>(),
                                            context.read<MemoryRepository>()),
                                    child: AddMemoriesToCollectionPage(
                                      albumId: albumId,
                                      collectionId: collectionId,
                                    ),
                                  );
                                },
                              )
                            ]),
                        GoRoute(
                            path: 'details',
                            builder: (context, state) {
                              final String albumId =
                                  state.pathParameters['albumId']!;
                              return BlocProvider(
                                  create: (context) => (AlbumBloc(
                                      albumRepository:
                                          context.read<AlbumRepository>())),
                                  child: AlbumInfoPage(albumId: albumId));
                            }),
                        GoRoute(
                          path: 'create-collection',
                          builder: (context, state) {
                            final String albumId =
                                state.pathParameters['albumId']!;
                            return BlocProvider(
                              create: (context) => CollectionCreationCubit(
                                  context.read<CollectionRepository>()),
                              child: CreateCollectionPage(
                                albumId: albumId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'invitations-page',
                          builder: (context, state) {
                            final String albumId =
                                state.pathParameters['albumId']!;
                            return BlocProvider(
                                create: (context) => InvitationCubit(
                                    context.read<AlbumRepository>(),
                                    context.read<UserRepository>()),
                                child: AlbumInvitationPage(
                                  albumId: albumId,
                                ));
                          },
                        ),
                      ],
                    )
                  ]),
              GoRoute(
                path: "/createMemory",
                builder: (context, state) {
                  print(state.extra);
                  MemoryCreationDetails memoryCreationDetails =
                      state.extra as MemoryCreationDetails;
                  return BlocProvider(
                    create: (context) =>
                        MemoryCreationBloc(context.read<MemoryRepository>()),
                    child: CreateMemoryPage(
                      memoryCreationDetails: memoryCreationDetails,
                    ),
                  );
                },
              ),
              GoRoute(
                path: "/createAlbum",
                builder: (context, state) {
                  return BlocProvider(
                    create: (context) => AlbumCreationBloc(
                        albumRepository: context.read<AlbumRepository>(),
                        userRepository: context.read<UserRepository>()),
                    child: CreateAlbumPage(),
                  );
                },
              ),
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
                  final id = state.pathParameters['userID']!;
                  return BlocProvider(
                      create: (context) =>
                          UserCubit(context.read<UserRepository>())
                            ..fetchUserData(id),
                      child: UserProfilePage(id: id));
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
