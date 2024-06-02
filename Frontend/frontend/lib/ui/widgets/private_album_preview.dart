import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_preview_bloc/private_albums_preview_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/ui/widgets/animated_dialog.dart';
import 'package:frontend/ui/widgets/create_memory_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumPreviewCard extends StatefulWidget {
  final PrivateAlbumPreview albumPreview;
  AlbumPreviewCard({Key? key, required this.albumPreview}) : super(key: key);

  @override
  State<AlbumPreviewCard> createState() => _AlbumPreviewCardState();
}

class _AlbumPreviewCardState extends State<AlbumPreviewCard> {
  late OverlayEntry imagePopup;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        var returnObject = await context.push(
            "/albums/${widget.albumPreview.albumId}",
            extra: widget.albumPreview);
        if (returnObject != null) {
          PopPayload<String> popPayload = returnObject as PopPayload<String>;

          if (popPayload.actionType == ActionType.leaved) {
            if (context.mounted) {
              context
                  .read<PrivateAlbumsPreviewBloc>()
                  .add(PrivateAlbumLeaved(popPayload.data!));
            }
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
            child: Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: const BoxDecoration(
                    shape: BoxShape
                        .circle, // Use a circular shape for the container
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.albumPreview.albumPicture,
                      fit: BoxFit.cover,
                      httpHeaders:
                          HttpHeadersFactory.getDefaultRequestHeaderForImage(
                              TokenManager().accessToken!),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(widget.albumPreview.name,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ),
                PopupMenuButton<String>(
                  color: Colors.grey.shade900,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onSelected: (value) async {
                    switch (value) {
                      case "Leave this album":
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
                                  'Are you sure you want to leave this ${widget.albumPreview.name} album ?'),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'Leave',
                                    style: GoogleFonts.lato(
                                        color: Colors.red.shade800,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    context
                                        .read<PrivateAlbumsPreviewBloc>()
                                        .add(PrivateLeaveAlbum(
                                            widget.albumPreview.albumId));
                                    if (Navigator.of(dialogContext).canPop()) {
                                      Navigator.of(dialogContext,
                                              rootNavigator: true)
                                          .pop();
                                    }
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
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      case "Add memory":
                        var response = await showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context1) {
                            return CreateMemoryBottomSheet(
                              album: SimplePrivateAlbum.fromAlbumPreview(
                                  widget.albumPreview),
                            );
                          },
                        );
                        if (response != null) {
                          PopPayload popResponse = response as PopPayload;
                          if (popResponse.actionType == ActionType.created &&
                              context.mounted) {
                            context.read<PrivateAlbumsPreviewBloc>().add(
                                PrivateNewImageCreatedForAlbum(
                                    widget.albumPreview.albumId,
                                    popResponse.data! as PrivateMemory));
                          }
                        }
                        break;
                      case "Invite people":
                        var response = await context.push(
                            "/albums/${widget.albumPreview.albumId}/invitations-page");
                        if (response != null && context.mounted) {
                          String message = response as String;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.grey.shade800,
                              content: Text(message)));
                        }

                        break;
                      case "Report":
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    Set<String> options = {};

                    options = {
                      "Leave this album",
                      "Add memory",
                      "Invite people",
                      "Report",
                    };

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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
            child: Text(
              widget.albumPreview.caption,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: widget.albumPreview.previewImages.isEmpty
                ? Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "This album is empty.",
                        style: GoogleFonts.lato(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () async {
                                var response = await showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context1) {
                                    return CreateMemoryBottomSheet(
                                      album:
                                          SimplePrivateAlbum.fromAlbumPreview(
                                              widget.albumPreview),
                                    );
                                  },
                                );
                                if (response != null) {
                                  PopPayload popResponse =
                                      response as PopPayload;
                                  if (popResponse.actionType ==
                                          ActionType.created &&
                                      context.mounted) {
                                    context
                                        .read<PrivateAlbumsPreviewBloc>()
                                        .add(PrivateNewImageCreatedForAlbum(
                                            widget.albumPreview.albumId,
                                            popResponse.data!
                                                as PrivateMemory));
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () async {
                                var response = await context.push(
                                    "/albums/${widget.albumPreview.albumId}/invitations-page");
                                if (response != null && context.mounted) {
                                  String message = response as String;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.grey.shade800,
                                          content: Text(message)));
                                }
                              },
                              icon: const Icon(
                                Icons.person_add,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () async {
                                return showDialog<void>(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey.shade800,
                                      titleTextStyle: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      title: Text(
                                          'Are you sure you want to leave this ${widget.albumPreview.name} album ?'),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            'Leave',
                                            style: GoogleFonts.lato(
                                                color: Colors.red.shade800,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () async {
                                            context
                                                .read<
                                                    PrivateAlbumsPreviewBloc>()
                                                .add(PrivateLeaveAlbum(widget
                                                    .albumPreview.albumId));
                                            if (Navigator.of(dialogContext)
                                                .canPop()) {
                                              Navigator.of(dialogContext,
                                                      rootNavigator: true)
                                                  .pop();
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Cancel',
                                              style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
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
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.exit_to_app_rounded,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      4,
                      (index) {
                        if (index < widget.albumPreview.previewImages.length) {
                          return Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onLongPress: () {
                                imagePopup = _createPopupDialog(
                                    widget.albumPreview.previewImages[index]);
                                Overlay.of(context).insert(imagePopup);
                              },
                              onLongPressEnd: (details) {
                                imagePopup.remove();
                              },
                              child: Container(
                                height: 120,
                                margin: EdgeInsets.only(
                                    right: index <
                                            widget.albumPreview.previewImages
                                                    .length -
                                                1
                                        ? 2
                                        : 0), // Apply margin only if it's not the last item
                                child: CachedNetworkImage(
                                  imageUrl: widget
                                      .albumPreview.previewImages[index].photo,
                                  httpHeaders: HttpHeadersFactory
                                      .getDefaultRequestHeaderForImage(
                                          TokenManager().accessToken!),
                                  fit: BoxFit.cover,
                                  height: 120,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Expanded(
                              child: SizedBox(
                            height: 120,
                          ));
                        }
                      },
                    ),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  OverlayEntry _createPopupDialog(PrivateMemory memory) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
          child: Container(
            height: 600,
            color: Colors.grey.shade800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(
                          memory.uploader.pfpLink,
                          headers: HttpHeadersFactory
                              .getDefaultRequestHeaderForImage(
                                  TokenManager().accessToken!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        memory.uploader.username,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            getDate(memory.date),
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            getHour(memory.date),
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            memory.photo,
                            headers: HttpHeadersFactory
                                .getDefaultRequestHeaderForImage(
                                    TokenManager().accessToken!),
                          ),
                          fit: BoxFit.cover // Replace with your image
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
