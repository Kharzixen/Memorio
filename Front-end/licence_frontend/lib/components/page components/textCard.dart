import 'package:flutter/material.dart';

import '../../models/announcement.dart';

class TextCard extends StatefulWidget {
  final Announcement announcement;

  const TextCard({Key? key, required this.announcement}) : super(key: key);

  @override
  State<TextCard> createState() => _TextCard();
}

class _TextCard extends State<TextCard> {
  int likeCount = 0;
  bool liked = false;
  @override
  void initState() {
    super.initState();
    likeCount = widget.announcement.likeCount;
    liked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
          constraints: BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(15)),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            image: DecorationImage(
                                image: widget.announcement.location.pfp,
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.announcement.location.name.length > 10
                            ? '${widget.announcement.location.name.substring(0, 10)}..'
                            : widget.announcement.location.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                      iconSize: 20,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                widget.announcement.text,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        print("like");
                        if (liked) {
                          setState(() {
                            likeCount--;
                          });
                        } else {
                          setState(() {
                            likeCount++;
                          });
                        }
                        setState(() {
                          liked = !liked;
                        });
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: liked ? Colors.red : Colors.white,
                        size: 25,
                      ),
                    ),
                    Text(
                      "${likeCount} Likes",
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            )
          ])),
    );
  }
}
