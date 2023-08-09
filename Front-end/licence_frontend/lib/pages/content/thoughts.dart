import 'package:flutter/material.dart';
import 'package:licence_frontend/components/page%20components/thoughtCard.dart';

import '../../models/database.dart';

class ThoughtsPage extends StatefulWidget {
  const ThoughtsPage({super.key});

  @override
  State<ThoughtsPage> createState() => _ThoughtsPage();
}

class _ThoughtsPage extends State<ThoughtsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.fromLTRB(5, 18, 0, 0),
        child: Container(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Tiny Thoughts",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: Data()
                    .thoughts
                    .asMap()
                    .entries
                    .map((e) => ThoughtCard(
                          thoughtID: e.key,
                        ))
                    .toList(),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
