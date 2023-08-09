import 'package:flutter/material.dart';
import 'package:licence_frontend/routers/router.dart';

void main() {
  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: AppRouter().router,
  ));
}
