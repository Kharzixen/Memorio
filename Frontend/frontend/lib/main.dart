import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/router/router.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Provider(
    create: (context) => StorageService(),
    child: BlocProvider(
      create: (context) => AuthBloc(
        context.read<StorageService>(),
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter().router,
      ),
    ),
  ));
}
