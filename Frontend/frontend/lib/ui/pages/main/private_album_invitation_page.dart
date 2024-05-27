import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/invitation_cubit/invitation_cubit.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/invite_friends_widget.dart';
import 'package:frontend/ui/widgets/invite_others_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateAlbumInvitationPage extends StatefulWidget {
  final String albumId;
  const PrivateAlbumInvitationPage({super.key, required this.albumId});

  @override
  State<PrivateAlbumInvitationPage> createState() =>
      _PrivateAlbumInvitationPageState();
}

class _PrivateAlbumInvitationPageState
    extends State<PrivateAlbumInvitationPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<InvitationCubit>()
        .startInvitations(widget.albumId, StorageService().userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvitationCubit, InvitationPageState>(
        builder: (context, state) {
      //data loading state, cpi showed
      if (state is InvitationPageLoadingState) {
        return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
      }

      //data loaded state, showing the actual widget
      if (state is InvitationPageLoadedState) {
        return Scaffold(
          floatingActionButton: state.selectedUsers.isEmpty
              ? Container()
              : FloatingActionButton(
                  onPressed: () {
                    context
                        .read<InvitationCubit>()
                        .addSelectedUsersToContributors();
                  },
                  child: const Icon(Icons.check),
                ),
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text("Invite people",
                style: GoogleFonts.lato(color: Colors.white, fontSize: 25)),
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Stack(
            children: [
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        dividerColor: Colors.white,
                        dividerHeight: 2,
                        indicatorColor: Colors.blue,
                        unselectedLabelColor: Colors.white,
                        labelColor: Colors.blue,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(
                            child: Center(child: Text("Invite friends")),
                          ),
                          Tab(
                            child: Center(child: Text("Invite others")),
                          )
                        ]),
                    Expanded(
                      child: TabBarView(children: [
                        BlocProvider.value(
                            value: context.read<InvitationCubit>(),
                            child: InviteFriendsToAlbumWidget()),
                        BlocProvider.value(
                          value: context.read<InvitationCubit>(),
                          child: InviteOthersToAlbumWidget(),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              state.isAsyncMethodInProgress
                  ? Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        );
      }

      if (state is InvitationPageFinishedState) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            context.pop("${state.nrOfSelectedUsers} user(s) invited");
          },
        );
        return Container();
      }
      //when everything fails
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            "Somtehing went wrong",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }
}
