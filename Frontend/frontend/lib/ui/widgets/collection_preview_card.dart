import 'package:flutter/material.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_creation_details.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CollectionPreviewCard extends StatelessWidget {
  final CollectionPreview collection;
  final SimpleAlbum album;
  final double _collectionCardSize = 200;
  const CollectionPreviewCard(
      {super.key, required this.collection, required this.album});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: _collectionCardSize,
            width: double.infinity,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.white,
              width: 1,
            ))),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: collection.latestMemories.isEmpty
                    ? Container(
                        height: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "This collection is empty.",
                              style: GoogleFonts.lato(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      context.push("/createMemory",
                                          extra: MemoryCreationDetails(
                                              source: ImageSource.camera,
                                              album: album,
                                              collection: SimpleCollection
                                                  .fromCollectionPreview(
                                                      collection)));
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      context.push("/createMemory",
                                          extra: MemoryCreationDetails(
                                              source: ImageSource.gallery,
                                              album: album,
                                              collection: SimpleCollection
                                                  .fromCollectionPreview(
                                                      collection)));
                                    },
                                    icon: const Icon(
                                      Icons.add_photo_alternate,
                                      size: 27,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          4,
                          (memoryIndex) {
                            return Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 1, right: 1),
                                child: Container(
                                  height: 140, // Conditional height
                                  child: memoryIndex <
                                          collection.latestMemories.length
                                      ? memoryIndex < 3
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                collection
                                                    .latestMemories[memoryIndex]
                                                    .photo,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Stack(
                                              children: [
                                                Image.network(
                                                  height: 140,
                                                  collection
                                                      .latestMemories[
                                                          memoryIndex]
                                                      .photo,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Container(
                                                  height: 140,
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                ),
                                                const Center(
                                                    child: Icon(
                                                  Icons.more_horiz,
                                                  size: 50,
                                                )),
                                              ],
                                            )
                                      : Container(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(collection.collectionName,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                        onPressed: () {
                          print("button");
                        },
                        icon: const Icon(
                          Icons.navigate_next_sharp,
                          size: 28,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ])),
        const SizedBox(
          height: 35,
        ),
      ],
    );
  }
}
