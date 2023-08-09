import 'package:licence_frontend/models/location.dart';

class Announcement {
  String text;
  NightlifeLocation location;
  int likeCount;
  String date;

  Announcement(
      {required this.text,
      required this.location,
      required this.likeCount,
      required this.date});
}
