import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/cubit/home_cubit/home_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
            backgroundColor: Colors.black,
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
                              title: const Text(
                                  'Are you sure you want to logout ?'),
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
                                    if (context.mounted) {
                                      context.go("/");
                                    }
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
            body: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadedState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      children: [
                        Text(
                          "Welcone ${StorageService().username} - ${StorageService().userId}",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        state.users.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.users.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 25,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      context.push(
                                          "/users/${state.users[index].userId}");
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              foregroundImage:
                                                  CachedNetworkImageProvider(
                                                      headers: HttpHeadersFactory
                                                          .getDefaultRequestHeaderForImage(
                                                              TokenManager()
                                                                  .accessToken!),
                                                      state.users[index]
                                                          .pfpLink),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              state.users[index].username,
                                              style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        state.posts[state.users[index].userId]!
                                                .isNotEmpty
                                            ? GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisSpacing: 8,
                                                  crossAxisSpacing: 4,
                                                  childAspectRatio:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              1.5),
                                                ),
                                                itemBuilder:
                                                    (context, postIndex) {
                                                  Post post = state.posts[state
                                                      .users[index]
                                                      .userId]![postIndex];
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        var response =
                                                            await context.push(
                                                                "/posts/${post.postId}");
                                                        if (response != null) {
                                                          print(response);
                                                        }
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            post.imageLink,
                                                        // placeholder: (context, url) =>
                                                        //     const Center(
                                                        //         child:
                                                        //             CircularProgressIndicator()),
                                                        fadeInDuration:
                                                            Duration.zero,
                                                        fadeOutDuration:
                                                            Duration.zero,
                                                        httpHeaders: HttpHeadersFactory
                                                            .getDefaultRequestHeaderForImage(
                                                                TokenManager()
                                                                    .accessToken!),
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                progress) {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              value: progress
                                                                  .progress,
                                                            ),
                                                          );
                                                        },
                                                        fit: BoxFit.cover,
                                                      ));
                                                },
                                                itemCount: state
                                                    .posts[state
                                                        .users[index].userId]!
                                                    .length,
                                              )
                                            : Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 35,
                                                  ),
                                                  Text(
                                                    "No Posts to show",
                                                    style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 35,
                                                  ),
                                                ],
                                              ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Divider()
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Center(
                                    child: Text(
                                      "Nothing to show",
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )));
  }
}
