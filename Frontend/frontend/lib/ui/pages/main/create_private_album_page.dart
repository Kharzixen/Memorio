import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_creation_bloc/album_creation_bloc.dart';
import 'package:frontend/ui/widgets/private_album_creation_add_people.dart';
import 'package:frontend/ui/widgets/private_album_creation_image_name.dart';
import 'package:go_router/go_router.dart';

class CreatePrivateAlbumPage extends StatefulWidget {
  const CreatePrivateAlbumPage({super.key});

  @override
  State<CreatePrivateAlbumPage> createState() => _CreatePrivateAlbumPageState();
}

class _CreatePrivateAlbumPageState extends State<CreatePrivateAlbumPage>
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
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          PrivateAlbumCreationPhotoAndNameSelection(
                            tabController: tabController,
                            formKey: _formKey,
                            nameController: _nameController,
                            descriptionController: _descriptionController,
                          ),
                          PrivateAlbumCreationAddPeople(
                              tabController: tabController,
                              nameController: _nameController,
                              descriptionController: _descriptionController)
                        ],
                      )),
                    ),
                  ],
                ),
              );
            }

            if (state is AlbumCreationFinishedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pop();
                context.push("/albums/${state.album.albumId}",
                    extra: state.album);
              });
              return Container();
            }
            return const Center(
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
