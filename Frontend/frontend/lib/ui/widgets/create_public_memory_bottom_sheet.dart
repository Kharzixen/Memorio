import 'package:flutter/material.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/memory_creation_details.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CreatePublicMemoryBottomSheet extends StatefulWidget {
  final SimplePublicAlbum album;
  const CreatePublicMemoryBottomSheet({Key? key, required this.album})
      : super(key: key);

  @override
  State<CreatePublicMemoryBottomSheet> createState() =>
      _CreatePublicMemoryBottomSheetState();
}

class _CreatePublicMemoryBottomSheetState
    extends State<CreatePublicMemoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.grey.shade900),
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Capture the moment',
              style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                    maximumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white),
                onPressed: () async {
                  var response = await context.push("/create-public-memory",
                      extra: PublicMemoryCreationDetails(
                        source: ImageSource.camera,
                        album: widget.album,
                      ));
                  if (response != null) {
                    PopPayload<PublicMemory> payload =
                        response as PopPayload<PublicMemory>;
                    if (context.mounted) {
                      context.pop(payload);
                    }
                  }
                },
                child: const SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 20,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Take a photo",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    "or",
                    style: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                    maximumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white),
                onPressed: () async {
                  var response = await context.push("/create-public-memory",
                      extra: PublicMemoryCreationDetails(
                        source: ImageSource.gallery,
                        album: widget.album,
                      ));
                  if (response != null) {
                    PopPayload<PublicMemory> payload =
                        response as PopPayload<PublicMemory>;
                    if (context.mounted) {
                      context.pop(payload);
                    }
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 24,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Choose from Gallery",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
