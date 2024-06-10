import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/public_album_creation_cubit/public_album_creation_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicAlbumCreationAddPeople extends StatefulWidget {
  final TabController tabController;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  const PublicAlbumCreationAddPeople(
      {super.key,
      required this.tabController,
      required this.nameController,
      required this.descriptionController});

  @override
  State<PublicAlbumCreationAddPeople> createState() =>
      _PublicAlbumCreationAddPeopleState();
}

class _PublicAlbumCreationAddPeopleState
    extends State<PublicAlbumCreationAddPeople> {
  @override
  void initState() {
    super.initState();
    context
        .read<PublicAlbumCreationCubit>()
        .startContributorSelection(StorageService().userId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Text(
            "Add contributors to your new album",
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          BlocBuilder<PublicAlbumCreationCubit, PublicAlbumCreationState>(
              builder: (context, state) {
            if (state is PublicAlbumCreationInProgressState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Invite your friends: ",
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 23),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    state.friends.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.friends.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 10),
                                child: TextButton(
                                  onPressed: () {
                                    if (state.isSelectedFriend[index]) {
                                      context
                                          .read<PublicAlbumCreationCubit>()
                                          .selectFriendAtIndex(index);
                                    } else {
                                      context
                                          .read<PublicAlbumCreationCubit>()
                                          .unselectFriendAtIndex(index);
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      splashFactory: NoSplash.splashFactory,
                                      backgroundColor: Colors.transparent),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              state.friends[index].pfpLink,
                                              headers: HttpHeadersFactory
                                                  .getDefaultRequestHeaderForImage(
                                                      TokenManager()
                                                          .accessToken!),
                                            ),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        state.friends[index].username,
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      state.isSelectedFriend[index]
                                          ? Icon(Icons.check_circle)
                                          : Icon(Icons.radio_button_unchecked)
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            height: 300,
                            child: Center(
                              child: Text(
                                "No friends to show",
                                style: GoogleFonts.lato(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          )
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }),
          const SizedBox(
            height: 35,
          ),
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  if (widget.tabController.index > 0) {
                    widget.tabController
                        .animateTo(widget.tabController.index - 1);
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.navigate_before,
                        size: 23,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Back  ",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  // if (tabController.index <
                  //     tabController.length - 1) {
                  //   tabController
                  //       .animateTo(tabController.index + 1);
                  // }
                  context.read<PublicAlbumCreationCubit>().createAlbum(
                      widget.nameController.text,
                      widget.descriptionController.text);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Finish",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.navigate_next,
                        size: 23,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
