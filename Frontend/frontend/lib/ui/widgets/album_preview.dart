import 'package:flutter/material.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/ui/widgets/animated_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumPreviewCard extends StatefulWidget {
  final AlbumPreview albumPreview;
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
      onTap: () {
        context.push("/albums/${widget.albumPreview.albumId}",
            extra: SimpleAlbum.fromAlbumPreview(widget.albumPreview));
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
                    child: Image.network(
                      widget.albumPreview.albumPicture,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          color: Colors.grey,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
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
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      size: 25,
                      color: Colors.white,
                    )),
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
                              onPressed: () {},
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
                                child: Image.network(
                                  widget
                                      .albumPreview.previewImages[index].photo,
                                  fit: BoxFit.cover,
                                  height: 120,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Container(
                                        color: Colors.grey.shade800,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      );
                                    }
                                  },
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

  OverlayEntry _createPopupDialog(Memory memory) {
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
                        foregroundImage: NetworkImage(memory.uploader.pfpLink),
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
                          image: NetworkImage(memory.photo),
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
