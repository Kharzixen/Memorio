import 'package:flutter/material.dart';

class NonUserProfileButtonRow extends StatefulWidget {
  const NonUserProfileButtonRow({super.key});

  @override
  State<NonUserProfileButtonRow> createState() =>
      _NonUserProfileButtonRowState();
}

class _NonUserProfileButtonRowState extends State<NonUserProfileButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(100, 30),
                  backgroundColor: Colors.grey.shade800),
              onPressed: () {},
              child: Text("Follow")),
          const SizedBox(
            width: 5,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(100, 30),
                  backgroundColor: Colors.grey.shade800),
              onPressed: () {},
              child: const Text("Message")),
          Expanded(
              child: Container(
            height: 1,
          )),
          ElevatedButton(
              onPressed: () {},
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
