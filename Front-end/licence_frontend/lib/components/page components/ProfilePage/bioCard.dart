import 'package:flutter/material.dart';

class BioCard extends StatelessWidget {
  final int userID;
  const BioCard({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userBio = this.userID == -1
        ? "2001.07.26\nshe/her\nBestFest a Legjobb fest <3\n@Mario ❤\nNem ti mi edzizunk vaaa micbe vagy ötvenes karok hatvanas farok nagy a szoveg"
        : "Nem profil bio";
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Align(
        child: Container(
            child: Text(
          userBio,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}
