import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/moment_bloc/moment_bloc.dart';
import 'package:frontend/ui/widgets/comment_list.dart';
import 'package:frontend/ui/widgets/like_list.dart';
import 'package:frontend/ui/widgets/moment_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sticky_headers/sticky_headers.dart';

class MomentPage extends StatefulWidget {
  final String momentId;
  final String albumId;
  const MomentPage({Key? key, required this.momentId, required this.albumId})
      : super(key: key);

  @override
  State<MomentPage> createState() => _MomentPageState();
}

class _MomentPageState extends State<MomentPage> {
  bool isStickyHeaderAtTop = false;
  double _commentsPositionPixels = 0.0;
  double _likesPositionPixels = 0.0;
  GlobalKey momentHeaderKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();
  final double _stickyHeaderHeight = 60.0;

  double momentHeaderSize = 0.0;

  @override
  void initState() {
    super.initState();
    context
        .read<MomentBloc>()
        .add(MomentFetched(albumId: widget.albumId, momentId: widget.momentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
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
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (_scrollController.position.pixels >= momentHeaderSize + 5) {
            isStickyHeaderAtTop = true;
          } else {
            isStickyHeaderAtTop = false;
          }
          return true;
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: BlocBuilder<MomentBloc, MomentState>(
            builder: (context, state) {
              //circular progress indicator
              if (state is MomentLoadingState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 2 / 3,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                );
              }

              if (state is MomentLoadedState) {
                if (momentHeaderSize == 0.0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    RenderBox? momentHeaderRenderBox =
                        momentHeaderKey.currentContext?.findRenderObject()
                            as RenderBox?;
                    momentHeaderSize = momentHeaderRenderBox!.size.height;
                  });
                }
                if (isStickyHeaderAtTop) {
                  if (state.contentToShow == "comments") {
                    if (_commentsPositionPixels < momentHeaderSize) {
                      _scrollController.jumpTo(momentHeaderSize + 5);
                    } else {
                      _scrollController.jumpTo(
                        _commentsPositionPixels - 1,
                      );
                    }
                  } else if (state.contentToShow == "likes") {
                    if (_likesPositionPixels < momentHeaderSize) {
                      _scrollController.jumpTo(momentHeaderSize + 5);
                    } else {
                      _scrollController.jumpTo(_likesPositionPixels);
                    }
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Column(
                        key: momentHeaderKey,
                        children: [
                          Container(
                            color: Colors.white.withOpacity(0.08),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Image.network(
                                //"https://i.ibb.co/b55D6nS/20230604-223149.jpg",
                                //"https://www.apogeephoto.com/wp-content/uploads/2017/04/portait6.jpg",
                                //"https://i.ibb.co/m4TzF9x/20230604-223149.jpg",
                                state.moment.photo,
                                fit: BoxFit.contain,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      RenderBox? momentHeaderRenderBox =
                                          momentHeaderKey.currentContext
                                                  ?.findRenderObject()
                                              as RenderBox?;
                                      momentHeaderSize =
                                          momentHeaderRenderBox!.size.height;
                                    });
                                    return child;
                                  }
                                  return Container(
                                    color: Colors.grey,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          MomentHeader(
                            moment: state.moment,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    StickyHeader(
                        header: Container(
                          color: Colors.black,
                          height: _stickyHeaderHeight,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: state.contentToShow == "comments"
                                            ? const Color.fromRGBO(
                                                24, 119, 242, 1)
                                            : Colors.white,
                                        width: 1,
                                      ))),
                                      height: 35,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return Colors.transparent;
                                            },
                                          ),
                                          splashFactory: NoSplash.splashFactory,
                                        ),
                                        onPressed: () {
                                          print("comment");
                                          _likesPositionPixels =
                                              _scrollController.position.pixels;
                                          context
                                              .read<MomentBloc>()
                                              .add(ContentChangedToComments());
                                        },
                                        child: Text(
                                          "Comments",
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: state.contentToShow ==
                                                    "comments"
                                                ? const Color.fromRGBO(
                                                    24, 119, 242, 1)
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: state.contentToShow == "likes"
                                            ? const Color.fromRGBO(
                                                24, 119, 242, 1)
                                            : Colors.white,
                                        width: 1,
                                      ))),
                                      height: 35,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return Colors.transparent;
                                            },
                                          ),
                                          splashFactory: NoSplash.splashFactory,
                                        ),
                                        onPressed: () {
                                          _commentsPositionPixels =
                                              _scrollController.position.pixels;
                                          print("likes");
                                          context
                                              .read<MomentBloc>()
                                              .add(ContentChangedToLikes());
                                        },
                                        child: Text(
                                          "Likes",
                                          style: GoogleFonts.lato(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                state.contentToShow == "likes"
                                                    ? const Color.fromRGBO(
                                                        24, 119, 242, 1)
                                                    : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        content: state.contentToShow == "comments"
                            ? CommentList(comments: state.moment.comments)
                            : LikeList(likes: state.moment.likes)),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              }

              return const Text(
                "An unexpected error occurred",
                style: TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
