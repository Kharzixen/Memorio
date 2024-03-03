import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_preview_bloc/albums_preview_bloc.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/album_preview.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumsPreviewPage extends StatefulWidget {
  const AlbumsPreviewPage({super.key});

  @override
  State<AlbumsPreviewPage> createState() => _AlbumsPreviewPageState();
}

class _AlbumsPreviewPageState extends State<AlbumsPreviewPage> {
  int imageWidth = 0;
  int imageHeight = 0;
  late Image image;
  @override
  void initState() {
    super.initState();
    String userId = context.read<StorageService>().userId;
    context.read<AlbumsPreviewBloc>().add(AlbumsPreviewFetched(userId: userId));

    // image = Image.network(
    //     "https://image.everypixel.com/blockchain/52/83/5283c626-63a3-43ff-82fa-2d5d3987e6c0.jpg");

    // image.image.resolve(ImageConfiguration()).addListener(
    //   ImageStreamListener(
    //     (info, synchronousCall) {
    //       int imageWidth = info.image.width;
    //       int imageHeight = info.image.height;

    //       // Do something with the image width and height
    //       this.imageHeight = imageHeight;
    //       this.imageWidth = imageWidth;
    //     },
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Albums",
          style: GoogleFonts.alegreya(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.send_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocBuilder<AlbumsPreviewBloc, AlbumsPreviewState>(
        builder: (context, state) {
          if (state is AlbumsPreviewLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          if (state is AlbumsPreviewLoadedState) {
            return Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                child: ListView.separated(
                    itemCount: state.albums.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 25,
                      );
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context
                              .push("/albums/${state.albums[index].albumId}");
                        },
                        child: AlbumPreviewCard(
                          albumPreview: state.albums[index],
                        ),
                      );
                    }));
          }
          return Text("elbaszva");
        },
      ),
    );
  }
}
