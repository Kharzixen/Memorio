import 'package:flutter/material.dart';
import 'package:frontend/model/album_model.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentList extends StatelessWidget {
  final List<Comment> comments;
  const CommentList({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 10, 25),
              child: Text("Comments:",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alegreya(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
            ),
            Column(
              children: List.generate(
                comments.length,
                (index) => Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          foregroundImage:
                              NetworkImage(comments[index].userpfp),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          comments[index].username,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(
                        comments[index].text,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getDateTime(comments[index].date),
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDateTime(DateTime date) {
    String month = date.month < 10 ? '0${date.month}' : '${date.month}';
    String day = date.day < 10 ? '0${date.day}' : '${date.day}';
    String hour = date.hour < 10 ? '0${date.hour}' : '${date.hour}';
    String minute = date.minute < 10 ? '0${date.minute}' : '${date.minute}';
    String second = date.second < 10 ? '0${date.second}' : '${date.second}';
    return '${date.year}-$month-$day $hour:$minute:$second';
  }
}
