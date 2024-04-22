import 'package:flutter/material.dart';
import 'package:frontend/model/like_model.dart';
import 'package:google_fonts/google_fonts.dart';

class LikeList extends StatelessWidget {
  final List<LikeModel> likes;
  const LikeList({Key? key, required this.likes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Container(
        width: double.infinity,
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 10, 25),
              child: Text("Likes:",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alegreya(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                likes.length,
                (index) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: NetworkImage(likes[index].userpfp),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        likes[index].username,
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
