import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/memory_creation_bloc/memory_creation_bloc.dart';
import 'package:frontend/bloc/select_albums_sheet_bloc/select_albums_sheet_bloc.dart';
import 'package:frontend/bloc/select_collections_sheet_bloc/select_collections_sheet_bloc.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/data/repository/private_collection_repository.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateMemoryCreationAlbumsAndCollectionsSelectionWidget
    extends StatefulWidget {
  final Map<String, PrivateAlbumWithSelectedCollections> albums;
  final TabController tabController;
  const PrivateMemoryCreationAlbumsAndCollectionsSelectionWidget(
      {Key? key, required this.albums, required this.tabController})
      : super(key: key);

  @override
  State<PrivateMemoryCreationAlbumsAndCollectionsSelectionWidget>
      createState() =>
          _PrivateMemoryCreationAlbumsAndCollectionsSelectionWidgetState();
}

class _PrivateMemoryCreationAlbumsAndCollectionsSelectionWidgetState
    extends State<PrivateMemoryCreationAlbumsAndCollectionsSelectionWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          "Where this memory will be shared ?",
          style: GoogleFonts.lato(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Albums:",
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            BlocProvider(
              create: (context) => SelectAlbumsSheetBloc(
                  albumRepository: context.read<PrivateAlbumRepository>(),
                  initiallyIncludedAlbums: widget.albums.values
                      .map((e) => SimplePrivateAlbum(
                          albumId: e.albumId,
                          albumName: e.albumName,
                          albumPicture: e.albumPicture))
                      .toList()),
              child: Builder(builder: (context1) {
                return TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context2) {
                          return BlocProvider.value(
                              value: BlocProvider.of<SelectAlbumsSheetBloc>(
                                  context1),
                              child: BlocProvider.value(
                                  value: BlocProvider.of<MemoryCreationBloc>(
                                      context),
                                  child: AlbumSelectionWidget(
                                    includedAlbums: widget.albums.values
                                        .map((e) => SimplePrivateAlbum(
                                            albumId: e.albumId,
                                            albumName: e.albumName,
                                            albumPicture: e.albumPicture))
                                        .toList(),
                                  )));
                        });
                  },
                  child: const Text(
                    "Select Albums",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ),
          ],
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: widget.albums.entries
              .map(
                (album) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                imageUrl: album.value.albumPicture,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(album.value.albumName,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                              onPressed: () {
                                context.read<MemoryCreationBloc>().add(
                                    AlbumUnselected(
                                        albumId: album.value.albumId));
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Collections:",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            BlocProvider(
                              create: (context) => SelectCollectionsSheetBloc(
                                  collectionRepository: context
                                      .read<PrivateCollectionRepository>(),
                                  initiallyIncludedCollections:
                                      album.value.collections),
                              child: Builder(
                                builder: (context1) => TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context2) {
                                            return BlocProvider.value(
                                                value: BlocProvider.of<
                                                        SelectCollectionsSheetBloc>(
                                                    context1),
                                                child: BlocProvider.value(
                                                  value: BlocProvider.of<
                                                          MemoryCreationBloc>(
                                                      context),
                                                  child:
                                                      CollectionSelectionWidget(
                                                          albumId: album.key,
                                                          includedCollections:
                                                              widget
                                                                  .albums[album
                                                                      .key]!
                                                                  .collections),
                                                ));
                                          });
                                    },
                                    child: Text("Select collections")),
                              ),
                            ),
                          ],
                        ),
                      ),
                      album.value.collections.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                "No collection specified",
                                style: GoogleFonts.lato(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              )),
                            )
                          : Wrap(
                              children: album.value.collections
                                  .map((collection) => Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade900,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  collection.collectionName,
                                                  style: GoogleFonts.lato(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<
                                                          MemoryCreationBloc>()
                                                      .add(CollectionUnselected(
                                                          albumId: album
                                                              .value.albumId,
                                                          collection:
                                                              collection));
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  size: 15,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider()
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: 35,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    if (widget.tabController.index > 0) {
                      //context.read<MemoryCreationBloc>().add(PrevPageFetched());
                      widget.tabController
                          .animateTo(widget.tabController.index - 1);
                    }
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.navigate_before,
                          size: 23,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Back",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )),
              Spacer(),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  if (widget.tabController.index <
                      widget.tabController.length - 1) {
                    // context.read<MemoryCreationBloc>().add(NextPageFetched());
                    widget.tabController
                        .animateTo(widget.tabController.index + 1);
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Next",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.navigate_next,
                        size: 23,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class CollectionSelectionWidget extends StatefulWidget {
  final String albumId;
  final List<SimplePrivateCollection> includedCollections;
  const CollectionSelectionWidget(
      {Key? key, required this.albumId, required this.includedCollections})
      : super(key: key);

  @override
  State<CollectionSelectionWidget> createState() =>
      _CollectionSelectionWidgetState();
}

class _CollectionSelectionWidgetState extends State<CollectionSelectionWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    print("initState");
    super.initState();
    context
        .read<SelectCollectionsSheetBloc>()
        .add(NextCollectionsDatasetFetched(albumId: widget.albumId));

    //context.read<MemoryCreationBloc>().add(MemoryCreationEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<SelectCollectionsSheetBloc, SelectCollectionsSheetState>(
        builder: (context, state) {
      if (state is SelectCollectionsSheetLoadedState) {
        var sortedKeysForNotIncluded = state.collections.keys.toList()..sort();
        var sortedKeysForIncluded = state.includedCollections.keys.toList()
          ..sort();

        return Container(
          color: Colors.black,
          child: ListView(
            children: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                                                  state.includedCollections[e]!
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
                                                  context
                                                      .read<
                                                          MemoryCreationBloc>()
                                                      .add(CollectionUnselected(
                                                          albumId:
                                                              widget.albumId,
                                                          collection: state
                                                                  .includedCollections[
                                                              e]!));
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
                                                              .collections[e]!
                                                              .collectionId)));

                                                  context
                                                      .read<
                                                          MemoryCreationBloc>()
                                                      .add(CollectionSelected(
                                                          albumId:
                                                              widget.albumId,
                                                          collection:
                                                              state.collections[
                                                                  e]!));
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
                          )),
                        ),
                ],
              )
            ],
          ),
        );
      }
      return Text("asd");
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class AlbumSelectionWidget extends StatefulWidget {
  final List<SimplePrivateAlbum> includedAlbums;
  const AlbumSelectionWidget({Key? key, required this.includedAlbums})
      : super(key: key);

  @override
  State<AlbumSelectionWidget> createState() => _AlbumSelectionWidgetState();
}

