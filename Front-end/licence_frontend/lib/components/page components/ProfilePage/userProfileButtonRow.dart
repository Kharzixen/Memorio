import 'package:flutter/material.dart';

class UserProfileButtonRow extends StatefulWidget {
  const UserProfileButtonRow({super.key});

  @override
  State<UserProfileButtonRow> createState() => _UserProfileButtonRowState();
}

class _UserProfileButtonRowState extends State<UserProfileButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800),
              onPressed: () {},
              child: Text("Edit profile")),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800),
              onPressed: () {},
              child: Text("Share profile")),
          Expanded(
              child: Container(
            height: 1,
          )),
          ElevatedButton(
              onPressed: () {},
              child: Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
              )),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
              onPressed: () {},
              child: Icon(
                Icons.add_a_photo_outlined,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
