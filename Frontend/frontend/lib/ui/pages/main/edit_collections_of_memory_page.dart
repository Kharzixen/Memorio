import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/select_collections_sheet_bloc/select_collections_sheet_bloc.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class EditCollectionOfMemoryPage extends StatefulWidget {
  final DetailedPrivateMemory memory;
  const EditCollectionOfMemoryPage({super.key, required this.memory});

  @override
  State<EditCollectionOfMemoryPage> createState() =>
      _EditCollectionOfMemoryPageState();
}

class _EditCollectionOfMemoryPageState
    extends State<EditCollectionOfMemoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<SelectCollectionsSheetBloc>().add(
        NextCollectionsDatasetFetched(albumId: widget.memory.album.albumId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body:
          BlocBuilder<SelectCollectionsSheetBloc, SelectCollectionsSheetState>(
        builder: (context, state) {
          if (state is SelectCollectionsSheetLoadedState) {
            var sortedKeysForNotIncluded = state.collections.keys.toList()
              ..sort();
            var sortedKeysForIncluded = state.includedCollections.keys.toList()
              ..sort();

            return Container(
              color: Colors.black,
              child: ListView(
                children: [
                  TextButton(
                      onPressed: () {
                        context.pop(state.includedCollections.values.toList());
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Selected Collections:",
                            style: GoogleFonts.lato(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      // included lists
                      sortedKeysForIncluded.isNotEmpty
                          ? ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: sortedKeysForIncluded
                                  .map((e) => Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 15),
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      state
                                                          .includedCollections[
                                                              e]!
                                                          .collectionName,
                                                      maxLines: 2,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              SelectCollectionsSheetBloc>()
                                                          .add((CollectionRemovedFromIncluded(
                                                              collectionId: state
                                                                  .includedCollections[
                                                                      e]!
                                                                  .collectionId)));
                                                    },
                                                    icon: const Icon(
                                                      Icons.remove,
                                                      size: 25,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                  .toList())
                          : const Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                "No collections to show",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                      const Divider(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Collections:",
                            style: GoogleFonts.lato(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      // not included lists
                      sortedKeysForNotIncluded.isNotEmpty
                          ? ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: sortedKeysForNotIncluded
                                  .map((e) => Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 15),
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      state.collections[e]!
                                                          .collectionName,
                                                      maxLines: 2,
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              SelectCollectionsSheetBloc>()
                                                          .add((CollectionAddedToIncluded(
                                                              collectionId: state
                                                                  .collections[
                                                                      e]!
                                                                  .collectionId)));
                                                    },
                                                    icon: const Icon(
                                                      Icons.add,
                                                      size: 25,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            )
                          : const Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "No collections to show",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                    ],
                  )
                ],
              ),
            );
          }
          return Text("asd");
        },
      ),
    );
  }
}
