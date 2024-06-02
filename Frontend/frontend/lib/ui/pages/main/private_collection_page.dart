import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/bloc/timeline_bloc/timeline_bloc.dart';
import 'package:frontend/cubit/collection_cubit/collection_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/create_memory_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateCollectionPage extends StatefulWidget {
  final String albumId;
  final String collectionId;
  const PrivateCollectionPage(
      {super.key, required this.albumId, required this.collectionId});

  @override
  State<PrivateCollectionPage> createState() => _PrivateCollectionPageState();
}

class _PrivateCollectionPageState extends State<PrivateCollectionPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<CollectionPageCubit>()
        .loadCollection(widget.albumId, widget.collectionId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionPageCubit, CollectionPageState>(
      builder: (context, state) {
        if (state is CollectionPageLoadedState) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.grey.shade900.withOpacity(0.6),
                onPressed: () async {
                  var response = await showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context1) {
                      return CreateMemoryBottomSheet(
                        album: state.collectionPreview.simpleAlbum,
                        collection:
                            SimplePrivateCollection.fromCollectionPreview(
                                state.collectionPreview),
                      );
                    },
                  );
                  if (response != null) {
                    PopPayload popResponse = response as PopPayload;
                    if (popResponse.actionType == ActionType.created &&
                        context.mounted) {
                      context.read<TimelineBloc>().add(NewMemoryCreatedTimeline(
                          popResponse.data! as PrivateMemory));
                    }
                  }
                },
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              backgroundColor: Colors.black,
              appBar: AppBar(
                actions: [
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
                        case 'Delete collection':
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                backgroundColor: Colors.grey.shade800,
                                titleTextStyle: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                title: Text(
                                    'Are you sure you want to remove ${state.collectionPreview.collectionName} collection from this album ?'),
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
                                      context
                                          .read<CollectionPageCubit>()
                                          .deleteCollection();
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
                          break;

                        case 'Add photo':
                          var response = await context.push(
                              "/albums/${widget.albumId}/collections/${widget.collectionId}/add-photos");
                          if (response != null) {
                            List<PrivateMemory> memories = [];
                            PopPayload<List<PopPayload<dynamic>>> payload =
                                response
                                    as PopPayload<List<PopPayload<dynamic>>>;
                            if (payload.actionType == ActionType.multiAction) {
                              for (PopPayload<dynamic> action
                                  in payload.data!) {
                                if (payload.actionType == ActionType.created) {
                                  memories.add(action.data as PrivateMemory);
                                }
                              }
                            }
                            context
                                .read<CollectionPageCubit>()
                                .addExistingMemories(memories);
                          }
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      Set<String> options = {};
                      if (state.collectionPreview.creator.userId ==
                          StorageService().userId) {
                        options = {
                          'Edit',
                          'Delete collection',
                          'Add photo',
                          'Hide'
                        };
                      } else {
                        options = {'Add photo', 'Hide'};
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
                  ),
                ],
                title: Text(
                  state.collectionPreview.collectionName,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    child: RefreshIndicator.adaptive(
                      onRefresh: () async {
                        var cubit =
                            context.read<CollectionPageCubit>().stream.first;
                        context.read<CollectionPageCubit>().refreshCollection();
                        await cubit;
                      },
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Description:",
                            style: GoogleFonts.lato(
                                color: Colors.blue, fontSize: 19),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              state.collectionPreview.description,
                              style: GoogleFonts.lato(
                                  color: Colors.white, fontSize: 17),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade600,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          state.collectionPreview.creator
                                              .pfpLink,
                                          headers: HttpHeadersFactory
                                              .getDefaultRequestHeaderForImage(
                                                  TokenManager().accessToken!),
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    state.collectionPreview.creator.username,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Text(
                                    getDate(
                                        state.collectionPreview.creationDate),
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    getHour(
                                        state.collectionPreview.creationDate),
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return SizeTransition(
                                sizeFactor: Tween<double>(
                                  begin: 0.8, // Start with no size (hidden)
                                  end: 1.0, // End with full size (visible)
                                ).animate(animation),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(1.0, 0.0), // Start from right
                                    end: Offset(0.0, 0.0), // End at the center
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: state.memories.isNotEmpty
                                ? ListView.builder(
                                    key: ValueKey(
                                        "${state.dateGranularityIndex}_timeline"),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.memories.length,
                                    itemBuilder: (context, index) {
                                      String date =
                                          state.memories.keys.elementAt(index);
                                      if (state.memories[date] != null &&
                                          state.memories[date]!.isNotEmpty) {
                                        return ListView(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 15, 0, 15),
                                              child: GestureDetector(
                                                onDoubleTap: () {
                                                  context
                                                      .read<
                                                          CollectionPageCubit>()
                                                      .increaseGranularity();
                                                },
                                                onTap: () {
                                                  context
                                                      .read<
                                                          CollectionPageCubit>()
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
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            1.5),
                                              ),
                                              itemBuilder: (context, index) {
                                                PrivateMemory memory = state
                                                    .memories[date]![index];
                                                return GestureDetector(
                                                    onTap: () async {
                                                      var response =
                                                          await context.push(
                                                              "/albums/${widget.albumId}/memories/${memory.memoryId}");
                                                      if (response != null) {
                                                        PopPayload<String>
                                                            payload = response
                                                                as PopPayload<
                                                                    String>;
                                                        if (payload.actionType ==
                                                                ActionType
                                                                    .deleted &&
                                                            context.mounted) {
                                                          context
                                                              .read<
                                                                  CollectionPageCubit>()
                                                              .removeMemory(
                                                                  date, memory);
                                                        }
                                                      }
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: memory.photo,
                                                      httpHeaders: HttpHeadersFactory
                                                          .getDefaultRequestHeaderForImage(
                                                              TokenManager()
                                                                  .accessToken!),
                                                      fadeInDuration:
                                                          Duration.zero,
                                                      fadeOutDuration:
                                                          Duration.zero,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                              progress) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: progress
                                                                .progress,
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
                                                  state.memories[date]!.length,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  )
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet<void>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CreateMemoryBottomSheet(
                                                        album: state
                                                            .collectionPreview
                                                            .simpleAlbum,
                                                        collection: SimplePrivateCollection
                                                            .fromCollectionPreview(
                                                                state
                                                                    .collectionPreview),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.add_a_photo,
                                                  color: Colors.white,
                                                )),
                                            state.collectionPreview.creator
                                                        .userId ==
                                                    StorageService().userId
                                                ? IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ))
                                                : Container()
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  state.isAsyncMethodRunning
                      ? Container(
                          color: Colors.black.withOpacity(0.4),
                          child: const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ),
                        )
                      : Container()
                ],
              ));
        }

        if (state is CollectionPageLoadingState) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }

        if (state is CollectionPageDeletedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pop(PopPayload(ActionType.deleted, widget.collectionId));
          });
          return Container();
        }

        return const Center(
          child: Text(
            "Something wen't wrong.",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
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
