import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:frontend/cubit/add_memories_to_collection_cubit/add_memories_to_collection_cubit.dart';
import 'package:frontend/model/album_model.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMemoriesToCollectionPage extends StatefulWidget {
  final String albumId;
  final String collectionId;
  const AddMemoriesToCollectionPage(
      {super.key, required this.albumId, required this.collectionId});

  @override
  State<AddMemoriesToCollectionPage> createState() =>
      _AddMemoriesToCollectionPageState();
}

class _AddMemoriesToCollectionPageState
    extends State<AddMemoriesToCollectionPage> {
  CacheManager cacheManager = CacheManager(
    Config(
      'images_cache_key',
      stalePeriod: const Duration(minutes: 3),
      maxNrOfCacheObjects: 50,
    ),
  );

  @override
  void initState() {
    super.initState();
    context
        .read<AddMemoriesToCollectionCubit>()
        .loadMemoriesWhichCanBeAddedToCollection(
            widget.albumId, widget.collectionId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMemoriesToCollectionCubit,
        AddMemoriesToCollectionPageState>(
      builder: (context, state) {
        if (state is AddMemoriesToCollectionPageLoadedState) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                Text(
                  "${state.nrOfSelected} Selected",
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 20,
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       padding: EdgeInsets.zero,
                //       backgroundColor: Colors.transparent),
                //   onPressed: () {
                //     if (state.nrOfSelected != state.memories.length) {
                //       context.read<AddMemoriesToCollectionCubit>().selectAll();
                //     } else {}
                //   },
                //   child: state.nrOfSelected == state.memories.length
                //       ? Container(
                //           width: 26,
                //           height: 26,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(100),
                //             border: Border.all(color: Colors.white, width: 1),
                //             color: Colors.blue.withOpacity(0.9),
                //           ),
                //           child: const Icon(
                //             Icons.check_rounded,
                //             size: 25,
                //             color: Colors.black,
                //           ),
                //         )
                //       : Container(
                //           width: 26,
                //           height: 26,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(100),
                //             border: Border.all(color: Colors.white, width: 1),
                //             color: Colors.grey.shade700.withOpacity(0.9),
                //           ),
                //         ),
                // ),
                // Text(
                //   "Select All",
                //   style: TextStyle(color: Colors.white, fontSize: 20),
                // ),
                // SizedBox(
                //   width: 20,
                // )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Select images",
                    style: GoogleFonts.lato(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  state.memories.isEmpty
                      ? SizedBox(
                          height: 500,
                          child: Center(
                            child: Text("No images to show",
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 4,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.5),
                          ),
                          itemBuilder: (context, index) {
                            Memory memory = state.memories[index];
                            return GestureDetector(
                              onTap: () {
                                print("tapped");
                                if (state.isSelected[index]) {
                                  context
                                      .read<AddMemoriesToCollectionCubit>()
                                      .unselectMemory(index);
                                } else {
                                  context
                                      .read<AddMemoriesToCollectionCubit>()
                                      .selectMemory(index);
                                }
                              },
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: memory.photo,
                                    cacheManager: cacheManager,
                                    fadeInDuration: Duration.zero,
                                    fadeOutDuration: Duration.zero,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    progressIndicatorBuilder:
                                        (context, url, progress) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  ),
                                  state.isSelected[index]
                                      ? Container(
                                          color: Colors.black.withOpacity(0.4),
                                        )
                                      : Container(),
                                  state.isSelected[index]
                                      ? Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
                                              color:
                                                  Colors.blue.withOpacity(0.9),
                                            ),
                                            child: const Icon(
                                              Icons.check_rounded,
                                              size: 25,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
                                              color: Colors.grey.shade700
                                                  .withOpacity(0.9),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            );
                          },
                          itemCount: state.memories.length,
                        ),
                ],
              ),
            ),
          );
        }

        if (state is AddMemoriesToCollectionPageInitialState) {
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
        return const Text("Something went wrong");
      },
    );
  }
}
