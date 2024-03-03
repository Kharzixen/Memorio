import 'package:flutter/material.dart';
import 'package:frontend/model/album_model.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionContent extends StatelessWidget {
  final List<CollectionPreview> collections;
  const CollectionContent({Key? key, required this.collections})
      : super(key: key);

  final double _collectionCardSize = 200;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 600),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 25),
              child: Text("Collections:",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alegreya(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: collections.length,
              itemBuilder: (context, index) {
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(
                                4,
                                (previewIndex) {
                                  return Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 140, // Conditional height
                                      margin: EdgeInsets.only(
                                          right: index < 4 - 1
                                              ? 2
                                              : 0), // Apply margin only if it's not the last item,
                                      child: previewIndex <
                                              collections[index]
                                                  .previewEntries
                                                  .length
                                          ? previewIndex < 3
                                              ? Image.network(
                                                  collections[index]
                                                      .previewEntries[
                                                          previewIndex]
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
                                                )
                                              : Stack(
                                                  children: [
                                                    Image.network(
                                                      height: 140,
                                                      collections[index]
                                                          .previewEntries[
                                                              previewIndex]
                                                          .photo,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (BuildContext
                                                              context,
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
                                  child: Text(collections[index].collectionName,
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.alegreya(
                                          color: Colors.white,
                                          fontSize: 17,
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
              }),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            )),
          ),
        ],
      ),
    );
  }
}
