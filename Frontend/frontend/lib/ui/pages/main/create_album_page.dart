import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_creation_bloc/album_creation_bloc.dart';
import 'package:frontend/ui/widgets/album_creation_image_name.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAlbumPage extends StatefulWidget {
  const CreateAlbumPage({super.key});

  @override
  State<CreateAlbumPage> createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<CreateAlbumPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<AlbumCreationBloc, AlbumCreationState>(
          builder: (context, state) {
            if (state is AlbumCreationInProgressState) {
              return DefaultTabController(
                length: 4,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
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
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverFillRemaining(
                          child: TabBarView(
                        controller: tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          BlocProvider.value(
                            value: BlocProvider.of<AlbumCreationBloc>(context),
                            child: AlbumCreationPhotoAndNameSelection(
                              tabController: tabController,
                              formKey: _formKey,
                              nameController: _nameController,
                              descriptionController: _descriptionController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Text(
                                  "Add contributors to your new album",
                                  style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      onPressed: () {
                                        if (tabController.index > 0) {
                                          tabController.animateTo(
                                              tabController.index - 1);
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
                                        // if (tabController.index <
                                        //     tabController.length - 1) {
                                        //   tabController
                                        //       .animateTo(tabController.index + 1);
                                        // }
                                        context.read<AlbumCreationBloc>().add(
                                            AlbumCreationFinalized(
                                                albumName: _nameController.text,
                                                caption: _descriptionController
                                                    .text));
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
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              );
            }
            return Center(
                child: Text(
              "Something went wrong",
              style: TextStyle(color: Colors.white),
            ));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
