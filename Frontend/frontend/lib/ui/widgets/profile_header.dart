import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/following_sheet_cubit.dart/following_sheet_cubit.dart';
import 'package:frontend/data/repository/user_repository.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/ui/widgets/following_sheet_widget.dart';

class ProfileHeader extends StatefulWidget {
  final User user;
  const ProfileHeader({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
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
            const Column(
              children: [
                Text(
                  "0",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Text(
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
                showModalBottomSheet(
                    enableDrag: false,
                    isScrollControlled: true,
                    backgroundColor: Colors.grey.shade900,
                    context: context,
                    builder: (context1) {
                      return BlocProvider(
                          create: (context) => FollowingSheetCubit(
                              context.read<UserRepository>()),
                          child:
                              FollowingSheetWidget(userId: widget.user.userId));
                    });
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(130, 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.grey.shade500),
                  onPressed: () {},
                  child: const Text(
                    "Edit profile",
                    style: TextStyle(color: Colors.black),
                  )),
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
