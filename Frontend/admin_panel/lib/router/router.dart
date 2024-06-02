import 'package:admin_panel/cubit/users_panel_cubit/users_panel_cubit.dart';
import 'package:admin_panel/page/login_page.dart';
import 'package:admin_panel/page/users_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        builder: (context, state) => LoginPage(),
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) {
          return Scaffold(
            // backgroundColor: Colors.black,
            // bottomNavigationBar: const CustomNavBar(),
            body: child,
          );
        },
        routes: [
          GoRoute(
              path: "/users-panel",
              builder: ((context, state) {
                //return DiscoverPage();
                return BlocProvider(
                    create: (context) => UsersPanelCubit(),
                    child: const UsersPanel());
              })),
        ],
      ),
    ],
    // redirect: (context, state) {
    //   AuthState authState = context.read<AuthBloc>().state;
    //   if (authState is AuthSuccess) {
    //     if (state.uri.toString() == "/" ||
    //         state.uri.toString() == "/login" ||
    //         state.uri.toString() == "/register") {
    //       return "/home";
    //     }
    //   }
    //   return state.uri.toString();
    // },
  );
}
