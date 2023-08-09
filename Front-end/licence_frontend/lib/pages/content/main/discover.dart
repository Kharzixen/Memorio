import 'package:flutter/material.dart';
import 'package:licence_frontend/components/page%20components/followCard.dart';
import 'package:licence_frontend/models/database.dart';

import '../../../components/scaffold components/drawer.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Data data = Data();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: MyDrawer(),
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
      body: Container(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 25,
            ),
            TextField(
              onTapOutside: (PointerDownEvent e) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  label: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text("Search")
                    ],
                  ),
                  labelStyle: TextStyle(color: Colors.white)),
              onChanged: (val) {},
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'People you might want to follow',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person_add_alt_outlined,
                      color: Colors.white,
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 240,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return FollowCard(index: index);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 25,
                  );
                },
                itemCount: data.users.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ]),
        ),
      ),
    );
  }
}
