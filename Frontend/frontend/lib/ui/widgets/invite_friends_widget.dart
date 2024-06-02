import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/cubit/invitation_cubit/invitation_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class InviteFriendsToAlbumWidget extends StatefulWidget {
  const InviteFriendsToAlbumWidget({super.key});

  @override
  State<InviteFriendsToAlbumWidget> createState() =>
      _InviteFriendsToAlbumWidgetState();
}

class _InviteFriendsToAlbumWidgetState extends State<InviteFriendsToAlbumWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<InvitationCubit, InvitationPageState>(
        builder: (context, state) {
      if (state is InvitationPageLoadedState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                "Invite your friends: ",
                style: GoogleFonts.lato(color: Colors.white, fontSize: 23),
              ),
              state.friends.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.friends.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                          child: TextButton(
                            onPressed: () {
                              if (state.isSelectedFriend[index]) {
                                context
                                    .read<InvitationCubit>()
                                    .unselectFriendAtIndex(index);
                              } else {
                                context
                                    .read<InvitationCubit>()
                                    .selectFriendAtIndex(index);
                              }
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                splashFactory: NoSplash.splashFactory,
                                backgroundColor: Colors.transparent),
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
                                        state.friends[index].pfpLink,
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
                                  state.friends[index].username,
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                state.isSelectedFriend[index]
                                    ? Icon(Icons.check_circle)
                                    : Icon(Icons.radio_button_unchecked)
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      height: 500,
                      child: Center(
                        child: Text(
                          "No friends to show",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    )
            ],
          ),
        );
      }

      return const Center(
        child: Text(
          "Something went wromg",
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }
}
