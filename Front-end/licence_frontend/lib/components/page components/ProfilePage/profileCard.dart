import 'package:flutter/material.dart';
import 'package:licence_frontend/models/database.dart';

import '../../../models/user.dart';

class ProfileCard extends StatelessWidget {
  final int userID;
  const ProfileCard({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data data = Data();
    User user = userID == -1 ? data.profile : data.users[userID];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //pfp
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                image: DecorationImage(fit: BoxFit.cover, image: user.pfp),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            //Posts, Likes,Followers
            Column(
              children: [
                Text(
                  user.postsCount.toString(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Posts",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  user.allLikesCount.toString(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Likes",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  user.followersCount.toString(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Followers",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10, 20, 0),
            child: Text(
              user.username,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
