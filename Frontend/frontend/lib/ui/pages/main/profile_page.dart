import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/profile_bloc/profile_bloc.dart';
import 'package:frontend/service/storage_service.dart';
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
    username = context.read<StorageService>().username;
    context.read<ProfileBloc>().add(ProfileFetched(profileId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                username,
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
            body: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoadedState) {
                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      ProfileHeader(user: state.user),
                      Divider(
                        height: 30,
                        thickness: 0.5,
                      ),
                      ProfileContent(),
                    ],
                  );
                }
                if (state is ProfileLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }

                return Text("elbaszva");
              },
            )));
  }
}
