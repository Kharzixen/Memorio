import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/create_post_cubit/create_post_cubit.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/model/utils/post_creation_details.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/post_image_and_description_widget.dart';
import 'package:frontend/ui/widgets/select_hashtags_for_post.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePostPage extends StatefulWidget {
  final PostCreationDetails details;
  const CreatePostPage({super.key, required this.details});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
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
    tabController = TabController(vsync: this, length: 3);

    context.read<CreatePostCubit>().pickImage(widget.details);
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
      body: BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
          if (state is PostCreationLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (state is PostCreationInProgressState) {
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
                      PostImageAndDescriptionWidget(
                        image: state.image,
                        tabController: tabController,
                      ),
                      SelectHashtagsForPost(tabController: tabController),
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
                                  foregroundImage:
                                      NetworkImage(StorageService().pfp),
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
                              state.caption,
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
                                const Spacer(),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    context
                                        .read<CreatePostCubit>()
                                        .createPost();
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
          if (state is PostCreationNoImageSelectedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pop(PopPayload<Post>(ActionType.noChanges, null));
            });
            return Container();
          }

          if (state is PostCreationFinishedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              context.pop(PopPayload<Post>(ActionType.created, state.post));
            });
            return Container();
          }

          if (state is PostCreationErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              context.pop(PopPayload<Post>(ActionType.deleted, null));
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
