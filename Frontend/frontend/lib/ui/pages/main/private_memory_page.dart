import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:frontend/bloc/moment_bloc/moment_bloc.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/ui/widgets/private_memory_header.dart';
import 'package:go_router/go_router.dart';
import 'package:widget_zoom/widget_zoom.dart';

class PrivateMemoryPage extends StatefulWidget {
  final String memoryId;
  final String albumId;
  const PrivateMemoryPage(
      {Key? key, required this.memoryId, required this.albumId})
      : super(key: key);

  @override
  State<PrivateMemoryPage> createState() => _PrivateMemoryPageState();
}

class _PrivateMemoryPageState extends State<PrivateMemoryPage> {
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
  final DetailedPrivateMemory moment;
  const Content({super.key, required this.moment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  imageUrl: moment.photo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          PrivateMemoryHeader(
            moment: moment,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
