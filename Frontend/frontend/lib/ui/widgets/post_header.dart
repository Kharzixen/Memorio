import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/post_comments_cubit/post_comments_cubit.dart';
import 'package:frontend/cubit/post_cubit/post_cubit.dart';
import 'package:frontend/cubit/post_likes_cubit/post_likes_cubit.dart';
import 'package:frontend/data/repository/post_comment_repository.dart';
import 'package:frontend/data/repository/post_like_repository.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/post_comments_widget.dart';
import 'package:frontend/ui/widgets/post_likes.dart';
import 'package:google_fonts/google_fonts.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  const PostHeader({super.key, required this.post});

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
                context
                    .read<PostCubit>()
                    .likePost(StorageService().userId, post.postId);
              },
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconSize: 28.0, // desired size
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.favorite_outline,
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
                      create: (context) => PostCommentsCubit(
                          context.read<PostCommentRepository>())
                        ..loadComments(post.postId),
                      child: PostCommentsWidget(
                        postId: post.postId,
                      ),
                    );
                  },
                );
              },
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconSize: 25.0, // desired size
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            post.owner.userId == StorageService().userId
                ? PopupMenuButton<String>(
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
                                    'Are you sure you want to delete this memory ? ${post.postId}'),
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

                                      context.read<PostCubit>().deletePost();
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
                                        Navigator.of(context,
                                                rootNavigator: true)
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
                      return {'Edit', 'Remove', 'Edit Collections'}
                          .map((String choice) {
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
                : PopupMenuButton<String>(
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
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context1) {
                return BlocProvider(
                  create: (context) =>
                      PostLikesCubit(context.read<PostLikeRepository>())
                        ..loadLikes(post.postId),
                  child: const PostLikesWidget(),
                );
              },
            );
          },
          child: Text(
            '0 likes',
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(post.owner.pfpLink),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              post.owner.username,
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          post.caption,
          style: GoogleFonts.lato(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
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
                  getDate(post.creationDate),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Text(
                  getHour(post.creationDate),
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
