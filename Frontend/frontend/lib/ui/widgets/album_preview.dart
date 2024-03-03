import 'package:flutter/material.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/ui/widgets/animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumPreviewCard extends StatelessWidget {
  final AlbumPreview albumPreview;
  const AlbumPreviewCard({Key? key, required this.albumPreview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late OverlayEntry imagePopup;

    return Column(
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
                  shape:
                      BoxShape.circle, // Use a circular shape for the container
                ),
                child: ClipOval(
                  child: Image.network(
                    albumPreview.albumPicture,
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
                child: Text(albumPreview.name,
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
            albumPreview.caption,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              albumPreview.imageIds.length,
              (index) {
                return Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onLongPress: () {
                      imagePopup =
                          _createPopupDialog(albumPreview.imageIds[index]);
                      Overlay.of(context).insert(imagePopup);
                    },
                    onLongPressEnd: (details) {
                      imagePopup.remove();
                    },
                    child: Container(
                      height: 120,
                      margin: EdgeInsets.only(
                          right: index < albumPreview.imageIds.length - 1
                              ? 2
                              : 0), // Apply margin only if it's not the last item
                      child: Image.network(
                        albumPreview.imageIds[index],
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
                );
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
    );
  }

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
        builder: (context) => AnimatedDialog(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
                child: Container(
                  height: 600,
                  color: Colors.grey.shade500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: NetworkImage(
                                          "http://static.everypixel.com/ep-pixabay/0623/4615/2345/80420/6234615234580420466-avatar.png"),
                                      fit: BoxFit.contain),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                            const SizedBox(width: 10),
                            Text("Uploader_name",
                                style: GoogleFonts.alegreya(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover // Replace with your image
                                ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.black,
                                size: 30,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.person_outline,
                                size: 32,
                                color: Colors.black,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 32,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}

// image handling
          //     Container(
          //         width:
          //             200.0, // set a fixed width or use constraints as needed
          //         height:
          //             200.0, // set a fixed height or use constraints as needed
          //         decoration: BoxDecoration(
          //           color: Colors.grey.shade600,
          //           borderRadius: BorderRadius.circular(10.0),
          //           image: DecorationImage(
          //             image: image.image,
          //             fit: imageHeight > imageWidth
          //                 ? BoxFit.fitHeight
          //                 : BoxFit.fitWidth,
          //           ),
          //         )),
