import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/user_cubit/user_cubit.dart';
import 'package:frontend/ui/widgets/profile_content.dart';
import 'package:frontend/ui/widgets/profile_header.dart';

class UserProfilePage extends StatelessWidget {
  final String id;
  const UserProfilePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserCubit, UserPageState>(builder: (context, state) {
        if (state is UserPageLoadedState) {
          return SafeArea(
              child: Scaffold(
            backgroundColor: Colors.black,
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
            body: ListView(
              scrollDirection: Axis.vertical,
              children: [
                ProfileHeader(user: state.user),
                const Divider(
                  height: 30,
                  thickness: 0.5,
                ),
                ProfileContent(),
              ],
            ),
          ));
        }

        if (state is UserPageLoadingState) {
          return Center(child: LinearProgressIndicator());
        }
        return Container();
      }),
    );
  }
}
