import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/public_album_creation_cubit/public_album_creation_cubit.dart';
import 'package:frontend/ui/widgets/public_album_creation_add_people.dart';
import 'package:frontend/ui/widgets/public_album_creation_photo_and_name.dart';
import 'package:go_router/go_router.dart';

class CreatePublicAlbumPage extends StatefulWidget {
  const CreatePublicAlbumPage({super.key});

  @override
  State<CreatePublicAlbumPage> createState() => _CreatePublicAlbumPageState();
}

class _CreatePublicAlbumPageState extends State<CreatePublicAlbumPage>
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
        body: BlocBuilder<PublicAlbumCreationCubit, PublicAlbumCreationState>(
          builder: (context, state) {
            if (state is PublicAlbumCreationInProgressState) {
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
                          PublicAlbumCreationPhotoAndNameSelection(
                            tabController: tabController,
                            formKey: _formKey,
                            nameController: _nameController,
                            descriptionController: _descriptionController,
                          ),
                          PublicAlbumCreationAddPeople(
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

            if (state is PublicAlbumCreationFinishedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pop();
                // context.push("/albums/${state.album.albumId}",
                //     extra: state.album);
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
