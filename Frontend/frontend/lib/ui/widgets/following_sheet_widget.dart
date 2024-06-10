import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/following_sheet_cubit.dart/following_sheet_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowingSheetWidget extends StatefulWidget {
  final String userId;
  const FollowingSheetWidget({Key? key, required this.userId})
      : super(key: key);

  @override
  State<FollowingSheetWidget> createState() => _FollowingSheetWidgetState();
}

class _FollowingSheetWidgetState extends State<FollowingSheetWidget> {
  ScrollController scrollController = ScrollController();
  bool isFetching = false;
  @override
  void initState() {
    super.initState();
    isFetching = true;
    context.read<FollowingSheetCubit>().getFollowing(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowingSheetCubit, FollowingSheetState>(
        builder: (context, state) {
      if (state is FollowingSheetLoadedState) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Following",
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              height: 2,
              color: Colors.grey.shade800,
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (state.hasMoreData &&
                    scrollController.position.pixels >=
                        scrollController.position.maxScrollExtent * 0.85 &&
                    isFetching == false) {
                  isFetching = true;
                  context
                      .read<FollowingSheetCubit>()
                      .getFollowing(widget.userId);
                }
                return true;
              },
              child: Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: (state.followers.length) + 1,
                itemBuilder: (context, index) {
                  isFetching = false;
                  if (index == state.followers.length) {
                    if (state.hasMoreData) {
                      return const LinearProgressIndicator();
                    } else {
                      return Container();
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextButton(
                      onPressed: () async {
                        var response = await context.push(
                            "/users/${state.followers[index].user.userId}");
                        if (response != null && context.mounted) {
                          PopPayload<String> payload =
                              response as PopPayload<String>;
                          if (payload.actionType == ActionType.deleted) {
                            context
                                .read<FollowingSheetCubit>()
                                .refreshFollowStatus(
                                    index: index, isFollowed: false);
                          }
                          if (payload.actionType == ActionType.created) {
                            context
                                .read<FollowingSheetCubit>()
                                .refreshFollowStatus(
                                    index: index, isFollowed: true);
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade600,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  state.followers[index].user.pfpLink,
                                  headers: HttpHeadersFactory
                                      .getDefaultRequestHeaderForImage(
                                          TokenManager().accessToken!),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            state.followers[index].user.username,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          state.followers[index].isFollowInitiated
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(130, 30),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor:
                                          state.followers[index].isFollowed
                                              ? Colors.grey.shade500
                                              : Colors.blue),
                                  onPressed: () {},
                                  child: const CircularProgressIndicator())
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(130, 30),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor:
                                          state.followers[index].isFollowed
                                              ? Colors.grey.shade500
                                              : Colors.blue),
                                  onPressed: () {
                                    if (!state.followers[index].isFollowed) {
                                      context
                                          .read<FollowingSheetCubit>()
                                          .followUser(index);
                                    } else {
                                      context
                                          .read<FollowingSheetCubit>()
                                          .unfollowUser(index);
                                    }
                                  },
                                  child: state.followers[index].isFollowed
                                      ? Text(
                                          "Followed",
                                          style: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "Follow",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                )
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        );
      }

      if (state is FollowingSheetLoadingState) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              Text(
                "Following",
                style: GoogleFonts.lato(color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                height: 2,
                color: Colors.grey.shade800,
              ),
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        );
      }

      if (state is FollowingSheetErrorState) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              Text(
                "Following",
                style: GoogleFonts.lato(color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                height: 2,
                color: Colors.grey.shade800,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            Text(
              "Following",
              style: GoogleFonts.lato(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              height: 2,
              color: Colors.grey.shade800,
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Something went wrong",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
