import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_preview_bloc/private_albums_preview_bloc.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/private_album_preview.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateAlbumsPreviewPage extends StatefulWidget {
  const PrivateAlbumsPreviewPage({super.key});

  @override
  State<PrivateAlbumsPreviewPage> createState() =>
      _PrivateAlbumsPreviewPageState();
}

class _PrivateAlbumsPreviewPageState extends State<PrivateAlbumsPreviewPage> {
  int imageWidth = 0;
  int imageHeight = 0;
  late Image image;
  @override
  void initState() {
    super.initState();
    String userId = context.read<StorageService>().userId;
    context
        .read<PrivateAlbumsPreviewBloc>()
        .add(PrivateAlbumsPreviewFetched(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Albums",
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.send_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocBuilder<PrivateAlbumsPreviewBloc, AlbumsPreviewState>(
        builder: (context, state) {
          if (state is AlbumsPreviewLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          if (state is AlbumsPreviewLoadedState) {
            return Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                    child: state.albums.isEmpty
                        ? RefreshIndicator.adaptive(
                            onRefresh: () async {
                              Future block = context
                                  .read<PrivateAlbumsPreviewBloc>()
                                  .stream
                                  .first;
                              context
                                  .read<PrivateAlbumsPreviewBloc>()
                                  .add(PrivateAlbumsRefreshRequested());
                              await block;
                            },
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                    height: 500,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "There are currently no albums to display.",
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.push("/createAlbum");
                                            },
                                            child: Text(
                                              "Create a new album",
                                              style: GoogleFonts.lato(
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(child: Divider()),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 5, 0),
                                                child: Text(
                                                  "or",
                                                  style: GoogleFonts.lato(
                                                      color: Colors.grey,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(child: Divider()),
                                            ],
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              "Join an existing one",
                                              style: GoogleFonts.lato(
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          )
                        : RefreshIndicator.adaptive(
                            onRefresh: () async {
                              Future block = context
                                  .read<PrivateAlbumsPreviewBloc>()
                                  .stream
                                  .first;
                              context
                                  .read<PrivateAlbumsPreviewBloc>()
                                  .add(PrivateAlbumsRefreshRequested());
                              await block;
                            },
                            child: ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: state.albums.length + 1,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 25,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Row(
                                      children: [
                                        Text(
                                          "Your albums:",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              context.push("/createAlbum");
                                            },
                                            icon: Icon(
                                              Icons.add_box_outlined,
                                              color: Colors.white,
                                            )),
                                      ],
                                    );
                                  }

                                  return AlbumPreviewCard(
                                    albumPreview: state.albums[index - 1],
                                  );
                                }),
                          )),
                state.isAsyncMethodInProgress
                    ? Container(
                        color: Colors.black.withOpacity(0.4),
                        child: const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                      )
                    : Container()
              ],
            );
          }
          if (state is AlbumsPreviewErrorState) {
            return Text(state.errorMessage);
          }
          return Text("Something went wrong");
        },
      ),
    );
  }
}
