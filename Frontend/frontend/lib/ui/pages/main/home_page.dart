import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Consumer<StorageService>(
        builder: (context, value, child) {
          return Container(
            color: Colors.black,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Demo User id: ${value.userId}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  "Demo username: ${value.username}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            )),
          );
        },
      )),
    );
    // return SafeArea(
    //   child: Scaffold(
    //     body: BlocConsumer<AuthBloc, AuthState>(
    //       listener: (context, state) {},
    //       builder: (context, state) {
    //         if (state is AuthSuccess) {
    //           return Container(
    //             color: Colors.red,
    //             child: Center(
    //                 child: Text(
    //               state.userId,
    //               style: const TextStyle(fontSize: 35, color: Colors.black),
    //             )),
    //           );
    //         } else {
    //           return Container(
    //             color: Colors.green,
    //             child: const Center(
    //                 child: Text("No ID",
    //                     style: TextStyle(fontSize: 35, color: Colors.black))),
    //           );
    //         }
    //       },
    //     ),
    //   ),
    // );
  }
}
