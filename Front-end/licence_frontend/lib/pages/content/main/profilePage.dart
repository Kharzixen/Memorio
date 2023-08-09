import 'package:flutter/material.dart';
import 'package:licence_frontend/components/scaffold%20components/drawer.dart';
import 'package:licence_frontend/models/database.dart';

import '../../../components/page components/ProfilePage/bioCard.dart';
import '../../../components/page components/ProfilePage/profileCard.dart';
import '../../../components/page components/ProfilePage/userProfileButtonRow.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Data data = Data();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ProfileCard(
              userID: -1,
            ),
            BioCard(
              userID: -1,
            ),
            Divider(),
            UserProfileButtonRow(),
            const Divider(
              height: 25,
              color: Colors.white,
            ),
            //Photo Grid
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 2, color: Colors.grey.shade800),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: data.posts[index].img)));
                  }),
            )
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
