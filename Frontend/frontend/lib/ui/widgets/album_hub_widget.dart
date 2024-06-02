import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/public_album_previews_cubit/public_album_previews_cubit.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumHub extends StatefulWidget {
  const AlbumHub({super.key});

  @override
  State<AlbumHub> createState() => _AlbumHubState();
}

class _AlbumHubState extends State<AlbumHub> {
  @override
  void initState() {
    context
        .read<PublicAlbumPreviewsCubit>()
        .loadAlbumPreview(StorageService().userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicAlbumPreviewsCubit, PublicAlbumPreviewsState>(
      builder: (context, state) {
        if (state is PublicAlbumPreviewsLoadedState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Public Albums: ",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Loaded Albums: ",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        if (state is PublicAlbumPreviewsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return const Center(
          child: Text(
            "Something went wrong",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
