import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:licence_frontend/models/database.dart';
import 'package:licence_frontend/models/thought.dart';

class ThoughtCard extends StatefulWidget {
  final int thoughtID;

  const ThoughtCard({Key? key, required this.thoughtID}) : super(key: key);

  @override
  State<ThoughtCard> createState() => _ThoughtCard();
}

class _ThoughtCard extends State<ThoughtCard> {
  int likeCount = 0;
  bool liked = false;
  Data data = Data();
  late Thought thought = data.thoughts[widget.thoughtID];

  @override
  void initState() {
    super.initState();
    data = Data();
    thought = data.thoughts[widget.thoughtID];
    likeCount = thought.likeCount;
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
                  TextButton(
                    onPressed: () {
                      context
                          .push("/users/${data.users.indexOf(thought.user)}");
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                  image: thought.user.pfp, fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          thought.user.username.length > 10
                              ? '${thought.user.username.substring(0, 10)}..'
                              : thought.user.username,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
                thought.text,
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
