import 'package:flutter/material.dart';
import 'package:licence_frontend/models/location.dart';

class LocationBioCard extends StatelessWidget {
  final NightlifeLocation location;
  const LocationBioCard({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Container(
          child: Text(
        location.bio,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      )),
    );
  }
}
