import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/public_memory_cubit/public_memory_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicMemoryHeader extends StatelessWidget {
  final DetailedPublicMemory memory;
  const PublicMemoryHeader({Key? key, required this.memory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<PublicMemoryCubit>().like();
              },
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconSize: 28.0, // desired size
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                // showBottomSheet(
                //   enableDrag: true,
                //   backgroundColor: Colors.grey.shade900,
                //   context: context,
                //   builder: (context1) {
                //     return BlocProvider(
                //         create: (context) => PrivateMemoryCommentsCubit(
                //             context.read<MemoryCommentRepository>())
                //           ..loadLikes(moment.album.albumId, moment.memoryId),
                //         child: PrivateMemoryCommentsWidget(
                //           memoryId: moment.memoryId,
                //           albumId: moment.album.albumId,
                //         ));
                //   },
                // );
              },
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconSize: 25.0, // desired size
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
              ),
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
                  case 'Edit':
                    break;

                  case 'Highlight':
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade800,
                          titleTextStyle: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          title: Text(
                              'Are you sure you want to highlight this memory ? ${memory.memoryId}'),
                          actions: [
                            TextButton(
                              child: Text(
                                'Highlight',
                                style: GoogleFonts.lato(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(dialogContext,
                                          rootNavigator: true)
                                      .pop();
                                }
                                context
                                    .read<PublicMemoryCubit>()
                                    .highlightMemory(
                                        memory.album.id, memory.memoryId);
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

                  case 'Remove from Highlights':
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade800,
                          titleTextStyle: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          title: Text(
                              'Are you sure you want to remove from highlights this memory ? ${memory.memoryId}'),
                          actions: [
                            TextButton(
                              child: Text(
                                'Highlight',
                                style: GoogleFonts.lato(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(dialogContext,
                                          rootNavigator: true)
                                      .pop();
                                }
                                context
                                    .read<PublicMemoryCubit>()
                                    .removeMemoryFromHighlights(
                                        memory.album.id, memory.memoryId);
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

                  case 'Remove':
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade800,
                          titleTextStyle: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          title: Text(
                              'Are you sure you want to delete this memory ? ${memory.memoryId}'),
                          // content: const SingleChildScrollView(
                          //   child: ListBody(
                          //     children: <Widget>[
                          //       Text(
                          //           'Are you sure you want to delete this memory ?'),
                          //     ],
                          //   ),
                          // ),
                          actions: [
                            TextButton(
                              child: Text(
                                'Remove',
                                style: GoogleFonts.lato(
                                    color: Colors.red.shade800,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(dialogContext,
                                          rootNavigator: true)
                                      .pop(PopPayload<String>(
                                          ActionType.deleted, memory.memoryId));
                                }
                                //need to await the run of this event, to perform the other deletion

                                context
                                    .read<PublicMemoryCubit>()
                                    .deleteMemory();
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
                }
              },
              itemBuilder: (BuildContext context) {
                print(memory.album.owner.userId);
                Set<String> options = {};
                if (memory.uploader.userId == StorageService().userId) {
                  options = {'Edit', 'Remove'};
                } else {
                  options = {'Report', 'Hide'};
                }

                if (memory.album.owner.userId == StorageService().userId) {
                  if (memory.isHighlighted) {
                    options.add('Remove from Highlights');
                  } else {
                    options.add("Highlight");
                  }
                }

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
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            // showModalBottomSheet(
            //   context: context,
            //   builder: (context1) {
            //     return BlocProvider(
            //       create: (context) => PrivateMemoryLikesCubit(
            //           context.read<MemoryLikeRepository>())
            //         ..loadLikes(moment.album.albumId, moment.memoryId),
            //       child: const PrivateMemoryLikesWidget(),
            //     );
            //   },
            // );
          },
          child: Text(
            '3 likes',
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          children: [
            CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(
                "https://images.pexels.com/photos/25003282/pexels-photo-25003282/free-photo-of-portrait-of-man-in-hat-smoking.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                headers: HttpHeadersFactory.getDefaultRequestHeaderForImage(
                    TokenManager().accessToken!),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              memory.uploader.username,
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        memory.caption.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  memory.caption,
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Container(),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  getDate(memory.date),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Text(
                  getHour(memory.date),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Leaning Tower of Pisa",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "Pisa, Italy",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }

  String getDate(DateTime date) {
    String month = date.month < 10 ? '0${date.month}' : '${date.month}';
    String day = date.day < 10 ? '0${date.day}' : '${date.day}';

    return '${date.year}-$month-$day';
  }

  String getHour(DateTime date) {
    String hour = date.hour < 10 ? '0${date.hour}' : '${date.hour}';
    String minute = date.minute < 10 ? '0${date.minute}' : '${date.minute}';
    String second = date.second < 10 ? '0${date.second}' : '${date.second}';
    return '$hour:$minute:$second';
  }
}
