import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_bloc/album_bloc.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/ui/widgets/bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumInfoPage extends StatefulWidget {
  final String albumId;
  const AlbumInfoPage({Key? key, required this.albumId}) : super(key: key);

  @override
  State<AlbumInfoPage> createState() => _AlbumInfoPageState();
}

class _AlbumInfoPageState extends State<AlbumInfoPage> {
  @override
  void initState() {
    super.initState();
    context.read<AlbumBloc>().add(AlbumFetched(albumId: widget.albumId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white)),
        body: BlocBuilder<AlbumBloc, AlbumState>(
          builder: (context, state) {
            if (state is AlbumLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is AlbumLoadedState) {
              return NestedScrollView(
                body: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowIndicator();
                        return false;
                      },
                      child: CustomScrollView(
                        physics: ClampingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(minHeight: 60),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      border: Border.all(
                                          color: Colors.grey.shade800),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 25, 0, 15),
                                          child: Text(
                                            "Description:",
                                            style: GoogleFonts.lato(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 5, 0, 15),
                                          child: Text(
                                            state.albumInfo.albumDescription,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 20),
                              child: Text(
                                "Contributors:",
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: NotificationListener<
                                OverscrollIndicatorNotification>(
                              onNotification: (overscroll) {
                                overscroll.disallowIndicator();
                                return false;
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: (state.albumInfo.contributors.length)
                                        .toInt() +
                                    1,
                                itemBuilder: (context, index) {
                                  if (index ==
                                      state.albumInfo.contributors.length) {
                                    //return LinearProgressIndicator();
                                    return Container();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade600,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(state
                                                  .albumInfo
                                                  .contributors[index]
                                                  .pfpLink),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          state.albumInfo.contributors[index]
                                              .username,
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        state.albumInfo.albumPicture)),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              state.albumInfo
                                  .name, // Assuming albumInfo is accessible in this scope
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ]),
                    ),
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      backgroundColor: Colors.black,
                      automaticallyImplyLeading: false,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.person_add_alt_1_outlined,
                              size: 31,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container();
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.add_a_photo_outlined,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomBottomSheet(
                                    album: SimpleAlbum(
                                        albumId: state.albumInfo.albumId,
                                        albumName: state.albumInfo.name,
                                        albumPicture:
                                            state.albumInfo.albumPicture),
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.more_horiz,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ];
                },
              );
            }

            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}




/*Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                          child: Row(children: [
                            Text(
                              "Contributors:",
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Stack(
                                children: List.generate(
                                  state.albumInfo.contributors.length + 1,
                                  (index) {
                                    if (index <
                                        state.albumInfo.contributors.length) {
                                      if (index == 0) {
                                        return CircleAvatar(
                                          foregroundImage: NetworkImage(state
                                              .albumInfo
                                              .contributors[index]
                                              .pfpLink),
                                        );
                                      }
                                      return Positioned(
                                        left: index * 28,
                                        child: CircleAvatar(
                                          foregroundImage: NetworkImage(state
                                              .albumInfo
                                              .contributors[index]
                                              .pfpLink),
                                        ),
                                      );
                                    } else {
                                      if (state.albumInfo.nrOfContributors -
                                              state.albumInfo.contributors
                                                  .length >
                                          0) {
                                        return Positioned(
                                          left: index * 28,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.white),
                                            child: Center(
                                                child: Text(
                                              '+${state.albumInfo.nrOfContributors - state.albumInfo.contributors.length}',
                                              style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.white),
                                  onPressed: () {},
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Edit Album",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  )),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          state.albumInfo.name,
                          style: GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          state.albumInfo.name,
                          style: GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          state.albumInfo.name,
                          style: GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          state.albumInfo.name,
                          style: GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          state.albumInfo.name,
                          style: GoogleFonts.lato(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ), */
