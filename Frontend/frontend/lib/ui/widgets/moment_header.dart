import 'package:flutter/material.dart';
import 'package:frontend/model/album_model.dart';
import 'package:google_fonts/google_fonts.dart';

class MomentHeader extends StatelessWidget {
  final DetailedMoment moment;
  const MomentHeader({Key? key, required this.moment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                print("like");
              },
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconSize: 28.0, // desired size
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.favorite_outline,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                print("comment");
              },
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconSize: 25.0, // desired size
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconSize: 25.0, // desired size
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          '${moment.likeCount} likes',
          style: GoogleFonts.lato(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(
                  "https://images.pexels.com/photos/3657140/pexels-photo-3657140.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              moment.username,
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          moment.caption,
          style: GoogleFonts.lato(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  getDate(moment.date),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Text(
                  getHour(moment.date),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Sisters Coffee",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "Cluj-Napoca, Romania",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }

  String getDate(DateTime date) {
    String month = date.month < 10 ? '0${date.month}' : '${date.month}';
    String day = date.day < 10 ? '0${date.day}' : '${date.day}';

    return '${date.year}-$month-$day';
  }

  String getHour(DateTime date) {
    String hour = date.hour < 10 ? '0${date.hour}' : '${date.hour}';
    String minute = date.minute < 10 ? '0${date.minute}' : '${date.minute}';
    String second = date.second < 10 ? '0${date.second}' : '${date.second}';
    return '$hour:$minute:$second';
  }
}
