import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/user_cubit/user_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/auth_service.dart';

import 'package:google_fonts/google_fonts.dart';

class UserHeader extends StatefulWidget {
  final User user;
  final int postCount;
  final bool isFollowed;
  final bool isFollowInitiated;
  const UserHeader(
      {Key? key,
      required this.postCount,
      required this.user,
      required this.isFollowed,
      required this.isFollowInitiated})
      : super(key: key);

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //pfp
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: CachedNetworkImage(
                    imageUrl: widget.user.pfpLink,
                    httpHeaders:
                        HttpHeadersFactory.getDefaultRequestHeaderForImage(
                            TokenManager().accessToken!),
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    fit: BoxFit.cover,
                    placeholder: (context, _) {
                      return Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    },
                  )),
            ),
            Column(
              children: [
                Text(
                  widget.postCount.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const Text(
                  "Posts",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                // showModalBottomSheet(
                //     enableDrag: true,
                //     isScrollControlled: true,
                //     backgroundColor: Colors.grey.shade900,
                //     context: context,
                //     builder: (context1) {
                //       return BlocProvider.value(
                //           value: context.read<ProfileBloc>(),
                //           child: const RelationshipSheet(
                //               relationship: "Followers"));
                //     });
              },
              child: Column(
                children: [
                  Text(
                    widget.user.followersCount.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "Followers",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                // showModalBottomSheet(
                //     enableDrag: false,
                //     isScrollControlled: true,
                //     backgroundColor: Colors.grey.shade900,
                //     context: context,
                //     builder: (context1) {
                //       return BlocProvider.value(
                //           value: context.read<ProfileBloc>(),
                //           child: const RelationshipSheet(
                //               relationship: "Following"));
                //     });
              },
              child: Column(
                children: [
                  Text(
                    widget.user.followingCount.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                  const Text(
                    "Following",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
            child: Text(
              widget.user.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.user.bio,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
          child: Row(
            children: [
              widget.isFollowInitiated
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(130, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: widget.isFollowed
                              ? Colors.grey.shade500
                              : Colors.blue),
                      onPressed: () {},
                      child: const CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(130, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: widget.isFollowed
                              ? Colors.grey.shade500
                              : Colors.blue),
                      onPressed: () {
                        if (!widget.isFollowed) {
                          context.read<UserCubit>().followUser();
                        } else {
                          context.read<UserCubit>().unfollowUser();
                        }
                      },
                      child: widget.isFollowed
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
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(130, 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.grey.shade500),
                  onPressed: () {},
                  child: const Text(
                    "Share profile",
                    style: TextStyle(color: Colors.black),
                  )),
              Expanded(
                  child: Container(
                height: 1,
              )),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade500),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person_add_alt_1,
                      color: Colors.black,
                    )),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        )
      ],
    );
  }
}

// class RelationshipSheet extends StatefulWidget {
//   final String relationship;
//   const RelationshipSheet({Key? key, required this.relationship})
//       : super(key: key);

//   @override
//   State<RelationshipSheet> createState() => _RelationshipSheetState();
// }

// class _RelationshipSheetState extends State<RelationshipSheet> {
//   ScrollController scrollController = ScrollController();
//   bool isFetching = false;
//   @override
//   void initState() {
//     super.initState();
//     isFetching = true;
//     if (widget.relationship == "Following") {
//       context.read<ProfileBloc>().add(FollowingNextPageFetched());
//     } else {
//       context.read<ProfileBloc>().add(FollowersNextPageFetched());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
//       if (state is ProfileLoadedState) {
//         return Column(
//           children: [
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(15),
//                       topRight: Radius.circular(15))),
//               child: Column(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       context.pop();
//                     },
//                     icon: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     widget.relationship,
//                     style: GoogleFonts.lato(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Divider(
//               height: 2,
//               color: Colors.grey.shade800,
//             ),
//             NotificationListener<ScrollNotification>(
//               onNotification: (notification) {
//                 if (state.followingHasMoreData &&
//                     scrollController.position.pixels >=
//                         scrollController.position.maxScrollExtent * 0.85 &&
//                     isFetching == false) {
//                   print("fetched next data");
//                   isFetching = true;
//                   if (widget.relationship == "Following") {
//                     context.read<ProfileBloc>().add(FollowingNextPageFetched());
//                   } else {
//                     context.read<ProfileBloc>().add(FollowersNextPageFetched());
//                   }
//                 }
//                 return true;
//               },
//               child: Expanded(
//                 child: widget.relationship == "Following"
//                     ? ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         controller: scrollController,
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         itemCount: (state.following.length) + 1,
//                         itemBuilder: (context, index) {
//                           isFetching = false;
//                           if (index == state.following.length) {
//                             if (state.followingHasMoreData) {
//                               return const LinearProgressIndicator();
//                             } else {
//                               return Container();
//                             }
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                             child: TextButton(
//                               onPressed: () {
//                                 context.push(
//                                     "/users/${state.following[index].userId}");
//                               },
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 60,
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.shade600,
//                                       image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: NetworkImage(
//                                             state.following[index].pfpLink),
//                                       ),
//                                       borderRadius: BorderRadius.circular(100),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 15,
//                                   ),
//                                   Text(
//                                     state.following[index].username,
//                                     style: GoogleFonts.lato(
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                   IconButton(
//                                       onPressed: () {},
//                                       icon: const Icon(
//                                         Icons.more_vert,
//                                         color: Colors.white,
//                                       ))
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     : widget.relationship == "Followers"
//                         ? ListView.builder(
//                             scrollDirection: Axis.vertical,
//                             controller: scrollController,
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             itemCount: (state.followers.length),
//                             itemBuilder: (context, index) {
//                               isFetching = false;
//                               if (index == state.followers.length) {
//                                 if (state.followersHasMoreData) {
//                                   return const LinearProgressIndicator();
//                                 } else {
//                                   return Container();
//                                 }
//                               }

//                               return Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 60,
//                                       height: 60,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey.shade600,
//                                         image: DecorationImage(
//                                           fit: BoxFit.cover,
//                                           image: NetworkImage(
//                                               state.followers[index].pfpLink),
//                                         ),
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 15,
//                                     ),
//                                     Text(
//                                       state.followers[index].username,
//                                       style: GoogleFonts.lato(
//                                         fontSize: 16,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                           Icons.more_vert,
//                                           color: Colors.white,
//                                         ))
//                                   ],
//                                 ),
//                               );
//                             },
//                           )
//                         : Container(),
//               ),
//             ),
//           ],
//         );
//       }

//       return Text("Something went wrong");
//     });
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }
// }
