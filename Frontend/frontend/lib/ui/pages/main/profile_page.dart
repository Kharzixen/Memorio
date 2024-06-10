import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/profile_bloc/profile_bloc.dart';
import 'package:frontend/model/post_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/create_post_bottom_sheet.dart';
import 'package:frontend/ui/widgets/profile_content.dart';
import 'package:frontend/ui/widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    String profileId = context.read<StorageService>().userId;
    context.read<ProfileBloc>().add(ProfileFetched(profileId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          return SafeArea(
              child: Scaffold(
            backgroundColor: Colors.black,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.grey.shade900.withOpacity(0.6),
              onPressed: () async {
                var response = await showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context1) {
                    return CreatePostBottomSheet(
                      userId: state.user.userId,
                    );
                  },
                );
                if (response != null) {
                  PopPayload popResponse = response as PopPayload;
                  if (popResponse.actionType == ActionType.created &&
                      context.mounted) {
                    context
                        .read<ProfileBloc>()
                        .add(NewPostCreated(popResponse.data! as Post));
                  }
                }
              },
              child: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 30,
              ),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                state.user.username,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
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
            ),
            body: RefreshIndicator.adaptive(
              onRefresh: () async {
                var cubit = context.read<ProfileBloc>().stream.first;
                context.read<ProfileBloc>().add(RefreshProfile());
                await cubit;
              },
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  ProfileHeader(
                    user: state.user,
                    postCount: state.postCount,
                  ),
                  const Divider(
                    height: 30,
                    thickness: 0.5,
                  ),
                  ProfileContent(posts: state.posts),
                ],
              ),
            ),
          ));
        }
        if (state is ProfileLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }

        if (state is ProfileErrorState) {
          return Center(
              child: Text(
            state.errorMessage,
            style: const TextStyle(color: Colors.white),
          ));
        }

        return const Text(
          "Something went wrong",
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }
}
