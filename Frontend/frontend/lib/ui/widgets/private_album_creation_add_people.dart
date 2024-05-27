import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_creation_bloc/album_creation_bloc.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateAlbumCreationAddPeople extends StatefulWidget {
  final TabController tabController;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  const PrivateAlbumCreationAddPeople(
      {super.key,
      required this.tabController,
      required this.nameController,
      required this.descriptionController});

  @override
  State<PrivateAlbumCreationAddPeople> createState() =>
      _PrivateAlbumCreationAddPeopleState();
}

class _PrivateAlbumCreationAddPeopleState
    extends State<PrivateAlbumCreationAddPeople> {
  @override
  void initState() {
    super.initState();
    context
        .read<AlbumCreationBloc>()
        .add(AddFriendsStarted(StorageService().userId));
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
          BlocBuilder<AlbumCreationBloc, AlbumCreationState>(
              builder: (context, state) {
            if (state is AlbumCreationInProgressState) {
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
                                          .read<AlbumCreationBloc>()
                                          .add(UnselectedFriendAtIndex(index));
                                    } else {
                                      context
                                          .read<AlbumCreationBloc>()
                                          .add(SelectedFriendAtIndex(index));
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
                                            image: NetworkImage(
                                                state.friends[index].pfpLink),
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
                  context.read<AlbumCreationBloc>().add(AlbumCreationFinalized(
                      albumName: widget.nameController.text,
                      caption: widget.descriptionController.text));
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
