import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:licence_frontend/models/database.dart';

import '../../models/post.dart';

class PostCard extends StatefulWidget {
  final int index;
  const PostCard({Key? key, required this.index}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool liked = false;
  int likeCount = 0;
  Data data = Data();

  @override
  void initState() {
    super.initState();
    likeCount = data.posts[widget.index].likeCount;
    liked = false;
  }

  @override
  Widget build(BuildContext context) {
    Post post = data.posts[widget.index];
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(15)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    context.push("/users/${data.users.indexOf(post.user)}");
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: post.user.pfp, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        post.user.username.length > 10
                            ? '${post.user.username.substring(0, 10)}..'
                            : post.user.username,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.navigate_next,
                      size: 30,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          Container(
            height: 520,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              image: DecorationImage(
                image: data.posts[widget.index].img,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
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
                  size: 30,
                ),
              ),
              Text(
                "${likeCount} Likes",
                style: const TextStyle(color: Colors.white),
              ),
              Expanded(
                  child: SizedBox(
                height: 1,
              )),
              Text(
                "${data.posts[widget.index].date}",
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 0, 5),
              child: Text(
                data.posts[widget.index].user.username,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data.posts[widget.index].caption,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ]));
  }
}
