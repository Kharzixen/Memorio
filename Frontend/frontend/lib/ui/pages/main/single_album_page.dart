import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_bloc/album_bloc.dart';
import 'package:frontend/ui/widgets/album_collections_content.dart';
import 'package:frontend/ui/widgets/album_header.dart';
import 'package:frontend/ui/widgets/album_submenu.dart';
import 'package:frontend/ui/widgets/album_timeline_content.dart';
import 'package:sticky_headers/sticky_headers.dart';

class AlbumPage extends StatefulWidget {
  final String albumId;
  const AlbumPage({Key? key, required this.albumId}) : super(key: key);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  GlobalKey albumHeaderKey = GlobalKey();
  double albumHeaderSize = 0.0;

  final double _stickyHeaderSize = 60;

  @override
  void initState() {
    super.initState();
    context.read<AlbumBloc>().add(AlbumFetched(albumId: widget.albumId));
  }

  @override
  Widget build(BuildContext context) {
    bool _isTimelineLoading = false;
    bool _isStickyHeaderAtTop = false;

    final ScrollController _scrollController = ScrollController();

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chat_rounded,
                  size: 23,
                )),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        body: BlocBuilder<AlbumBloc, AlbumState>(
          builder: (context, state) {
            if (state is AlbumLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }

            if (state is AlbumLoadedState) {
              if (albumHeaderSize == 0.0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  RenderBox? momentHeaderRenderBox =
                      albumHeaderKey.currentContext?.findRenderObject()
                          as RenderBox?;
                  albumHeaderSize = momentHeaderRenderBox!.size.height;
                });
              }
              if (_isStickyHeaderAtTop && !_isTimelineLoading) {
                if (state.content == "timeline" &&
                    albumHeaderSize + 5 <
                        _scrollController.position.maxScrollExtent) {
                  if (state.timelinePosition < albumHeaderSize) {
                    _scrollController.jumpTo(albumHeaderSize + 5);
                  } else {
                    _scrollController.jumpTo(
                      state.timelinePosition - 1,
                    );
                  }
                } else if (state.content == "collection") {
                  if (state.collectionsPosition < albumHeaderSize) {
                    _scrollController.jumpTo(albumHeaderSize + 5);
                  } else {
                    _scrollController.jumpTo(state.collectionsPosition);
                  }
                }
              }
              if (state.content == "timeline") {
                _isTimelineLoading = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  state.animationEnabled = false;
                });
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (_scrollController.position.pixels >=
                      albumHeaderSize + 5) {
                    _isStickyHeaderAtTop = true;
                  } else {
                    _isStickyHeaderAtTop = false;
                  }

                  if (state.content == "timeline" &&
                      state.timelineHasMoreData &&
                      _isTimelineLoading == false &&
                      scrollInfo.metrics.pixels >
                          scrollInfo.metrics.maxScrollExtent - 65) {
                    _isTimelineLoading = true;
                    context.read<AlbumBloc>().add(
                        AlbumTimelineNewChunkFetched(albumId: widget.albumId));
                  }
                  return true;
                },
                child: ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    AlbumHeaderCard(
                        key: albumHeaderKey, albumInfo: state.albumInfo),
                    StickyHeader(
                      header: Container(
                        height: _stickyHeaderSize,
                        color: Colors.black,
                        child: AlbumSubmenu(
                          currentPage: state.content,
                          scrollController: _scrollController,
                        ),
                      ),
                      content: state.content == "timeline"
                          ? TimelineContentGrid(
                              hasMoreData: state.timelineHasMoreData,
                              animationEnabled: state.animationEnabled,
                              photosByDate: state.photosByDate,
                              albumId: state.albumInfo.albumId,
                            )
                          : state.content == "collection"
                              ? CollectionContent(
                                  collections: state.collections)
                              : const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.blue,
                                  )),
                                ),
                    ),

                    // sized box to fix the sticky header position bug at
                    // full scroll after clamping physics
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              );
            }

            return const Text(
              "shit",
              style: TextStyle(color: Colors.white),
            );
          },
        ));
  }
}
