import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/collection_preview_bloc/collections_preview_bloc.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/ui/widgets/collection_preview_card.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CollectionsContent extends StatefulWidget {
  final SimpleAlbum album;
  const CollectionsContent({Key? key, required this.album}) : super(key: key);

  @override
  State<CollectionsContent> createState() => _CollectionsContentState();
}

class _CollectionsContentState extends State<CollectionsContent>
    with AutomaticKeepAliveClientMixin {
  List<CollectionPreview> collections = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("collections built");
    context
        .read<CollectionsPreviewBloc>()
        .add(NextDatasetFetched(albumId: widget.album.albumId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CollectionsPreviewBloc, CollectionsPreviewState>(
      builder: (context, state) {
        if (state is CollectionsPreviewLoadedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            isLoading = false;
          });

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              Future block =
                  context.read<CollectionsPreviewBloc>().stream.first;
              context
                  .read<CollectionsPreviewBloc>()
                  .add(CollectionRefreshRequested());
              await block;
            },
            child: CustomScrollView(
              controller: ScrollController(),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverToBoxAdapter(
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 25),
                            child: Row(
                              children: [
                                Text(
                                  "Collections:",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      context.push(
                                          "/albums/${widget.album.albumId}/create-collection");
                                    },
                                    icon: const Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        state.collections.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.collections.length,
                                itemBuilder: (context, collectionIndex) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(
                                          "/albums/${widget.album.albumId}/collections/${state.collections[collectionIndex].collectionId}");
                                    },
                                    child: CollectionPreviewCard(
                                      collection:
                                          state.collections[collectionIndex],
                                      album: widget.album,
                                    ),
                                  );
                                })
                            : Column(
                                children: [
                                  Text("This album has no collections",
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                  TextButton(
                                    onPressed: () {
                                      context.push(
                                          "/albums/${widget.album.albumId}/create-collection");
                                    },
                                    child: Text("Create a collection",
                                        style: GoogleFonts.lato(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                        VisibilityDetector(
                          key: ObjectKey("${state.albumId}collections"),
                          onVisibilityChanged: (info) {
                            if (!isLoading &&
                                info.visibleFraction == 1.0 &&
                                state.hasMoreData) {
                              isLoading = true;
                              context.read<CollectionsPreviewBloc>().add(
                                  NextDatasetFetched(
                                      albumId: widget.album.albumId));
                            }
                          },
                          child: state.hasMoreData
                              ? const LinearProgressIndicator(
                                  minHeight: 3,
                                  color: Colors.blue,
                                  backgroundColor: Colors.black,
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
