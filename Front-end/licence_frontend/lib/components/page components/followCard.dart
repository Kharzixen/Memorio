import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/database.dart';
import '../../models/user.dart';

class FollowCard extends StatefulWidget {
  final int index;
  const FollowCard({Key? key, required this.index}) : super(key: key);

  @override
  State<FollowCard> createState() => _FollowCardState();
}

class _FollowCardState extends State<FollowCard> {
  bool isFollowed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Data data = Data();
    User user = data.users[widget.index];

    return Container(
        width: 210,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 2,
            color: Colors.grey.shade800,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    context.push("/users/${data.users.indexOf(user)}");
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: data.users[widget.index].pfp),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        data.users[widget.index].username.length > 10
                            ? '${data.users[widget.index].username.substring(0, 10)}..'
                            : data.users[widget.index].username,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFollowed ? Colors.grey.shade600 : Colors.blue,
                    fixedSize: const Size(150, 50),
                  ),
                  onPressed: () {
                    setState(() {
                      isFollowed = !isFollowed;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isFollowed ? "Following" : "Follow",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isFollowed ? Icons.check : Icons.add,
                        size: 24.0,
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
