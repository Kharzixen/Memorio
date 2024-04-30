import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/collection_preview_bloc/collections_preview_bloc.dart';
import 'package:frontend/bloc/timeline_bloc/timeline_bloc.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/ui/widgets/album_collections_content.dart';
import 'package:frontend/ui/widgets/album_timeline_content.dart';
import 'package:frontend/ui/widgets/bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumPage extends StatelessWidget {
  final String albumId;
  final SimpleAlbum simpleAlbum;
  const AlbumPage({Key? key, required this.albumId, required this.simpleAlbum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade900.withOpacity(0.6),
          onPressed: () async {
            var response = await showModalBottomSheet(
              context: context,
              builder: (BuildContext context1) {
                return BlocProvider.value(
                  value: context.read<TimelineBloc>(),
                  child: CustomBottomSheet(
                    album: simpleAlbum,
                  ),
                );
              },
            );
            if (response != null) {
              PopPayload popResponse = response as PopPayload;
              if (popResponse.actionType == ActionType.created &&
                  context.mounted) {
                context
                    .read<TimelineBloc>()
                    .add(NewMemoryCreatedTimeline(popResponse.data! as Memory));
              }
            }
          },
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 30,
          ),
        ),
        backgroundColor: Colors.black,
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, _) {
              return [
                SliverAppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.black,
                  pinned: true,
                  floating: true,
                  title: GestureDetector(
                    onTap: () async {
                      var returnObject = await context
                          .push("/albums/${simpleAlbum.albumId}/details");
                      if (returnObject != null) {
                        PopPayload popPayload =
                            returnObject as PopPayload<String>;

                        if (popPayload.actionType == ActionType.leaved) {
                          if (context.mounted) {
                            context.pop(popPayload);
                          }
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    simpleAlbum.albumPicture)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Text(
                          simpleAlbum.albumName,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.alegreya(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  bottom: const TabBar(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    dividerColor: Colors.white,
                    dividerHeight: 2,
                    indicatorColor: Colors.blue,
                    unselectedLabelColor: Colors.white,
                    labelColor: Colors.blue,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        text: "Timeline",
                      ),
                      Tab(
                        text: "Collection",
                      ),
                      Tab(
                        text: "Notes",
                      )
                    ],
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: AlbumHeaderCard(
                //     albumInfo: state.albumInfo,
                //   ),
                // ),
              ];
            },
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      BlocProvider.value(
                        value: context.read<TimelineBloc>(),
                        child: TimelineContentGrid(
                          album: simpleAlbum,
                        ),
                      ),
                      //second tab

                      BlocProvider.value(
                        value: context.read<CollectionsPreviewBloc>(),
                        child: CollectionsContent(
                          album: simpleAlbum,
                        ),
                      ),
                      //third tab
                      Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
