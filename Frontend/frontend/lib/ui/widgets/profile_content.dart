import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/profile_bloc/profile_bloc.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:go_router/go_router.dart';

class ProfileContent extends StatefulWidget {
  final List<Post> posts;
  const ProfileContent({super.key, required this.posts});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    if (widget.posts.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 35,
          ),
          const Text(
            "Capture the moment, preserve the memories",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          TextButton(
              onPressed: () {},
              child: const Text(
                "Create your first post.",
                style: TextStyle(
                    color: Color.fromRGBO(24, 119, 242, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ))
        ],
      );
    } else {
      return GridView.builder(
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
                var response =
                    await context.push("/posts/${widget.posts[index].postId}");
                if (response != null) {
                  PopPayload<String> payload = response as PopPayload<String>;
                  if (payload.actionType == ActionType.deleted &&
                      context.mounted) {
                    context
                        .read<ProfileBloc>()
                        .add(PostDeleted(payload.data as String));
                  }
                }
              },
              child: CachedNetworkImage(
                imageUrl: widget.posts[index].imageLink,
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
        itemCount: widget.posts.length,
      );
    }
  }
}
