import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/discover_public_albums_cubit/discover_public_albums_cubit.dart';
import 'package:frontend/data/repository/public_album_repository.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/discover_album_preview_card_widget.dart';
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
        length: 2,
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
                  create: (context) => DiscoverPublicAlbumPreviewsCubit(
                    context.read<PublicAlbumRepository>(),
                  )..loadAlbumPreview(StorageService().userId),
                  child: Builder(
                    builder: (context) {
                      return BlocBuilder<DiscoverPublicAlbumPreviewsCubit,
                          DiscoverPublicAlbumPreviewsState>(
                        builder: (context, state) {
                          if (state is DiscoverPublicAlbumPreviewsLoadedState) {
                            return RefreshIndicator.adaptive(
                              onRefresh: () async {
                                var cubit = context
                                    .read<DiscoverPublicAlbumPreviewsCubit>()
                                    .stream
                                    .first;
                                context
                                    .read<DiscoverPublicAlbumPreviewsCubit>()
                                    .refresh();
                                await cubit;
                              },
                              child: ListView.builder(
                                itemCount: state.publicAlbums.length,
                                itemBuilder: (context, index) {
                                  return DiscoverPublicALbumPreviewCard(
                                      albumPreview: state.publicAlbums[index]);
                                },
                              ),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
