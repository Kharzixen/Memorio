import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc_singleton.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/data/repository/memory_comment_repository.dart';
import 'package:frontend/data/repository/disposable_camera_memory_repository.dart';
import 'package:frontend/data/repository/memory_like_repository.dart';
import 'package:frontend/data/repository/post_comment_repository.dart';
import 'package:frontend/data/repository/post_like_repository.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/data/repository/private_collection_repository.dart';
import 'package:frontend/data/repository/private_memory_repository.dart';
import 'package:frontend/data/repository/post_repository.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/data/repository/public_memory_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/router/router.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<StorageService>.value(value: StorageService()),
      Provider<PrivateAlbumRepository>.value(value: PrivateAlbumRepository()),
      Provider<UserRepository>.value(value: UserRepository()),
      Provider<PrivateMemoryRepository>.value(value: PrivateMemoryRepository()),
      Provider<DisposableCameraMemoryRepository>.value(
          value: DisposableCameraMemoryRepository()),
      Provider<PrivateCollectionRepository>.value(
          value: PrivateCollectionRepository()),
      Provider<PostRepository>.value(value: PostRepository()),
      Provider<MemoryLikeRepository>.value(value: MemoryLikeRepository()),
      Provider<MemoryCommentRepository>.value(value: MemoryCommentRepository()),
      Provider<PostCommentRepository>.value(value: PostCommentRepository()),
      Provider<PostLikeRepository>.value(value: PostLikeRepository()),
      Provider<AuthRepository>.value(value: AuthRepository()),
      Provider<PublicAlbumRepository>.value(value: PublicAlbumRepository()),
      Provider<PublicMemoryRepository>.value(value: PublicMemoryRepository())
    ],
    //the bloc provider might go down on the widget tree to the auth path later
    // check this
    child: BlocProvider(
      create: (context) {
        AuthBloc bloc = AuthBloc(
          context.read<AuthRepository>(),
        );
        TokenManager()
            .initialize(authRepository: context.read<AuthRepository>());
        AuthBlocSingleton().initialize(bloc);
        return bloc;
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter().router,
          ),
        ),
      ),
    ),
  ));
}
