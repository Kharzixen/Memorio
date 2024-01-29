import 'package:flutter/material.dart';
import 'package:frontend/router/router.dart';

void main() {
  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: AppRouter().router,
  ));
}
