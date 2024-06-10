import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_bloc/private-album_bloc.dart';
import 'package:frontend/bloc/album_creation_bloc/album_creation_bloc.dart';
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
import 'package:frontend/cubit/contributor_cubit/contributor_cubit.dart';
import 'package:frontend/cubit/create_disposable_camera_memory_cubit/create_disposable_camera_memory_cubit.dart';
import 'package:frontend/cubit/create_post_cubit/create_post_cubit.dart';
import 'package:frontend/cubit/disposable_camera_cubit/disposable_camera_cubit.dart';
import 'package:frontend/cubit/disposable_camera_memory_cubit/disposable_camera_memory_cubit.dart';
import 'package:frontend/cubit/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:frontend/cubit/following_suggestion_cubit/following_suggestion_cubit.dart';
import 'package:frontend/cubit/highlighted_memories_cubit/highlighted_memories_cubit.dart';
import 'package:frontend/cubit/home_cubit/home_cubit.dart';
import 'package:frontend/cubit/invitation_cubit/invitation_cubit.dart';
import 'package:frontend/cubit/post_cubit/post_cubit.dart';
import 'package:frontend/cubit/public_album_creation_cubit/public_album_creation_cubit.dart';
import 'package:frontend/cubit/public_album_cubit.dart/public_album_cubit.dart';
import 'package:frontend/cubit/public_memories_cubit/public_memories_cubit.dart';
import 'package:frontend/cubit/public_memory_creation_cubit/public_memory_creation_cubit.dart';
import 'package:frontend/cubit/public_memory_cubit/public_memory_cubit.dart';
import 'package:frontend/cubit/user_cubit/user_cubit.dart';
import 'package:frontend/data/repository/disposable_camera_memory_repository.dart';
import 'package:frontend/data/repository/memory_like_repository.dart';
import 'package:frontend/data/repository/post_like_repository.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/data/repository/private_collection_repository.dart';
import 'package:frontend/data/repository/private_memory_repository.dart';
import 'package:frontend/data/repository/post_repository.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/data/repository/public_memory_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/memory_creation_details.dart';
import 'package:frontend/model/utils/post_creation_details.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/pages/auth/auth_page.dart';
import 'package:frontend/ui/pages/auth/login_page.dart';
import 'package:frontend/ui/pages/auth/registration_page.dart';
import 'package:frontend/ui/pages/main/albums_preview_page.dart';
import 'package:frontend/ui/pages/main/create_disposable_camera_memory_page.dart';
import 'package:frontend/ui/pages/main/create_public_album_page.dart';
import 'package:frontend/ui/pages/main/create_public_memory_page.dart';
import 'package:frontend/ui/pages/main/disposable_camera_memory_page.dart';
import 'package:frontend/ui/pages/main/edit_profille_page.dart';
import 'package:frontend/ui/pages/main/private_album_add_memories_to_collection_page.dart';
import 'package:frontend/ui/pages/main/private_album_info_page.dart';
import 'package:frontend/ui/pages/main/private_album_invitation_page.dart';
import 'package:frontend/ui/pages/main/private_album_contributor_page.dart';
import 'package:frontend/ui/pages/main/create_private_album_page.dart';
import 'package:frontend/ui/pages/main/create_private_collection_page.dart';
import 'package:frontend/ui/pages/main/create_private_memory_page.dart';
import 'package:frontend/ui/pages/main/create_post_page.dart';
import 'package:frontend/ui/pages/main/discover_page.dart';
import 'package:frontend/ui/pages/main/edit_collections_of_memory_page.dart';
import 'package:frontend/ui/pages/main/home_page.dart';
import 'package:frontend/ui/pages/main/memory_vault_page.dart';
import 'package:frontend/ui/pages/main/profile_page.dart';
import 'package:frontend/ui/pages/main/private_album_page.dart';
import 'package:frontend/ui/pages/main/private_collection_page.dart';
import 'package:frontend/ui/pages/main/private_memory_page.dart';
import 'package:frontend/ui/pages/main/public_album_info_page.dart';
import 'package:frontend/ui/pages/main/public_album_page.dart';
import 'package:frontend/ui/pages/main/public_memory_page.dart';
import 'package:frontend/ui/pages/main/single_post_page.dart';
import 'package:frontend/ui/pages/main/user_page.dart';
import 'package:frontend/ui/widgets/navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
                    return BlocProvider(
                        create: (context) => FollowingSuggestionCubit(
                            context.read<UserRepository>()),
                        child: const DiscoverPage());
                  })),
              GoRoute(
                  path: "/public-albums/:albumId",
                  builder: (context, state) {
                    final String id = state.pathParameters['albumId']!;
                    AlbumPreview albumPreview = state.extra as AlbumPreview;
                    return BlocProvider(
                      create: (context) => PublicMemoriesCubit(
                          context.read<PublicMemoryRepository>()),
                      child: BlocProvider(
                        create: (context) => HighlightedMemoriesCubit(
                            context.read<PublicMemoryRepository>()),
                        child: PublicAlbumPage(
                          albumId: id,
                          albumPreview: albumPreview,
                        ),
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: "memories/:memoryId",
                      builder: (context, state) {
                        final String albumId = state.pathParameters['albumId']!;
                        final String memoryId =
                            state.pathParameters['memoryId']!;
                        return BlocProvider(
                          create: (context) => PublicMemoryCubit(
                              context.read<PublicMemoryRepository>())
                            ..fetchMemory(albumId, memoryId),
                          child: PublicMemoryPage(
                            albumId: albumId,
                            memoryId: memoryId,
                          ),
                        );
                      },
                    ),
                    GoRoute(
                      path: "details",
                      builder: (context, state) {
                        final String id = state.pathParameters['albumId']!;
                        return BlocProvider(
                            create: (context) => PublicAlbumCubit(
                                albumRepository:
                                    context.read<PublicAlbumRepository>())
                              ..getAlbumInitialLoad(id),
                            child: PublicAlbumInfoPage(albumId: id));
                      },
                    ),
                  ]),
              GoRoute(
                  path: "/albums",
                  builder: ((context, state) {
                    //return GalleryPage();
                    return const AlbumPreviewsPage();
                  }),
                  routes: [
                    GoRoute(
                      path: ':albumId',
                      builder: (context, state) {
                        final String id = state.pathParameters['albumId']!;
                        AlbumPreview albumPreview = state.extra as AlbumPreview;
                        return BlocProvider(
                          create: (context) => TimelineBloc(
                              memoryRepository:
                                  context.read<PrivateMemoryRepository>()),
                          child: BlocProvider(
                            create: (context) => CollectionsPreviewBloc(
                                collectionRepository: context
                                    .read<PrivateCollectionRepository>()),
                            child: BlocProvider(
                              create: (context) => DisposableCameraCubit(
                                  context.read<PrivateAlbumRepository>(),
                                  context.read<
                                      DisposableCameraMemoryRepository>()),
                              child: PrivateAlbumPage(
                                albumId: id,
                                albumPreview: albumPreview,
                              ),
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
                                      context.read<PrivateMemoryRepository>(),
                                      context.read<MemoryLikeRepository>())),
                                  child: PrivateMemoryPage(
                                      albumId: albumId, memoryId: memoryId));
                            },
                            routes: [
                              GoRoute(
                                  path: 'edit-collections',
                                  builder: (context, state) {
                                    final DetailedPrivateMemory memory =
                                        state.extra as DetailedPrivateMemory;
                                    return BlocProvider(
                                        create: (context) =>
                                            SelectCollectionsSheetBloc(
                                                collectionRepository: context.read<
                                                    PrivateCollectionRepository>(),
                                                initiallyIncludedCollections:
                                                    memory.collections),
                                        child: EditCollectionOfMemoryPage(
                                            memory: memory));
                                  })
                            ]),
                        GoRoute(
                          path: 'disposable-camera-memories/:memoryId',
                          builder: (context, state) {
                            final String albumId =
                                state.pathParameters['albumId']!;
                            final String memoryId =
                                state.pathParameters['memoryId']!;
                            return BlocProvider(
                                create: (context) =>
                                    (DisposableCameraMemoryCubit(context.read<
                                        DisposableCameraMemoryRepository>())),
                                child: DisposableCameraMemoryPage(
                                    albumId: albumId, memoryId: memoryId));
                          },
                        ),
                        GoRoute(
                            path: 'collections/:collectionId',
                            builder: (context, state) {
                              final String albumId =
                                  state.pathParameters['albumId']!;
                              final String collectionId =
                                  state.pathParameters['collectionId']!;
                              return BlocProvider(
                                create: (context) => CollectionPageCubit(
                                    context.read<PrivateCollectionRepository>(),
                                    context.read<PrivateMemoryRepository>()),
                                child: PrivateCollectionPage(
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
                                            context.read<
                                                PrivateCollectionRepository>(),
                                            context.read<
                                                PrivateMemoryRepository>()),
                                    child:
                                        PrivateAlbumAddMemoriesToCollectionPage(
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
                                      albumRepository: context
                                          .read<PrivateAlbumRepository>())),
                                  child:
                                      PrivateAlbumInfoPage(albumId: albumId));
                            }),
                        GoRoute(
                          path: 'create-collection',
                          builder: (context, state) {
                            final String albumId =
                                state.pathParameters['albumId']!;
                            return BlocProvider(
                              create: (context) => CollectionCreationCubit(
                                  context.read<PrivateCollectionRepository>()),
                              child: CreateCollectionPage(
                                albumId: albumId,
                              ),
                            );
                          },
                        ),
                        GoRoute(
                            path: 'contributors/:contributorId',
                            builder: (context, state) {
                              final String albumId =
                                  state.pathParameters['albumId']!;
                              final String contributorId =
                                  state.pathParameters['contributorId']!;
                              return BlocProvider(
                                create: (context) => ContributorCubit(
                                    context.read<PrivateMemoryRepository>(),
                                    context.read<PrivateAlbumRepository>()),
                                child: PrivateAlbumContributorPage(
                                    albumId: albumId,
                                    contributorId: contributorId),
                              );
                            }),
                        GoRoute(
                          path: 'invitations-page',
                          builder: (context, state) {
                            final String albumId =
                                state.pathParameters['albumId']!;
                            return BlocProvider(
                                create: (context) => InvitationCubit(
                                    context.read<PrivateAlbumRepository>(),
                                    context.read<UserRepository>()),
                                child: PrivateAlbumInvitationPage(
                                  albumId: albumId,
                                ));
                          },
                        ),
                        GoRoute(
                          path: "createDisposableCameraMemory",
                          builder: (context, state) {
                            MemoryCreationDetails memoryCreationDetails =
                                state.extra as MemoryCreationDetails;
                            return BlocProvider(
                              create: (context) =>
                                  CreateDisposableCameraMemoryCubit(
                                      context.read<
                                          DisposableCameraMemoryRepository>()),
                              child: CreateDisposableCameraMemoryPage(
                                  memoryCreationDetails: memoryCreationDetails),
                            );
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
                    create: (context) => MemoryCreationBloc(
                        context.read<PrivateMemoryRepository>()),
                    child: CreateMemoryPage(
                      memoryCreationDetails: memoryCreationDetails,
                    ),
                  );
                },
              ),
              GoRoute(
                path: "/create-public-memory",
                builder: (context, state) {
                  print(state.extra);
                  PublicMemoryCreationDetails memoryCreationDetails =
                      state.extra as PublicMemoryCreationDetails;
                  return BlocProvider(
                    create: (context) => PublicMemoryCreationCubit(
                        context.read<PublicMemoryRepository>()),
                    child: CreatePublicMemoryPage(
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
                        albumRepository: context.read<PrivateAlbumRepository>(),
                        userRepository: context.read<UserRepository>()),
                    child: CreatePrivateAlbumPage(),
                  );
                },
              ),
              GoRoute(
                path: "/createPublicAlbum",
                builder: (context, state) {
                  return BlocProvider(
                    create: (context) => PublicAlbumCreationCubit(
                        context.read<PublicAlbumRepository>(),
                        context.read<UserRepository>()),
                    child: const CreatePublicAlbumPage(),
                  );
                },
              ),
              GoRoute(
                path: "/createPost",
                builder: (context, state) {
                  PostCreationDetails postCreationDetails =
                      state.extra as PostCreationDetails;
                  return BlocProvider(
                    create: (context) =>
                        CreatePostCubit(context.read<PostRepository>()),
                    child: CreatePostPage(details: postCreationDetails),
                  );
                },
              ),
              GoRoute(
                  path: "/vault",
                  builder: ((context, state) {
                    //return AddContentPage();
                    return MemoryVaultPage();
                  })),
              GoRoute(
                  path: "/profile",
                  builder: ((context, state) {
                    //return ProfilePage();
                    return BlocProvider(
                      create: (context) => ProfileBloc(
                          context.read<UserRepository>(),
                          context.read<PostRepository>()),
                      child: const ProfilePage(),
                    );
                  }),
                  routes: [
                    GoRoute(
                      path: "edit-profile",
                      builder: ((context, state) {
                        //return ProfilePage();
                        return BlocProvider(
                            create: (context) =>
                                EditProfileCubit(context.read<UserRepository>())
                                  ..loadEditProfile(StorageService().userId),
                            child: EditProfilePage());
                      }),
                    ),
                  ]),
              GoRoute(
                path: '/users/:userID',
                builder: (BuildContext context, GoRouterState state) {
                  final id = state.pathParameters['userID']!;
                  return BlocProvider(
                      create: (context) => UserCubit(
                          context.read<UserRepository>(),
                          context.read<PostRepository>())
                        ..fetchUserData(id),
                      child: UserProfilePage(id: id));
                },
              ),
              GoRoute(
                path: '/posts/:postId',
                builder: (BuildContext context, GoRouterState state) {
                  final id = state.pathParameters['postId']!;
                  return BlocProvider(
                      create: (context) => PostCubit(
                            context.read<PostRepository>(),
                            context.read<PostLikeRepository>(),
                          ),
                      child: PostPage(postId: id));
                },
              ),
              GoRoute(
                path: "/home",
                builder: (context, state) {
                  //return HomePage();
                  return BlocProvider(
                      create: (context) => HomeCubit(
                          context.read<UserRepository>(),
                          context.read<PostRepository>())
                        ..loadHomePageContent(StorageService().userId),
                      child: const HomePage());
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
      redirect: (context, state) async {
        AuthState authState = context.read<AuthBloc>().state;

        if (authState is AuthSuccess &&
            JwtDecoder.isExpired((await StorageService().getAccessToken())!) &&
            JwtDecoder.isExpired((await StorageService().getRefreshToken())!) &&
            context.mounted) {
          context.read<AuthBloc>().add(LogoutRequested());

          return "/";
        }

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
