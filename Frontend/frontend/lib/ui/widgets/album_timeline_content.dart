import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:frontend/bloc/collection_preview_bloc/collections_preview_bloc.dart';
import 'package:frontend/bloc/timeline_bloc/timeline_bloc.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/ui/widgets/bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TimelineContentGrid extends StatefulWidget {
  final SimpleAlbum album;
  const TimelineContentGrid({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  State<TimelineContentGrid> createState() => _TimelineContentGridState();
}

class _TimelineContentGridState extends State<TimelineContentGrid>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
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
    print("timelineBuild");
    context
        .read<TimelineBloc>()
        .add(NextDatasetTimelineFetched(albumId: widget.album.albumId));
    context.read<CollectionsPreviewBloc>();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading = false;
    });
    super.build(context);
    return BlocBuilder<TimelineBloc, TimelineState>(
      builder: (context, state) {
        if (state is TimelineLoadedState) {
          //after the tree is build set the notLoading value

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              Future block = context.read<TimelineBloc>().stream.first;
              context.read<TimelineBloc>().add(RefreshRequested());
              await block;
            },
            child: CustomScrollView(
              controller: ScrollController(),
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverToBoxAdapter(
                      child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0), // Start from right
                          end: const Offset(0.0, 0.0), // End at the center
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: state.photosByDate.isNotEmpty
                        ? ListView.builder(
                            key: ValueKey("${state.granularityIndex}_timeline"),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.photosByDate.length,
                            itemBuilder: (context, index) {
                              String date =
                                  state.photosByDate.keys.elementAt(index);
                              if (state.photosByDate[date] != null &&
                                  state.photosByDate[date]!.isNotEmpty) {
                                return ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 15),
                                      child: GestureDetector(
                                        onDoubleTap: () {
                                          context
                                              .read<TimelineBloc>()
                                              .add(IncreaseGranularity());
                                        },
                                        onTap: () {
                                          context
                                              .read<TimelineBloc>()
                                              .add(DecreaseGranularity());
                                        },
                                        child: Text(
                                          date,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 4,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.5),
                                      ),
                                      itemBuilder: (context, index) {
                                        Memory memory =
                                            state.photosByDate[date]![index];
                                        return GestureDetector(
                                            onTap: () async {
                                              String? response = await context.push(
                                                  "/albums/${widget.album.albumId}/memories/${memory.memoryId}");
                                              // if (response == "removed") {
                                              //   if (context.mounted) {
                                              //     context.read<TimelineBloc>().add(
                                              //         MemoryRemovedFromTimeline(
                                              //             memoryId:
                                              //                 memory.memoryId,
                                              //             date: date));
                                              //     context
                                              //         .read<
                                              //             CollectionsPreviewBloc>()
                                              //         .add(
                                              //             MemoryRemovedFromCollections(
                                              //                 memoryId: memory
                                              //                     .memoryId));
                                              //     ScaffoldMessenger.of(context)
                                              //         .showSnackBar(
                                              //       SnackBar(
                                              //         content: const Text(
                                              //             'Memory Removed'),
                                              //         backgroundColor:
                                              //             (Colors.black),
                                              //         action: SnackBarAction(
                                              //           label: 'Dismiss',
                                              //           onPressed: () {},
                                              //         ),
                                              //       ),
                                              //     );
                                              //   }
                                              // }
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: memory.photo,
                                              cacheManager: cacheManager,
                                              // placeholder: (context, url) =>
                                              //     const Center(
                                              //         child:
                                              //             CircularProgressIndicator()),
                                              fadeInDuration: Duration.zero,
                                              fadeOutDuration: Duration.zero,
                                              progressIndicatorBuilder:
                                                  (context, url, progress) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: progress.progress,
                                                  ),
                                                );
                                              },
                                              fit: BoxFit.cover,
                                            )
                                            // child: Image.network(
                                            //   memory.photo,
                                            //   fit: BoxFit.cover,
                                            //   loadingBuilder: (BuildContext context,
                                            //       Widget child,
                                            //       ImageChunkEvent? loadingProgress) {
                                            //     if (loadingProgress == null)
                                            //       return child;
                                            //     return Container(
                                            //       color: Colors.grey,
                                            //       child: const Center(
                                            //         child: CircularProgressIndicator(
                                            //             color: Colors.white),
                                            //       ),
                                            //     );
                                            //   },
                                            // ),
                                            );
                                      },
                                      itemCount:
                                          state.photosByDate[date]!.length,
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              key: const ValueKey("no_data_key"),
                              children: [
                                Center(
                                  child: Text(
                                    "Capture and share your memories",
                                    style: GoogleFonts.lato(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomBottomSheet(
                                                album: widget.album,
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.person_add,
                                          color: Colors.white,
                                        )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.exit_to_app_rounded,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  )),
                ),
                SliverToBoxAdapter(
                  child: VisibilityDetector(
                    key: ObjectKey("${state.albumId}_timeline"),
                    onVisibilityChanged: (info) {
                      if (info.visibleFraction == 1.0) {
                        context.read<TimelineBloc>().add(
                            NextDatasetTimelineFetched(
                                albumId: widget.album.albumId));
                      }
                    },
                    child: state.hasMoreData
                        ? const LinearProgressIndicator(
                            minHeight: 3,
                            color: Colors.blue,
                            backgroundColor: Colors.black,
                          )
                        : Container(),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