class _AlbumSelectionWidgetState extends State<AlbumSelectionWidget> {
  @override
  void initState() {
    super.initState();
    context.read<SelectAlbumsSheetBloc>().add(NextAlbumsDatasetFetched(
        userId: StorageService().userId,
        includedAlbums: widget.includedAlbums));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectAlbumsSheetBloc, SelectAlbumsSheetState>(
      builder: (context, state) {
        if (state is SelectAlbumsSheetLoadedState) {
          List<String> includedAlbumsSortedKeys =
              state.includedAlbums.keys.toList()..sort();
          List<String> albumsSortedKeys = state.albums.keys.toList()..sort();
          return Container(
            color: Colors.black,
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      "Done",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Selected Albums:",
                      style: GoogleFonts.lato(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                includedAlbumsSortedKeys.isNotEmpty
                    ? ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: includedAlbumsSortedKeys
                            .map((e) => Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 15),
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
                                                imageUrl: state
                                                    .includedAlbums[e]!
                                                    .albumPicture,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                                state.includedAlbums[e]!
                                                    .albumName,
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
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
                                                        SelectAlbumsSheetBloc>()
                                                    .add(
                                                        AlbumRemovedFromIncluded(
                                                      albumId: state
                                                          .includedAlbums[e]!
                                                          .albumId,
                                                    ));

                                                context
                                                    .read<MemoryCreationBloc>()
                                                    .add(AlbumUnselected(
                                                      albumId: state
                                                          .includedAlbums[e]!
                                                          .albumId,
                                                    ));
                                              },
                                              icon: const Icon(
                                                Icons.close,
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
                        )),
                      ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Albums:",
                      style: GoogleFonts.lato(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                albumsSortedKeys.isNotEmpty
                    ? ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: albumsSortedKeys
                            .map((e) => Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 15),
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
                                                imageUrl: state
                                                    .albums[e]!.albumPicture,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                                state.albums[e]!.albumName,
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
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
                                                        SelectAlbumsSheetBloc>()
                                                    .add(AlbumAddedToIncluded(
                                                        albumId: state
                                                            .albums[e]!
                                                            .albumId));

                                                context
                                                    .read<MemoryCreationBloc>()
                                                    .add(AlbumSelected(
                                                        albumId: state
                                                            .albums[e]!.albumId,
                                                        album:
                                                            state.albums[e]!));
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
                        )),
                      ),
              ],
            ),
          );
        }
        return Text("error");
      },
    );
  }
}
