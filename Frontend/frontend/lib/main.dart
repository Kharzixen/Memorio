import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/data/data_provider/user_data_provider.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/router/router.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<StorageService>.value(value: StorageService()),
      Provider<UserRepository>.value(value: UserRepository(UserDataProvider())),
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
