import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/post_likes_cubit/post_likes_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PostLikesWidget extends StatelessWidget {
  const PostLikesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: BlocBuilder<PostLikesCubit, PostLikesState>(
          builder: (context, state) {
        if (state is PostLikesLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PostLikesLoadedState) {
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
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.likes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(
                              state.likes[index].user.pfpLink,
                              headers: HttpHeadersFactory
                                  .getDefaultRequestHeaderForImage(
                                      TokenManager().accessToken!),
                            ),
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
