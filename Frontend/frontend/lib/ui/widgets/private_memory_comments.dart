import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/private_memory_comments_cubit/private_memory_comments_cubit.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateMemoryCommentsWidget extends StatelessWidget {
  final String albumId;
  final String memoryId;
  final TextEditingController messageController = TextEditingController();
  PrivateMemoryCommentsWidget(
      {Key? key, required this.albumId, required this.memoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrivateMemoryCommentsCubit, PrivateMemoryCommentsState>(
      builder: (context, state) {
        if (state is PrivateMemoryCommentsLoadedState) {
          return Column(
            children: [
              const SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Icon(
                      Icons.drag_handle_rounded,
                      size: 40,
                    ),
                  )),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 10, 25),
                      child: Text("Comments:",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    ),
                    state.comments.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          foregroundImage: NetworkImage(state
                                              .comments[index].user.pfpLink),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          state.comments[index].user.username,
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        state.comments[index].user.userId ==
                                                StorageService().userId
                                            ? PopupMenuButton<String>(
                                                color: Colors.grey.shade900,
                                                icon: const Icon(
                                                  Icons.more_vert,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                onSelected: (value) async {
                                                  switch (value) {
                                                    case 'Delete':
                                                      return showDialog<void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            dialogContext) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                Colors.grey
                                                                    .shade800,
                                                            titleTextStyle:
                                                                GoogleFonts.lato(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            title: const Text(
                                                                'Are you sure you want to delete this comment ?'),
                                                            actions: [
                                                              TextButton(
                                                                child: Text(
                                                                  'Delete',
                                                                  style: GoogleFonts.lato(
                                                                      color: Colors
                                                                          .red
                                                                          .shade800,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  if (Navigator.of(
                                                                          context)
                                                                      .canPop()) {
                                                                    Navigator.of(
                                                                            dialogContext,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop();
                                                                  }
                                                                  //need to await the run of this event, to perform the other deletion

                                                                  context
                                                                      .read<
                                                                          PrivateMemoryCommentsCubit>()
                                                                      .deleteComment(
                                                                          index);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                    'Cancel',
                                                                    style: GoogleFonts.lato(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                onPressed: () {
                                                                  if (Navigator.of(
                                                                          context)
                                                                      .canPop()) {
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop();
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );

                                                    case 'Edit':
                                                      break;
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  Set<String> options = {};
                                                  options = {"Delete", "Edit"};

                                                  return options
                                                      .map((String choice) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: choice,
                                                      child: Text(
                                                        choice,
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              )
                                            : PopupMenuButton<String>(
                                                color: Colors.grey.shade900,
                                                icon: const Icon(
                                                  Icons.more_vert,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                onSelected: (value) async {
                                                  switch (value) {
                                                    case 'Block':
                                                      break;
                                                    case 'Report':
                                                      break;
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  Set<String> options = {};
                                                  options = {"Block", "Report"};

                                                  return options
                                                      .map((String choice) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: choice,
                                                      child: Text(
                                                        choice,
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              )
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        state.comments[index].message,
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        getDateTime(
                                            state.comments[index].creationDate),
                                        style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: state.comments.length,
                          )
                        : Center(
                            child: Text(
                              "No comments to show",
                              style: GoogleFonts.lato(
                                  fontSize: 23, color: Colors.blue),
                            ),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: messageController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Write message..",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: state.isNewCommentInMaking
                            ? const CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.blue,
                              )
                            : Text(
                                "Send",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold),
                              ),
                        onPressed: () {
                          if (!state.isNewCommentInMaking &&
                              messageController.text != "") {
                            context
                                .read<PrivateMemoryCommentsCubit>()
                                .createNewCommentForMemory(
                                    albumId,
                                    StorageService().userId,
                                    memoryId,
                                    messageController.text);
                            messageController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    // if (!_nameIsUnique) {
                    //   _nameIsUnique = true;
                    // }
                  },
                  validator: (value) {
                    return null;

                    // if (value == null || value.isEmpty) {
                    //   return 'Please give the collection a name';
                    // }
                    // if (!_nameIsUnique) {
                    //   return 'This collection name already exists';
                    // }
                    // return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        }

        if (state is PrivateMemoryCommentsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PrivateMemoryCommentsErrorState) {
          return Center(
            child: Text(
              state.error,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        return const Text(
          "Something went wrong",
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  String getDateTime(DateTime date) {
    String month = date.month < 10 ? '0${date.month}' : '${date.month}';
    String day = date.day < 10 ? '0${date.day}' : '${date.day}';
    String hour = date.hour < 10 ? '0${date.hour}' : '${date.hour}';
    String minute = date.minute < 10 ? '0${date.minute}' : '${date.minute}';
    String second = date.second < 10 ? '0${date.second}' : '${date.second}';
    return '${date.year}-$month-$day $hour:$minute:$second';
  }
}
