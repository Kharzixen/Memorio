import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/collection_preview_bloc/collections_preview_bloc.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/ui/widgets/collection_preview_card.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PrivateAlbumCollectionsContent extends StatefulWidget {
  final SimplePrivateAlbum album;
  const PrivateAlbumCollectionsContent({Key? key, required this.album})
      : super(key: key);

  @override
  State<PrivateAlbumCollectionsContent> createState() =>
      _PrivateAlbumCollectionsContentState();
}

class _PrivateAlbumCollectionsContentState
    extends State<PrivateAlbumCollectionsContent>
    with AutomaticKeepAliveClientMixin {
  List<PrivateCollectionPreview> collections = [];

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
                      physics: const NeverScrollableScrollPhysics(),
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
                                const Spacer(),
                                IconButton(
                                    onPressed: () async {
                                      var response = await context.push(
                                          "/albums/${widget.album.albumId}/create-collection");
                                      if (response != null) {
                                        PopPayload<PrivateCollectionPreview>
                                            popPayload = response as PopPayload<
                                                PrivateCollectionPreview>;
                                        if (popPayload.actionType ==
                                                ActionType.created &&
                                            context.mounted) {
                                          context
                                              .read<CollectionsPreviewBloc>()
                                              .add(NewCollectionCreated(
                                                  popPayload.data!));
                                        }
                                      }
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
                                    onTap: () async {
                                      var response = await context.push(
                                          "/albums/${widget.album.albumId}/collections/${state.collections[collectionIndex].collectionId}");
                                      if (response != null) {
                                        PopPayload<String> payload =
                                            response as PopPayload<String>;
                                        if (payload.actionType ==
                                                ActionType.deleted &&
                                            context.mounted) {
                                          context
                                              .read<CollectionsPreviewBloc>()
                                              .add(CollectionRemoved(
                                                  payload.data!));
                                        }
                                      }
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
  bool get wantKeepAlive => true;
}
