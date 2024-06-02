import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/bloc/memory_creation_bloc/memory_creation_bloc.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/private-album_model.dart';

import 'package:frontend/model/utils/memory_creation_details.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/private_memory_creation_albums_collections.dart';
import 'package:frontend/ui/widgets/private_memory_creation_hashtags.dart';
import 'package:frontend/ui/widgets/private_memory_creation_image_description.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateMemoryPage extends StatefulWidget {
  final MemoryCreationDetails memoryCreationDetails;
  const CreateMemoryPage({Key? key, required this.memoryCreationDetails})
      : super(key: key);

  @override
  State<CreateMemoryPage> createState() => _CreateMemoryPageState();
}

class _CreateMemoryPageState extends State<CreateMemoryPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<String> hashtags = [
    "portrait",
    "party",
    "fun",
    "adventure",
    "hashtag1",
    "hashtag2"
  ];

  @override
  void initState() {
    super.initState();
    print("init state");
    tabController = TabController(vsync: this, length: 4);

    context.read<MemoryCreationBloc>().add(MemoryCreationStarted(
        memoryCreationDetails: widget.memoryCreationDetails));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MemoryCreationBloc, MemoryCreationState>(
        builder: (context, state) {
          if (state is MemoryCreationLoadedState) {
            return DefaultTabController(
              length: 4,
              child: CustomScrollView(slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.pop();
                    },
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.black,
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                      preferredSize: Size.fromHeight(10),
                      child: LinearProgressIndicator(
                        value: (state.page + 1).toDouble() /
                            (tabController.length).toDouble(),
                      )),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      PrivateMemoryCreationImageAndDescriptionWidget(
                        image: state.image,
                        tabController: tabController,
                      ),
                      PrivateMemoryCreationAlbumsAndCollectionsSelectionWidget(
                          albums: state.albums, tabController: tabController),
                      PrivateMemoryCreationHashtagsSelectionWidget(
                          tabController: tabController),
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Image.memory(
                              state.image,
                              fit: BoxFit.cover,
                              frameBuilder: ((context, child, frame,
                                  wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) return child;
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: frame != null
                                      ? child
                                      : const Center(
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 6),
                                          ),
                                        ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  foregroundImage: CachedNetworkImageProvider(
                                    StorageService().pfp,
                                    headers: HttpHeadersFactory
                                        .getDefaultRequestHeaderForImage(
                                            TokenManager().accessToken!),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  StorageService().username,
                                  style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              state.description,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    if (tabController.index > 0) {
                                      tabController
                                          .animateTo(tabController.index - 1);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.navigate_before,
                                          size: 23,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Back  ",
                                          style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    context
                                        .read<MemoryCreationBloc>()
                                        .add(MemoryCreationFinished());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Finish",
                                          style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.navigate_next,
                                          size: 23,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            );
          }
          if (state is MemoryCreationNoImageSelectedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context
                  .pop(PopPayload<PrivateMemory>(ActionType.noChanges, null));
            });
            return Container();
          }

          if (state is MemoryCreationFinishedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              context.pop(
                  PopPayload<PrivateMemory>(ActionType.created, state.memory));
            });
            return Container();
          }

          if (state is MemoryCreationErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              context.pop(PopPayload<PrivateMemory>(ActionType.deleted, null));
            });
            return Center(
                child: Text(
              state.message,
              style: const TextStyle(color: Colors.white),
            ));
          }

          return Container();
        },
      ),
    ));
  }
}
