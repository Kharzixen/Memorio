import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/highlighted_memories_cubit/highlighted_memories_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PublicAlbumHighlights extends StatefulWidget {
  final String albumId;
  const PublicAlbumHighlights({super.key, required this.albumId});

  @override
  State<PublicAlbumHighlights> createState() => _PublicAlbumHighlightsState();
}

class _PublicAlbumHighlightsState extends State<PublicAlbumHighlights> {
  @override
  void initState() {
    super.initState();
    context.read<HighlightedMemoriesCubit>().loadMemories(widget.albumId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          var cubit = context.read<HighlightedMemoriesCubit>().stream.first;
          context.read<HighlightedMemoriesCubit>().refresh();
          await cubit;
        },
        child: ListView(
          children: [
            BlocBuilder<HighlightedMemoriesCubit, HighlightedMemoriesState>(
              builder: (context, state) {
                if (state is HighlightedMemoriesLoadedState) {
                  if (state.memories.isNotEmpty) {
                    return AnimatedSwitcher(
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
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ListView.builder(
                            key: ValueKey(
                                "${state.dateGranularityIndex}_public_memories"),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.memories.length,
                            itemBuilder: (context, index) {
                              String date =
                                  state.memories.keys.elementAt(index);
                              if (state.memories[date] != null &&
                                  state.memories[date]!.isNotEmpty) {
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
                                              .read<HighlightedMemoriesCubit>()
                                              .increaseGranularity();
                                        },
                                        onTap: () {
                                          context
                                              .read<HighlightedMemoriesCubit>()
                                              .decreaseGranularity();
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
                                        PublicMemory memory =
                                            state.memories[date]![index];
                                        return GestureDetector(
                                            onTap: () async {
                                              var response = await context.push(
                                                  "/public-albums/${widget.albumId}/memories/${memory.memoryId}");
                                              if (response != null) {
                                                print(response);
                                              }
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: memory.photo,
                                              // placeholder: (context, url) =>
                                              //     const Center(
                                              //         child:
                                              //             CircularProgressIndicator()),
                                              fadeInDuration: Duration.zero,
                                              fadeOutDuration: Duration.zero,
                                              httpHeaders: HttpHeadersFactory
                                                  .getDefaultRequestHeaderForImage(
                                                      TokenManager()
                                                          .accessToken!),
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
                                            ));
                                      },
                                      itemCount: state.memories[date]!.length,
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          VisibilityDetector(
                            key: ObjectKey(
                                "${widget.albumId}_public_memories_page"),
                            onVisibilityChanged: (info) {
                              if (info.visibleFraction == 1.0) {
                                context
                                    .read<HighlightedMemoriesCubit>()
                                    .loadMemories(widget.albumId);
                              }
                            },
                            child: state.hasMoreData
                                ? const LinearProgressIndicator(
                                    minHeight: 3,
                                    color: Colors.blue,
                                    backgroundColor: Colors.black,
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(
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
                        ],
                      ),
                    );
                  }
                }

                if (state is HighlightedMemoriesLoadingState) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }

                if (state is HighlightedMemoriesErrorState) {
                  return Center(
                      child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ));
                }

                return const Center(
                  child: LinearProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
