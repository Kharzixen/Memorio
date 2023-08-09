import 'package:flutter/material.dart';
import 'package:licence_frontend/components/page%20components/PlacePage/locationBioCard.dart';
import 'package:licence_frontend/components/page%20components/PlacePage/locationCard.dart';
import 'package:licence_frontend/models/database.dart';
import 'package:licence_frontend/models/location.dart';

import '../../components/page components/ProfilePage/nonUserProfileButtonRow.dart';

class LocationPage extends StatefulWidget {
  final String id;
  const LocationPage({Key? key, required this.id}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  int active = 1;
  @override
  Widget build(BuildContext context) {
    Data data = Data();

    //ezd id-ra atrakni
    NightlifeLocation location = data.festivalProfile;

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
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          PlaceCard(location: location),
          Align(
              alignment: Alignment.centerLeft,
              child: LocationBioCard(location: location)),
          Divider(),
          NonUserProfileButtonRow(),
          const Divider(
            height: 5,
          ),
          Container(
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 3,
                              color: active == 1
                                  ? Colors.blueAccent
                                  : Colors.grey.shade400))),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      setState(() {
                        active = 1;
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Posts',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 3,
                              color: active == 2
                                  ? Colors.blueAccent
                                  : Colors.grey.shade400))),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      setState(() {
                        active = 2;
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Map',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 3,
                              color: active == 3
                                  ? Colors.blueAccent
                                  : Colors.grey.shade400))),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      setState(() {
                        active = 3;
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 3,
                              color: active == 4
                                  ? Colors.blueAccent
                                  : Colors.grey.shade400))),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      setState(() {
                        active = 4;
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Announcements',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 3,
                              color: active == 5
                                  ? Colors.blueAccent
                                  : Colors.grey.shade400))),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      setState(() {
                        active = 5;
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Line Up',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
