import 'package:flutter/material.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/memory_creation_details.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CreateDisposableCameraMemoryBottomSheet extends StatelessWidget {
  final SimplePrivateAlbum simpleAlbum;
  const CreateDisposableCameraMemoryBottomSheet(
      {super.key, required this.simpleAlbum});

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
              'Capture the moment with',
              style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Disposable Camera',
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
                  var response = await context.push(
                      "/albums/${simpleAlbum.albumId}/createDisposableCameraMemory",
                      extra: MemoryCreationDetails(
                          source: ImageSource.camera, album: simpleAlbum));
                  if (response != null) {
                    PopPayload<PrivateMemory> payload =
                        response as PopPayload<PrivateMemory>;
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
                  var response = await context.push(
                      "/albums/${simpleAlbum.albumId}/createDisposableCameraMemory",
                      extra: MemoryCreationDetails(
                          source: ImageSource.gallery, album: simpleAlbum));
                  if (response != null) {
                    PopPayload<PrivateMemory> payload =
                        response as PopPayload<PrivateMemory>;
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
