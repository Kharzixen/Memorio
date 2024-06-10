import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/post_cubit/post_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/ui/widgets/post_header.dart';
import 'package:go_router/go_router.dart';
import 'package:widget_zoom/widget_zoom.dart';

class PostPage extends StatefulWidget {
  final String postId;
  const PostPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.chat_rounded,
                size: 23,
              )),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          //circular progress indicator
          if (state is PostLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          if (state is PostLoadedState) {
            if (state.asyncMethodInProgress) {
              return Stack(
                children: [
                  Content(post: state.post),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Content(post: state.post);
            }
          }

          if (state is PostDeletedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.canPop()) {
                context
                    .pop(PopPayload<String>(ActionType.deleted, widget.postId));
              }
            });

            return const SizedBox();
          }
          return const Text(
            "An unexpected error occurred",
            style: TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class Content extends StatelessWidget {
  final Post post;
  const Content({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            color: Colors.white.withOpacity(0.08),
            child: Align(
              alignment: Alignment.topCenter,
              child: WidgetZoom(
                heroAnimationTag: "tag",
                zoomWidget: CachedNetworkImage(
                  imageUrl: post.imageLink,
                  httpHeaders:
                      HttpHeadersFactory.getDefaultRequestHeaderForImage(
                          TokenManager().accessToken!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          PostHeader(
            post: post,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
