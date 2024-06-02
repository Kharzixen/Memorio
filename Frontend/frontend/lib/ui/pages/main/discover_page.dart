import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/public_album_previews_cubit/public_album_previews_cubit.dart';
import 'package:frontend/cubit/public_album_previews_cubit/public_album_previews_cubit.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/ui/widgets/album_hub_widget.dart';
import 'package:frontend/ui/widgets/follow_suggestions_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                "Discover",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.black,
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
                    text: "People",
                  ),
                  Tab(
                    text: "Album Hub",
                  ),
                  Tab(
                    text: "Notes",
                  )
                ],
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
            body: TabBarView(
              children: [
                const FollowingSuggestionWidget(),
                //second tab
                BlocProvider(
                    create: (context) => PublicAlbumPreviewsCubit(
                        context.read<PublicAlbumRepository>()),
                    child: AlbumHub()),
                Container(
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ));
  }
}
