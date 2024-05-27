import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/user_cubit/user_cubit.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/ui/widgets/profile_content.dart';
import 'package:frontend/ui/widgets/user_header.dart';
import 'package:go_router/go_router.dart';

class UserProfilePage extends StatelessWidget {
  final String id;
  const UserProfilePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        print("Pop");
        if (context.read<UserCubit>().getIsFollowStatusChanged()) {
          bool isFollowed = context.read<UserCubit>().isFollowed;
          if (isFollowed) {
            context.pop(PopPayload(ActionType.created, id));
          } else {
            context.pop(PopPayload(ActionType.deleted, id));
          }
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<UserCubit, UserPageState>(builder: (context, state) {
          if (state is UserPageLoadedState) {
            return SafeArea(
                child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (context.read<UserCubit>().getIsFollowStatusChanged()) {
                      bool isFollowed = context.read<UserCubit>().isFollowed;
                      if (isFollowed) {
                        context.pop(PopPayload(ActionType.created, id));
                        return;
                      } else {
                        context.pop(PopPayload(ActionType.deleted, id));
                        return;
                      }
                    }
                    context.pop();
                    return;
                  },
                ),
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  state.user.username,
                  style: const TextStyle(color: Colors.white),
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
                  var cubit = context.read<UserCubit>().stream.first;
                  context.read<UserCubit>().refreshPage();
                  await cubit;
                },
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    UserHeader(
                      user: state.user,
                      isFollowed: state.isFollowed,
                      isFollowInitiated: state.isFollowInitiated,
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

          if (state is UserPageLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserPageErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }
}

// PopScope(
//                     onPopInvoked: (didPop) {
//                       print("Pop");
//                       if (context
//                           .read<UserCubit>()
//                           .getIsFollowStatusChanged()) {
//                         bool isFollowed = context.read<UserCubit>().isFollowed;
//                         if (isFollowed) {
//                           context.pop(PopPayload(ActionType.created, id));
//                         } else {
//                           context.pop(PopPayload(ActionType.deleted, id));
//                         }
//                       }
//                     },