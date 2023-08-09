import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:licence_frontend/components/scaffold%20components/drawer.dart';

import '../../../models/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Data data = Data();
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send_rounded),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Hello ${data.profile.username}!",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                const SizedBox(
                  height: 40,
                ),

                //Thoughts
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    backgroundColor: Colors.grey.shade800,
                  ),
                  onPressed: () {
                    context.push("/home/announcements");
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Announcements',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.navigate_next,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 240,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        width: 210,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 8, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            context.push("/locations/${0}");
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade600,
                                                    image: DecorationImage(
                                                        image: data
                                                            .announcements[
                                                                index]
                                                            .location
                                                            .pfp,
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                data
                                                            .announcements[
                                                                index]
                                                            .location
                                                            .name
                                                            .length >
                                                        10
                                                    ? '${data.announcements[index].location.name.substring(0, 10)}..'
                                                    : data.announcements[index]
                                                        .location.name,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
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
                              Text(
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                data.announcements[index].text,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        "${data.announcements[index].likeCount} Likes",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "2023.07.26",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 25,
                      );
                    },
                    itemCount: data.announcements.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                //Stories
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    backgroundColor: Colors.grey.shade800,
                  ),
                  onPressed: () {
                    context.push("/home/stories");
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Stories',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.navigate_next,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 240,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                          width: 210,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 2,
                                color: Colors.grey.shade800,
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: data.posts[index].img)));
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 25,
                      );
                    },
                    itemCount: data.posts.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                //Thoughts
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    backgroundColor: Colors.grey.shade800,
                  ),
                  onPressed: () {
                    context.push("/home/thoughts");
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tiny Thoughts',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.navigate_next,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 240,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
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
                          padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 8, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        context.push(
                                            "/users/${data.users.indexOf(data.thoughts[index].user)}");
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade600,
                                                image: DecorationImage(
                                                    image: data.thoughts[index]
                                                        .user.pfp,
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            data.thoughts[index].user.username
                                                        .length >
                                                    10
                                                ? '${data.thoughts[index].user.username.substring(0, 10)}..'
                                                : data.thoughts[index].user
                                                    .username,
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
                              Text(
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                data.thoughts[index].text,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        "${data.thoughts[index].likeCount} Likes",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "2023.07.26",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 25,
                      );
                    },
                    itemCount: data.thoughts.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
