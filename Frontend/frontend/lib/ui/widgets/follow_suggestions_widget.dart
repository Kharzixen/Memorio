import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/following_suggestion_cubit/following_suggestion_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowingSuggestionWidget extends StatefulWidget {
  const FollowingSuggestionWidget({super.key});

  @override
  State<FollowingSuggestionWidget> createState() =>
      _FollowingSuggestionWidgetState();
}

class _FollowingSuggestionWidgetState extends State<FollowingSuggestionWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context
        .read<FollowingSuggestionCubit>()
        .loadSuggestionsOfUser(StorageService().userId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<FollowingSuggestionCubit, FollowingSuggestionState>(
        builder: (context, state) {
      if (state is FollowingSuggestionLoadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state is FollowingSuggestionLoadedState) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView(
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                "Suggestions: ",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: ((context, index) {
                  return GestureDetector(
                      onTap: () async {
                        var response = await context
                            .push("/users/${state.users[index].user.userId}");
                        if (response != null) {
                          PopPayload<String> payload =
                              response as PopPayload<String>;

                          if (context.mounted) {
                            if (payload.actionType == ActionType.deleted) {
                              context
                                  .read<FollowingSuggestionCubit>()
                                  .refreshFollowStatus(
                                      index: index, isFollowed: false);
                            }
                            if (payload.actionType == ActionType.created) {
                              context
                                  .read<FollowingSuggestionCubit>()
                                  .refreshFollowStatus(
                                      index: index, isFollowed: true);
                            }
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100)),
                              width: 80,
                              height: 80,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: state.users[index].user.pfpLink,
                                  fadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  httpHeaders: HttpHeadersFactory
                                      .getDefaultRequestHeaderForImage(
                                          TokenManager().accessToken!),
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    );
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              state.users[index].user.username,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            state.users[index].isFollowInitiated
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(130, 30),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        backgroundColor:
                                            state.users[index].isFollowed
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
                                            state.users[index].isFollowed
                                                ? Colors.grey.shade500
                                                : Colors.blue),
                                    onPressed: () {
                                      if (!state.users[index].isFollowed) {
                                        context
                                            .read<FollowingSuggestionCubit>()
                                            .followUser(index);
                                      } else {
                                        context
                                            .read<FollowingSuggestionCubit>()
                                            .unfollowUser(index);
                                      }
                                    },
                                    child: state.users[index].isFollowed
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
                                  ),
                          ],
                        ),
                      ));
                }),
                itemCount: state.users.length,
              ),
            ],
          ),
        );
      }

      if (state is FollowingSuggestionErrorState) {
        return Center(
          child: Text(
            state.message,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      return const Center(
        child: Text(
          "Something went wrong",
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
