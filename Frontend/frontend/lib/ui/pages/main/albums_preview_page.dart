import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_preview_bloc/private_albums_preview_bloc.dart';
import 'package:frontend/cubit/public_album_previews_cubit/public_album_previews_cubit.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/ui/pages/main/private_albums_page.dart';
import 'package:frontend/ui/widgets/public_album_previews_page.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumPreviewsPage extends StatefulWidget {
  const AlbumPreviewsPage({super.key});

  @override
  State<AlbumPreviewsPage> createState() => _AlbumPreviewsPageState();
}

class _AlbumPreviewsPageState extends State<AlbumPreviewsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "Albums",
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 23,
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
            bottom: const TabBar(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              dividerColor: Colors.white,
              dividerHeight: 2,
              indicatorColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              labelColor: Colors.blue,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  text: "Private Albums",
                ),
                Tab(
                  text: "Public Albums",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BlocProvider(
                  create: (context) => PrivateAlbumsPreviewBloc(
                      context.read<PrivateAlbumRepository>()),
                  child: const PrivateAlbumsPreviewPage()),
              BlocProvider(
                  create: (context) => PublicAlbumPreviewsCubit(
                      context.read<PublicAlbumRepository>()),
                  child: PublicAlbumPreviewsPage()),
            ],
          )),
    );
  }
}
