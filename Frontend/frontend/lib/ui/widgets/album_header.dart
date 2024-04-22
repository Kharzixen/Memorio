import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/model/album_model.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumHeaderCard extends StatelessWidget {
  final AlbumInfo albumInfo;
  const AlbumHeaderCard({Key? key, required this.albumInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 60),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          border: Border.all(
                            color: Colors.grey.shade800,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 25, 0, 15),
                              child: Text(
                                "Description:",
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 0, 15),
                              child: Text(
                                albumInfo.albumDescription,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
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
                        albumInfo.contributors.length + 1,
                        (index) {
                          if (index < albumInfo.contributors.length) {
                            if (index == 0) {
                              return CircleAvatar(
                                foregroundImage: NetworkImage(
                                    albumInfo.contributors[index].pfpLink),
                              );
                            }
                            return Positioned(
                              left: index * 28,
                              child: CircleAvatar(
                                foregroundImage: NetworkImage(
                                    albumInfo.contributors[index].pfpLink),
                              ),
                            );
                          } else {
                            if (albumInfo.nrOfContributors -
                                    albumInfo.contributors.length >
                                0) {
                              return Positioned(
                                left: index * 28,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.white),
                                  child: Center(
                                      child: Text(
                                    '+${albumInfo.nrOfContributors - albumInfo.contributors.length}',
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
                                borderRadius: BorderRadius.circular(10)),
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
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                          image: NetworkImage(albumInfo.albumPicture)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    albumInfo
                        .name, // Assuming albumInfo is accessible in this scope
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
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
        ];
      },
    );
  }
}

class AlbumCardDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  AlbumCardDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 200.0; // Adjust as needed

  @override
  double get minExtent => 80.0; // Adjust as needed

  @override
  bool shouldRebuild(covariant AlbumCardDelegate oldDelegate) {
    return false;
  }
}
