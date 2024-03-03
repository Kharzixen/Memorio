import 'package:flutter/material.dart';
import 'package:frontend/model/user_model.dart';

class ProfileHeader extends StatefulWidget {
  final User user;
  const ProfileHeader({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
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
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.user.pfpLink)),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            //Posts, Likes,Followers
            const Column(
              children: [
                Text(
                  "0",
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
                  widget.user.followingCount.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
                const Text(
                  "Following",
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
                  widget.user.followersCount.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const Text(
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
            padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
            child: Text(
              widget.user.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.user.bio,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
          child: Row(
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.grey.shade500),
                  onPressed: () {},
                  child: const Text(
                    "Edit profile",
                    style: TextStyle(color: Colors.black),
                  )),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.grey.shade500),
                  onPressed: () {},
                  child: const Text(
                    "Share profile",
                    style: TextStyle(color: Colors.black),
                  )),
              Expanded(
                  child: Container(
                height: 1,
              )),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade500),
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
                    color: Colors.grey.shade500),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.black,
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}
