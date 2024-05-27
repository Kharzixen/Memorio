import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/contributor_cubit/contributor_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateAlbumContributorPage extends StatefulWidget {
  final String albumId;
  final String contributorId;
  const PrivateAlbumContributorPage(
      {super.key, required this.albumId, required this.contributorId});

  @override
  State<PrivateAlbumContributorPage> createState() =>
      _PrivateAlbumContributorPageState();
}

class _PrivateAlbumContributorPageState
    extends State<PrivateAlbumContributorPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ContributorCubit>()
        .loadContributor(widget.albumId, widget.contributorId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<ContributorCubit, ContributorState>(
        builder: (context, state) {
          if (state is ContributorLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ContributorLoadedState) {
            return ListView(
              children: [
                //header, contributor info, popup menu
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(state.contributor.pfpLink),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        state.contributor.username,
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Profile",
                            style: GoogleFonts.lato(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Remove",
                            style: GoogleFonts.lato(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    PopupMenuButton<String>(
                      color: Colors.grey.shade900,
                      icon: Column(
                        children: [
                          const Icon(
                            Icons.more_horiz,
                            size: 30,
                            color: Colors.white,
                          ),
                          Text(
                            "More",
                            style: GoogleFonts.lato(color: Colors.white),
                          )
                        ],
                      ),
                      onSelected: (value) async {
                        switch (value) {
                          case 'Block':
                            break;
                          case 'Report':
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        Set<String> options = {};
                        options = {"Block", "Report"};

                        return options.map((String choice) {
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
                const SizedBox(
                  height: 15,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 4,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.5),
                  ),
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                        onTap: () async {
                          // var response =
                          //     await context.push("/posts/${widget.posts[index].postId}");
                          // if (response != null) {
                          //   PopPayload<String> payload = response as PopPayload<String>;
                          //   if (payload.actionType == ActionType.deleted &&
                          //       context.mounted) {
                          //     context
                          //         .read<ProfileBloc>()
                          //         .add(PostDeleted(payload.data as String));
                          //   }
                          // }
                        },
                        child: CachedNetworkImage(
                          imageUrl: state.memories[index].photo,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          progressIndicatorBuilder: (context, url, progress) {
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress.progress,
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                        ));
                  }),
                  itemCount: state.memories.length,
                ),
              ],
            );
          }

          return const Text(
            "Something went wrong",
            style: TextStyle(color: Colors.white),
          );
        },
      ),
    ));
  }
}
