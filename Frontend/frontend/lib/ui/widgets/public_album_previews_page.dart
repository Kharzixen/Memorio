import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/public_album_previews_cubit/public_album_previews_cubit.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/public_album_preview.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PublicAlbumPreviewsPage extends StatefulWidget {
  const PublicAlbumPreviewsPage({super.key});

  @override
  State<PublicAlbumPreviewsPage> createState() =>
      _PublicAlbumPreviewsPageState();
}

class _PublicAlbumPreviewsPageState extends State<PublicAlbumPreviewsPage> {
  @override
  void initState() {
    super.initState();
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
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                var cubit =
                    context.read<PublicAlbumPreviewsCubit>().stream.first;
                context.read<PublicAlbumPreviewsCubit>().refresh();
                await cubit;
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.publicAlbums.length + 1,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 25,
                      );
                    },
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Row(
                          children: [
                            Text(
                              "Your Public Albums:",
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  context.push("/createPublicAlbum");
                                },
                                icon: const Icon(
                                  Icons.add_box_outlined,
                                  color: Colors.white,
                                )),
                          ],
                        );
                      }
                      return PublicAlbumPreviewCard(
                          albumPreview: state.publicAlbums[index - 1]);
                    },
                  ),
                ],
              ),
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
