import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:frontend/cubit/disposable_camera_cubit/disposable_camera_cubit.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/create_disposable_camera_memory_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DisposableCameraWidget extends StatefulWidget {
  final String albumId;
  const DisposableCameraWidget({super.key, required this.albumId});

  @override
  State<DisposableCameraWidget> createState() => _DisposableCameraWidgetState();
}

class _DisposableCameraWidgetState extends State<DisposableCameraWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context
        .read<DisposableCameraCubit>()
        .loadDisposableCamera(widget.albumId, StorageService().userId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<DisposableCameraCubit, DisposableCameraState>(
      builder: (context, state) {
        if (state is DisposableCameraLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is DisposableCameraLoadedState) {
          if (state.albumInfo.disposableCamera.isActive) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  var cubit =
                      context.read<DisposableCameraCubit>().stream.first;
                  context.read<DisposableCameraCubit>().refreshState();
                  await cubit;
                },
                child: ListView(
                  controller: ScrollController(),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Disposable Camera",
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          color: Colors.grey.shade900,
                          icon: const Column(
                            children: [
                              Icon(
                                Icons.more_vert,
                                size: 25,
                                color: Colors.white,
                              )
                            ],
                          ),
                          onSelected: (value) async {
                            switch (value) {
                              case 'View all images':
                                context
                                    .read<DisposableCameraCubit>()
                                    .showAllImages(widget.albumId);
                                break;

                              case 'View your images':
                                context
                                    .read<DisposableCameraCubit>()
                                    .showYourImages(widget.albumId,
                                        StorageService().userId);
                                break;
                              case 'Report':
                                break;

                              case 'Close disposable camera':
                                showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey.shade800,
                                        titleTextStyle: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        title: const Text(
                                            'Are you sure you want to close the disposable camera of this album ?'),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'Close',
                                              style: GoogleFonts.lato(
                                                  color: Colors.red.shade800,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () async {
                                              if (Navigator.of(context)
                                                  .canPop()) {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              }
                                              context
                                                  .read<DisposableCameraCubit>()
                                                  .closeDisposableCamera();
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
                                                        rootNavigator: true)
                                                    .pop();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            Set<String> options = {};
                            if (state.albumInfo.owner.userId !=
                                StorageService().userId) {
                              options = {"Info", "Report"};
                            } else {
                              options = {
                                "Info",
                                "Report",
                                "Close disposable camera",
                                !state.isAllMemoryShowing
                                    ? "View all images"
                                    : "View your images"
                              };
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
                        )
                      ],
                    ),
                    state.albumInfo.disposableCamera.description.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              state.albumInfo.disposableCamera.description,
                              style: GoogleFonts.lato(
                                  color: Colors.white, fontSize: 18),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: TimerCountdown(
                        timeTextStyle: const TextStyle(color: Colors.white),
                        colonsTextStyle: const TextStyle(color: Colors.white),
                        descriptionTextStyle:
                            const TextStyle(color: Colors.white),
                        endTime: DateTime.now().add(
                          const Duration(
                            minutes: 10,
                            seconds: 00,
                          ),
                        ),
                        onEnd: () {},
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        state.isAllMemoryShowing
                            ? Text(
                                "All Memories",
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "Your Memories",
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            var response = await showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context1) {
                                return CreateDisposableCameraMemoryBottomSheet(
                                  simpleAlbum: SimplePrivateAlbum.fromAlbumInfo(
                                      state.albumInfo),
                                );
                              },
                            );
                            if (response != null) {
                              PopPayload popResponse = response as PopPayload;
                              if (popResponse.actionType ==
                                      ActionType.created &&
                                  context.mounted) {
                                context
                                    .read<DisposableCameraCubit>()
                                    .addNewMemory(
                                        popResponse.data! as PrivateMemory);
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.add_box_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    !state.isAllMemoryShowing
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 4,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.5),
                            ),
                            itemBuilder: ((context, index) {
                              return GestureDetector(
                                  onTap: () async {
                                    var response = await context.push(
                                        "/albums/${state.albumInfo.albumId}/disposable-camera-memories/${state.memories[index].memoryId}");
                                    if (response != null) {
                                      PopPayload<String> payload =
                                          response as PopPayload<String>;
                                      if (payload.actionType ==
                                              ActionType.deleted &&
                                          context.mounted) {
                                        context
                                            .read<DisposableCameraCubit>()
                                            .removeMemory(index);
                                      }
                                    }
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: state.memories[index].photo,
                                    fadeInDuration: Duration.zero,
                                    fadeOutDuration: Duration.zero,
                                    progressIndicatorBuilder:
                                        (context, url, progress) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  ));
                            }),
                            itemCount: state.memories.length,
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 4,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.5),
                            ),
                            itemBuilder: ((context, index) {
                              return GestureDetector(
                                  onTap: () async {
                                    var response = await context.push(
                                        "/albums/${state.albumInfo.albumId}/disposable-camera-memories/${state.allMemories[index].memoryId}");
                                    if (response != null) {
                                      PopPayload<String> payload =
                                          response as PopPayload<String>;
                                      if (payload.actionType ==
                                              ActionType.deleted &&
                                          context.mounted) {
                                        context
                                            .read<DisposableCameraCubit>()
                                            .removeMemory(index);
                                      }
                                    }
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: state.allMemories[index].photo,
                                    fadeInDuration: Duration.zero,
                                    fadeOutDuration: Duration.zero,
                                    progressIndicatorBuilder:
                                        (context, url, progress) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  ));
                            }),
                            itemCount: state.allMemories.length,
                          ),
                  ],
                ),
              ),
            );
          } else if (state.albumInfo.owner.userId != StorageService().userId) {
            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Disposable Camera is inactive",
                      style: GoogleFonts.lato(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "You can still upload memories",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          color: Colors.grey.shade400,
                        )),
                        const Text(
                          " or ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Expanded(
                            child: Divider(
                          color: Colors.grey.shade400,
                        )),
                      ]),
                    ),
                    Text(
                      "Contact the owner of the album for activation:",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          foregroundImage:
                              NetworkImage(state.albumInfo.owner.pfpLink),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          state.albumInfo.owner.username,
                          style: GoogleFonts.lato(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Disposable Camera is inactive",
                      style: GoogleFonts.lato(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "You can still upload memories",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Divider(
                            color: Colors.grey.shade400,
                          )),
                          const Text(
                            " or ",
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context1) {
                                final _descriptionController =
                                    TextEditingController();
                                context.read<DisposableCameraCubit>();
                                return Container(
                                  color: Colors.grey.shade900,
                                  width: double.infinity,
                                  child: ListView(
                                    children: [
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Center(
                                        child: Text(
                                          "Activate Disposable Camera",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        child: TextFormField(
                                          controller: _descriptionController,
                                          minLines: 2,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Text(
                                                "Write description for disposable camera",
                                                style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              borderSide: const BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Row(
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.white),
                                              onPressed: () {
                                                if (Navigator.of(context)
                                                    .canPop()) {
                                                  Navigator.of(
                                                    context,
                                                  ).pop();
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: Text(
                                                  "  Close  ",
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.white),
                                              onPressed: () {
                                                context
                                                    .read<
                                                        DisposableCameraCubit>()
                                                    .activateDisposableCamera(
                                                        _descriptionController
                                                            .text);
                                                if (Navigator.of(context)
                                                    .canPop()) {
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: Text(
                                                  "Activate",
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Activate Disposable Camera",
                            style: GoogleFonts.lato(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ))
                  ],
                ),
              ],
            );
          }
        }

        if (state is DisposableCameraErrorState) {
          return Text(
            state.message,
            style: TextStyle(color: Colors.white),
          );
        }

        return const Text(
          "Something went wrong",
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
