import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        centerTitle: true,
        title: const Text(
          "Valami Név",
          style: TextStyle(
            color: Color.fromARGB(255, 216, 162, 0),
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
