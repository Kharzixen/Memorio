import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/disposable_camera_memory_cubit/disposable_camera_memory_cubit.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widget_zoom/widget_zoom.dart';

class DisposableCameraMemoryPage extends StatefulWidget {
  final String albumId;
  final String memoryId;
  const DisposableCameraMemoryPage(
      {super.key, required this.albumId, required this.memoryId});

  @override
  State<DisposableCameraMemoryPage> createState() =>
      _DisposableCameraMemoryPageState();
}

class _DisposableCameraMemoryPageState
    extends State<DisposableCameraMemoryPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<DisposableCameraMemoryCubit>()
        .fetchDisposableCameraMemory(widget.albumId, widget.memoryId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          BlocBuilder<DisposableCameraMemoryCubit, DisposableCameraMemoryState>(
        builder: (context, state) {
          if (state is DisposableCameraMemoryLoadedState) {
            return ListView(
              children: [
                Container(
                  color: Colors.white.withOpacity(0.08),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: WidgetZoom(
                      heroAnimationTag: "tag",
                      zoomWidget: CachedNetworkImage(
                        imageUrl: state.memory.imageLink,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                foregroundImage:
                                    NetworkImage(state.memory.uploader.pfpLink),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                state.memory.uploader.username,
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                          state.memory.uploader.userId ==
                                  StorageService().userId
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
                                          builder:
                                              (BuildContext dialogContext) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              titleTextStyle: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              title: Text(
                                                  'Are you sure you want to delete this memory ? ${state.memory.memoryId}'),
                                              actions: [
                                                TextButton(
                                                  child: Text(
                                                    'Remove',
                                                    style: GoogleFonts.lato(
                                                        color:
                                                            Colors.red.shade800,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () async {
                                                    if (Navigator.of(context)
                                                        .canPop()) {
                                                      Navigator.of(
                                                              dialogContext,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    }
                                                    //need to await the run of this event, to perform the other deletion

                                                    context
                                                        .read<
                                                            DisposableCameraMemoryCubit>()
                                                        .deletePost();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Cancel',
                                                      style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  onPressed: () {
                                                    if (Navigator.of(context)
                                                        .canPop()) {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
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
                                    return {
                                      'Edit',
                                      'Remove',
                                    }.map((String choice) {
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
                                    return {'Report', 'Hide'}
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
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      state.memory.caption.isNotEmpty
                          ? Text(
                              state.memory.caption,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                getDate(state.memory.creationDate),
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                getHour(state.memory.creationDate),
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
                  ),
                )
              ],
            );
          }

          if (state is DisposableCameraMemoryLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is DisposableCameraMemoryDeletedState) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                if (context.canPop()) {
                  context.pop(PopPayload(ActionType.deleted, widget.memoryId));
                }
              },
            );
            return Container();
          }

          return const Text(
            "Unexpected error occurred",
            style: TextStyle(color: Colors.white),
          );
        },
      ),
    ));
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
