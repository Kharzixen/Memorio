import 'package:flutter/material.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 35,
          ),
          Text(
            "Capture the moment, preserve the memories",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Create your first post.",
                style: TextStyle(
                    color: Color.fromRGBO(24, 119, 242, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ))
        ],
      ),
    );
  }
}
