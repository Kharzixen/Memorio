import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/public_memories_cubit/public_memories_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/ui/widgets/create_public_memory_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PublicAlbumMemoriesContent extends StatefulWidget {
  final AlbumPreview album;
  const PublicAlbumMemoriesContent({super.key, required this.album});

  @override
  State<PublicAlbumMemoriesContent> createState() =>
      _PublicAlbumMemoriesContentState();
}

class _PublicAlbumMemoriesContentState extends State<PublicAlbumMemoriesContent>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<PublicMemoriesCubit>().loadMemories(widget.album.albumId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          var cubit = context.read<PublicMemoriesCubit>().stream.first;
          context.read<PublicMemoriesCubit>().refresh();
          await cubit;
        },
        child: ListView(
          children: [
            BlocBuilder<PublicMemoriesCubit, PublicMemoriesState>(
              builder: (context, state) {
                if (state is PublicMemoriesLoadedState) {
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
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            key: ValueKey(
                                "${state.dateGranularityIndex}_public_memories"),
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
                                              .read<PublicMemoriesCubit>()
                                              .increaseGranularity();
                                        },
                                        onTap: () {
                                          context
                                              .read<PublicMemoriesCubit>()
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
                                                  "/public-albums/${widget.album.albumId}/memories/${memory.memoryId}");
                                              if (response != null &&
                                                  context.mounted) {
                                                var popResponse = response
                                                    as PopPayload<String>;
                                                if (popResponse.actionType ==
                                                    ActionType.deleted) {
                                                  context
                                                      .read<
                                                          PublicMemoriesCubit>()
                                                      .removeMemory(
                                                          date, index);
                                                }
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
                                "${widget.album.albumId}_public_memories_page"),
                            onVisibilityChanged: (info) {
                              if (info.visibleFraction == 1.0) {
                                context
                                    .read<PublicMemoriesCubit>()
                                    .loadMemories(widget.album.albumId);
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CreatePublicMemoryBottomSheet(
                                          album: SimplePublicAlbum
                                              .fromAlbumPreview(widget.album),
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
                    );
                  }
                }

                if (state is PublicMemoriesLoadingState) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }

                if (state is PublicMemoriesErrorState) {
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
