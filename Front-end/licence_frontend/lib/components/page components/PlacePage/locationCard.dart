import 'package:flutter/material.dart';
import 'package:licence_frontend/models/location.dart';

class PlaceCard extends StatelessWidget {
  final NightlifeLocation location;
  const PlaceCard({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                image: DecorationImage(fit: BoxFit.cover, image: location.pfp),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            //Posts, Likes,Followers
            Column(
              children: [
                Text(
                  location.postsCount.toString(),
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
                  location.allLikesCount.toString(),
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
                  location.followersCount.toString(),
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
              location.name,
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
