import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_bloc/private-album_bloc.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/create_memory_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widget_zoom/widget_zoom.dart';

class PrivateAlbumInfoPage extends StatefulWidget {
  final String albumId;
  const PrivateAlbumInfoPage({Key? key, required this.albumId})
      : super(key: key);

  @override
  State<PrivateAlbumInfoPage> createState() => _PrivateAlbumInfoPageState();
}

class _PrivateAlbumInfoPageState extends State<PrivateAlbumInfoPage> {
  @override
  void initState() {
    super.initState();
    context.read<AlbumBloc>().add(AlbumFetched(albumId: widget.albumId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white)),
        body: BlocBuilder<AlbumBloc, AlbumState>(
          builder: (context, state) {
            if (state is AlbumLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is AlbumLoadedState) {
              print(state.contributors[0].pfpLink);
              return Stack(
                children: [
                  RefreshIndicator.adaptive(
                    color: Colors.blue,
                    notificationPredicate: (notification) {
                      // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
                      return notification.depth == 1;
                    },
                    onRefresh: () async {
                      var bloc = context.read<AlbumBloc>().stream.first;
                      context.read<AlbumBloc>().add(Refresh());
                      await bloc;
                    },
                    child: NestedScrollView(
                      body: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification: (overscroll) {
                              overscroll.disallowIndicator();
                              return false;
                            },
                            child: CustomScrollView(
                              physics: const ClampingScrollPhysics(),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(minHeight: 60),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 25, 0, 5),
                                                child: Text(
                                                  "Description:",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 5, 0, 15),
                                                child: Text(
                                                  state
                                                          .albumInfo
                                                          .albumDescription
                                                          .isEmpty
                                                      ? "No Description"
                                                      : state.albumInfo
                                                          .albumDescription,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 25, 0, 20),
                                    child: Text(
                                      "Contributors:",
                                      style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                    onNotification: (overscroll) {
                                      overscroll.disallowIndicator();
                                      return false;
                                    },
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          (state.contributors.length).toInt() +
                                              1,
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            state.contributors.length) {
                                          //return LinearProgressIndicator();
                                          return Container();
                                        }
                                        return TextButton(
                                          onPressed: () {
                                            context.push(
                                                "/albums/${state.albumInfo.albumId}/contributors/${state.contributors[index].userId}");
                                          },
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              splashFactory:
                                                  NoSplash.splashFactory,
                                              backgroundColor:
                                                  Colors.transparent),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 15, 10, 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade600,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        state
                                                            .contributors[index]
                                                            .pfpLink,
                                                        headers: HttpHeadersFactory
                                                            .getDefaultRequestHeaderForImage(
                                                                TokenManager()
                                                                    .accessToken!),
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  state.contributors[index]
                                                      .username,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                state.contributors[index]
                                                            .userId ==
                                                        state.albumInfo.owner
                                                            .userId
                                                    ? Text(
                                                        "(owner)",
                                                        style: GoogleFonts.lato(
                                                            color: Colors.blue),
                                                      )
                                                    : Container(),
                                                const Spacer(),
                                                state.contributors[index]
                                                            .userId !=
                                                        StorageService().userId
                                                    ? PopupMenuButton<String>(
                                                        color: Colors
                                                            .grey.shade900,
                                                        icon: const Icon(
                                                          Icons.more_vert,
                                                          color: Colors.white,
                                                        ),
                                                        onSelected:
                                                            (value) async {
                                                          if (StorageService()
                                                                  .userId ==
                                                              state
                                                                  .albumInfo
                                                                  .owner
                                                                  .userId) {
                                                            switch (value) {
                                                              case 'Remove from album':
                                                                showDialog<
                                                                    void>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          dialogContext) {
                                                                    return AlertDialog(
                                                                      backgroundColor: Colors
                                                                          .grey
                                                                          .shade800,
                                                                      titleTextStyle: GoogleFonts.lato(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      title: Text(
                                                                          'Are you sure you want to remove ${state.contributors[index].username} from this album ?'),
                                                                      actions: [
                                                                        TextButton(
                                                                          child:
                                                                              Text(
                                                                            'Remove',
                                                                            style: GoogleFonts.lato(
                                                                                color: Colors.red.shade800,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            if (Navigator.of(context).canPop()) {
                                                                              Navigator.of(dialogContext, rootNavigator: true).pop();
                                                                            }

                                                                            context.read<AlbumBloc>().add(RemoveUserFromAlbumInitiated(state.contributors[index].userId));
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          child: Text(
                                                                              'Cancel',
                                                                              style: GoogleFonts.lato(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                                                                          onPressed:
                                                                              () {
                                                                            if (Navigator.of(context).canPop()) {
                                                                              Navigator.of(context, rootNavigator: true).pop();
                                                                            }
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                                break;
                                                              case 'Report':
                                                                break;
                                                              case 'Block':
                                                                break;
                                                            }
                                                          } else {
                                                            switch (value) {
                                                              case 'Block':
                                                                break;
                                                              case 'Report':
                                                                break;
                                                            }
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (BuildContext
                                                                context) {
                                                          Set<String> options =
                                                              {};
                                                          if (StorageService()
                                                                  .userId ==
                                                              state
                                                                  .albumInfo
                                                                  .owner
                                                                  .userId) {
                                                            options = {
                                                              "Block",
                                                              "Report",
                                                              "Remove from album",
                                                            };
                                                          } else {
                                                            options = {
                                                              "Block",
                                                              "Report"
                                                            };
                                                          }
                                                          return options.map(
                                                              (String choice) {
                                                            return PopupMenuItem<
                                                                String>(
                                                              value: choice,
                                                              child: Text(
                                                                choice,
                                                                style: GoogleFonts.lato(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            );
                                                          }).toList();
                                                        },
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Column(
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(
                                        minHeight: 120,
                                        maxHeight: 120,
                                        minWidth: 120,
                                        maxWidth: 120),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                    child: ClipOval(
                                      clipBehavior: Clip.hardEdge,
                                      child: WidgetZoom(
                                        heroAnimationTag: "tag",
                                        zoomWidget: CachedNetworkImage(
                                          fadeInDuration: Duration.zero,
                                          fadeOutDuration: Duration.zero,
                                          httpHeaders: HttpHeadersFactory
                                              .getDefaultRequestHeaderForImage(
                                                  TokenManager().accessToken!),
                                          imageUrl:
                                              state.albumInfo.albumPicture,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    state.albumInfo
                                        .name, // Assuming albumInfo is accessible in this scope
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ]),
                          ),
                          SliverAppBar(
                            pinned: true,
                            floating: false,
                            backgroundColor: Colors.black,
                            automaticallyImplyLeading: false,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    var response = await context.push(
                                        "/albums/${state.albumInfo.albumId}/invitations-page");
                                    if (response != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(response as String),
                                        backgroundColor: Colors.grey.shade900,
                                      ));
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.person_add_alt_1_outlined,
                                    size: 31,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CreateMemoryBottomSheet(
                                          album: SimplePrivateAlbum(
                                              albumId: state.albumInfo.albumId,
                                              albumName: state.albumInfo.name,
                                              albumPicture:
                                                  state.albumInfo.albumPicture),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  color: Colors.grey.shade900,
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  onSelected: (value) async {
                                    if (StorageService().userId ==
                                        state.albumInfo.owner.userId) {
                                      switch (value) {
                                        case 'Hide':
                                          break;
                                        case 'Delete this album':
                                          break;
                                        case 'Leave this album':
                                          showDialog<void>(
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.grey.shade800,
                                                titleTextStyle:
                                                    GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                title: Text(
                                                    'Are you sure you want to leave this ${state.albumInfo.name} album ?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      'Leave',
                                                      style: GoogleFonts.lato(
                                                          color: Colors
                                                              .red.shade800,
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

                                                      context.read<AlbumBloc>().add(
                                                          RemoveUserFromAlbumInitiated(
                                                              StorageService()
                                                                  .userId));
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Cancel',
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
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
                                          break;
                                      }
                                    } else {
                                      switch (value) {
                                        case 'Report':
                                          break;
                                        case 'Hide':
                                          break;
                                        case 'Leave this album':
                                          return showDialog<void>(
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.grey.shade800,
                                                titleTextStyle:
                                                    GoogleFonts.lato(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                title: Text(
                                                    'Are you sure you want to leave this ${state.albumInfo.name} album ?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      'Leave',
                                                      style: GoogleFonts.lato(
                                                          color: Colors
                                                              .red.shade800,
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

                                                      context.read<AlbumBloc>().add(
                                                          RemoveUserFromAlbumInitiated(
                                                              StorageService()
                                                                  .userId));
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Cancel',
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
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
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    Set<String> options = {};
                                    if (StorageService().userId ==
                                        state.albumInfo.owner.userId) {
                                      options = {
                                        "Delete this album",
                                        "Leave this album",
                                      };
                                    } else {
                                      options = {"Leave this album", "Report"};
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
                            ),
                          )
                        ];
                      },
                    ),
                  ),
                  state.isAsyncActionRunning
                      ? Container(
                          color: Colors.black.withOpacity(0.4),
                          child: const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ),
                        )
                      : Container(),
                ],
              );
            }

            if (state is LeavedAlbumState) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  context.pop(
                      PopPayload<String>(ActionType.leaved, widget.albumId));
                },
              );
              return Container();
            }

            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
