import 'package:flutter/material.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Memorio",
              style: GoogleFonts.lato(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            actions: [
              PopupMenuButton<String>(
                color: Colors.grey.shade900,
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onSelected: (value) async {
                  switch (value) {
                    case 'Leave':
                      return showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            backgroundColor: Colors.grey.shade800,
                            titleTextStyle: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            title:
                                const Text('Are you sure you want to logout ?'),
                            actions: [
                              TextButton(
                                child: Text(
                                  'Logout',
                                  style: GoogleFonts.lato(
                                      color: Colors.red.shade800,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(dialogContext,
                                            rootNavigator: true)
                                        .pop();
                                  }
                                  //need to await the run of this event, to perform the other deletion

                                  var bloc =
                                      context.read<AuthBloc>().stream.first;
                                  context
                                      .read<AuthBloc>()
                                      .add(LogoutRequested());
                                  await bloc;
                                  context.go("/");
                                },
                              ),
                              TextButton(
                                child: Text('Cancel',
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    case 'Settings':
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {
                    'Leave',
                    'Settings',
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList();
                },
              )
            ],
          ),
          body: Container(
            color: Colors.black,
            child: const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Homepage",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            )),
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
