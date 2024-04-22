import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/data/repository/album_repository.dart';
import 'package:frontend/data/repository/collection_repository.dart';
import 'package:frontend/data/repository/memory_repository.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/router/router.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<StorageService>.value(value: StorageService()),
      Provider<AlbumRepository>.value(value: AlbumRepository()),
      Provider<UserRepository>.value(value: UserRepository()),
      Provider<MemoryRepository>.value(value: MemoryRepository()),
      Provider<CollectionRepository>.value(value: CollectionRepository()),
    ],
    //the bloc provider might go down on the widget tree to the auth path later
    // check this
    child: BlocProvider(
      create: (context) => AuthBloc(
        context.read<StorageService>(),
      ),
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
