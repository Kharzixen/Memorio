import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:frontend/bloc/moment_bloc/moment_bloc.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/ui/widgets/comment_list.dart';
import 'package:frontend/ui/widgets/like_list.dart';
import 'package:frontend/ui/widgets/moment_header.dart';
import 'package:go_router/go_router.dart';

class MemoryPage extends StatefulWidget {
  final String memoryId;
  final String albumId;
  const MemoryPage({Key? key, required this.memoryId, required this.albumId})
      : super(key: key);

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  final ScrollController _scrollController = ScrollController();
  CacheManager cacheManager = CacheManager(
    Config(
      'images_cache_key',
      stalePeriod: const Duration(minutes: 3),
      maxNrOfCacheObjects: 50,
    ),
  );

  @override
  void initState() {
    super.initState();
    context
        .read<MomentBloc>()
        .add(MemoryFetched(albumId: widget.albumId, momentId: widget.memoryId));
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
      body: BlocBuilder<MomentBloc, MomentState>(
        builder: (context, state) {
          //circular progress indicator
          if (state is MomentLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          if (state is MomentLoadedState) {
            if (state.asyncMethodInProgress) {
              return Stack(
                children: [
                  Content(moment: state.moment),
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
              return Content(moment: state.moment);
            }
          }

          if (state is MomentDeletedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.canPop()) {
                context.pop(
                    PopPayload<String>(ActionType.deleted, widget.memoryId));
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
    // _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}

class Content extends StatelessWidget {
  final DetailedMemory moment;
  const Content({super.key, required this.moment});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Container(
                        color: Colors.white.withOpacity(0.08),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CachedNetworkImage(
                            imageUrl: moment.photo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      MemoryHeader(
                        moment: moment,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            const SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              floating: true, // Set floating to true
              backgroundColor: Colors.black,
              flexibleSpace: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: TabBar(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  dividerColor: Colors.white,
                  dividerHeight: 2,
                  indicatorColor: Colors.blue,
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.blue,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      text: "Comments",
                    ),
                    Tab(
                      text: "Likes",
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            CommentList(comments: []),
            LikeList(likes: []),
          ],
        ),
      ),
    );
  }
}
