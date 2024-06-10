import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/moment_bloc/moment_bloc.dart';
import 'package:frontend/cubit/private_memory_comments_cubit/private_memory_comments_cubit.dart';
import 'package:frontend/cubit/private_memory_likes_cubit/private_memory_likes_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/data/repository/memory_comment_repository.dart';
import 'package:frontend/data/repository/memory_like_repository.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/private_memory_comments.dart';
import 'package:frontend/ui/widgets/private_memory_likes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateMemoryHeader extends StatelessWidget {
  final DetailedPrivateMemory moment;
  const PrivateMemoryHeader({Key? key, required this.moment}) : super(key: key);

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
                moment.isLiked
                    ? context.read<MomentBloc>().add(MomentDislikedByUser(
                        moment.memoryId, StorageService().userId))
                    : context.read<MomentBloc>().add(MomentLikedByUser(
                        moment.memoryId, StorageService().userId));
              },
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconSize: 28.0, // desired size
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: moment.isLiked
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
            ),
            const SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                showBottomSheet(
                  enableDrag: true,
                  backgroundColor: Colors.grey.shade900,
                  context: context,
                  builder: (context1) {
                    return BlocProvider(
                        create: (context) => PrivateMemoryCommentsCubit(
                            context.read<MemoryCommentRepository>())
                          ..loadLikes(moment.album.albumId, moment.memoryId),
                        child: PrivateMemoryCommentsWidget(
                          memoryId: moment.memoryId,
                          albumId: moment.album.albumId,
                        ));
                  },
                );
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
            // IconButton(f
            //   onPressed: () {},
            //   style: const ButtonStyle(
            //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   ),
            //   iconSize: 25.0, // desired size
            //   padding: EdgeInsets.zero,
            //   constraints: const BoxConstraints(),
            //   icon: const Icon(
            //     Icons.more_vert,
            //     color: Colors.white,
            //   ),
            // ),
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
                              'Are you sure you want to delete this memory ? ${moment.memoryId}'),
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
                                      .pop();
                                }
                                //need to await the run of this event, to perform the other deletion

                                context.read<MomentBloc>().add(
                                    MemoryRemoved(memoryId: moment.memoryId));
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

                  case 'Edit Collections':
                    List<SimplePrivateCollection> newCollections =
                        await context.push(
                            '/albums/${moment.album.albumId}/memories/${moment.memoryId}/edit-collections',
                            extra: moment) as List<SimplePrivateCollection>;
                    if (context.mounted) {
                      context.read<MomentBloc>().add(MemoryCollectionsChanged(
                          newCollections: newCollections));
                    }
                }
              },
              itemBuilder: (BuildContext context) {
                Set<String> options = {};
                if (moment.uploader.userId == StorageService().userId) {
                  options = {'Edit', 'Remove', 'Edit Collections'};
                } else if (moment.album.owner.userId ==
                    StorageService().userId) {
                  options = {'Report', 'Hide', 'Remove'};
                } else {
                  options = {'Report', 'Hide'};
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
            showModalBottomSheet(
              context: context,
              builder: (context1) {
                return BlocProvider(
                  create: (context) => PrivateMemoryLikesCubit(
                      context.read<MemoryLikeRepository>())
                    ..loadLikes(moment.album.albumId, moment.memoryId),
                  child: const PrivateMemoryLikesWidget(),
                );
              },
            );
          },
          child: Text(
            '${moment.likeCount} likes',
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
                moment.uploader.pfpLink,
                headers: HttpHeadersFactory.getDefaultRequestHeaderForImage(
                    TokenManager().accessToken!),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              moment.uploader.username,
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
        moment.caption.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  moment.caption,
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
          children: [
            Text(
              "Collections:",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      List<SimplePrivateCollection> collections =
                          moment.collections;
                      return StatefulBuilder(builder: (context, setState) {
                        return Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                color: Colors.grey.shade900),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Collections:",
                                        style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                          onPressed: () async {
                                            List<SimplePrivateCollection>
                                                newCollections =
                                                await context.push(
                                                    '/albums/${moment.album.albumId}/memories/${moment.memoryId}/edit-collections',
                                                    extra:
                                                        moment) as List<
                                                    SimplePrivateCollection>;

                                            if (context.mounted) {
                                              context.read<MomentBloc>().add(
                                                  MemoryCollectionsChanged(
                                                      newCollections:
                                                          newCollections));
                                              setState(() {
                                                collections = newCollections;
                                              });
                                            }
                                          },
                                          child: Text(
                                            "Edit collections",
                                            style: GoogleFonts.lato(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: collections.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                                collections[index]
                                                    .collectionName,
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lato(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.navigate_next_sharp,
                                                size: 28,
                                                color: Colors.white,
                                              )),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ));
                      });
                    },
                  );
                },
                child: Text(
                  "View Collections",
                  style: GoogleFonts.lato(
                      color: Colors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
        Row(
          children: [
            Text(
              "Hashtags:",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  "View Hashtags",
                  style: GoogleFonts.lato(
                      color: Colors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  getDate(moment.date),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Text(
                  getHour(moment.date),
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
