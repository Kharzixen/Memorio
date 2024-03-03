import 'package:flutter/material.dart';
import 'package:frontend/model/album_model.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumHeaderCard extends StatelessWidget {
  final AlbumHeaderInfo albumInfo;
  const AlbumHeaderCard({Key? key, required this.albumInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(albumInfo.albumPicture)),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              Text(
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                albumInfo.name,
                style: GoogleFonts.alegreya(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Align(
            alignment: Alignment.centerLeft,
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
              style: GoogleFonts.alegreya(
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
                          foregroundImage:
                              NetworkImage(albumInfo.contributors[index]),
                        );
                      }
                      return Positioned(
                        left: index * 28,
                        child: CircleAvatar(
                          foregroundImage:
                              NetworkImage(albumInfo.contributors[index]),
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
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.bold),
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
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Edit Album",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )),
              Spacer(),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person_add_alt_1,
                      color: Colors.black,
                    )),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.black,
                    )),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: Divider(
            height: 2,
          ),
        ),
      ],
    );
  }
}
