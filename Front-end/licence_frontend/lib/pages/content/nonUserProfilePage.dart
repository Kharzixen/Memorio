import 'package:flutter/material.dart';
import 'package:licence_frontend/components/page%20components/ProfilePage/nonUserProfileButtonRow.dart';

import '../../components/page components/ProfilePage/bioCard.dart';
import '../../components/page components/ProfilePage/profileCard.dart';
import '../../models/database.dart';
import '../../models/post.dart';

class NonUserProfilePage extends StatelessWidget {
  final String id;
  const NonUserProfilePage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data data = Data();
    List<Post> userPosts = data.posts
        .where((element) => element.user == data.users[int.parse(id)])
        .toList();
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
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ProfileCard(
              userID: int.parse(id),
            ),
            BioCard(userID: int.parse(id)),
            Divider(),
            NonUserProfileButtonRow(),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: userPosts.length,
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
                                image: userPosts[index].img)));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
