import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/public_memories_cubit/public_memories_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/ui/widgets/create_public_memory_bottom_sheet.dart';
import 'package:frontend/ui/widgets/public_album_highlights.dart';
import 'package:frontend/ui/widgets/public_album_memories.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicAlbumPage extends StatefulWidget {
  final String albumId;
  final AlbumPreview albumPreview;
  const PublicAlbumPage(
      {super.key, required this.albumId, required this.albumPreview});

  @override
  State<PublicAlbumPage> createState() => _PublicAlbumPageState();
}

class _PublicAlbumPageState extends State<PublicAlbumPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: "addMemoryTag",
          backgroundColor: Colors.grey.shade900.withOpacity(0.6),
          onPressed: () async {
            var response = await showModalBottomSheet(
              context: context,
              builder: (BuildContext context1) {
                return CreatePublicMemoryBottomSheet(
                  album:
                      SimplePublicAlbum.fromAlbumPreview(widget.albumPreview),
                );
              },
            );
            if (response != null) {
              PopPayload popResponse = response as PopPayload;
              if (popResponse.actionType == ActionType.created &&
                  context.mounted) {
                context
                    .read<PublicMemoriesCubit>()
                    .addNewMemory(popResponse.data as PublicMemory);
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
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: GestureDetector(
            onTap: () async {
              var returnObject = await context.push(
                  "/public-albums/${widget.albumPreview.albumId}/details");
              if (returnObject != null) {
                PopPayload popPayload = returnObject as PopPayload<String>;

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
                          widget.albumPreview.albumPicture,
                          headers: HttpHeadersFactory
                              .getDefaultRequestHeaderForImage(
                                  TokenManager().accessToken!),
                        )),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(right: 13.0),
                    child: Text(
                      widget.albumPreview.name,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
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
                text: "Highlights",
              ),
              Tab(
                text: "Memories",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PublicAlbumHighlights(
              albumId: widget.albumId,
            ),
            PublicAlbumMemoriesContent(album: widget.albumPreview),
          ],
        ),
      ),
    );
  }
}
