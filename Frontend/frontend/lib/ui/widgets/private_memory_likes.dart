import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/private_memory_likes_cubit/private_memory_likes_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateMemoryLikesWidget extends StatelessWidget {
  const PrivateMemoryLikesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: BlocBuilder<PrivateMemoryLikesCubit, PrivateMemoryLikesState>(
          builder: (context, state) {
        if (state is PrivateMemoryLikesLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PrivateMemoryLikesLoadedState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 10, 25),
                  child: Text("Likes:",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.likes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            foregroundImage:
                                NetworkImage(state.likes[index].user.pfpLink),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            state.likes[index].user.username,
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            color: Colors.grey.shade900,
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            onSelected: (value) async {
                              switch (value) {
                                case 'Report':
                                  break;
                                case 'Hide':
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {'Report', 'Hide'}.map((String choice) {
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
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const Center(
          child: Text(
            "Something went wrong",
            style: TextStyle(color: Colors.white),
          ),
        );
      }),
    );
  }
}
