import 'package:admin_panel/cubit/users_panel_cubit/users_panel_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPanel extends StatelessWidget {
  const UsersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: BlocProvider(
        create: (context) => UsersPanelCubit(),
        child: UserList(),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersPanelCubit, UsersPanelState>(
      builder: (context, state) {
        if (state is UsersPanelLoaded) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("User ID: ${user.id.toString()}"),
                                  Text("Username: ${user.username}"),
                                  Row(
                                    children: [
                                      const Text("Status: "),
                                      user.isActive
                                          ? const Text(
                                              "Active",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                          : const Text(
                                              "Disabled",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            )
                                    ],
                                  )
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.person)),
                              const SizedBox(
                                width: 25,
                              ),
                              user.isActive
                                  ? IconButton(
                                      onPressed: () async {
                                        return showDialog<void>(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              titleTextStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              title: Text(
                                                  'Are you sure you want suspend this user ? ${user.id}'),
                                              actions: [
                                                TextButton(
                                                  child: Text(
                                                    'Suspend',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.red.shade800,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () async {
                                                    context
                                                        .read<UsersPanelCubit>()
                                                        .suspendUser(user.id);

                                                    if (Navigator.of(context,
                                                            rootNavigator: true)
                                                        .canPop()) {
                                                      Navigator.of(
                                                              dialogContext,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    }
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  onPressed: () {
                                                    if (Navigator.of(context,
                                                            rootNavigator: true)
                                                        .canPop()) {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.pause_circle_outline))
                                  : IconButton(
                                      onPressed: () async {
                                        return showDialog<void>(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              titleTextStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              title: Text(
                                                  'Are you sure you want activate this user ? ${user.id}'),
                                              actions: [
                                                TextButton(
                                                  child: const Text(
                                                    'Activate',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () async {
                                                    context
                                                        .read<UsersPanelCubit>()
                                                        .activateUser(user.id);

                                                    if (Navigator.of(context,
                                                            rootNavigator: true)
                                                        .canPop()) {
                                                      Navigator.of(
                                                              dialogContext,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    }
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  onPressed: () {
                                                    if (Navigator.of(context,
                                                            rootNavigator: true)
                                                        .canPop()) {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.check_circle_outlined)),
                              const SizedBox(
                                width: 25,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    return showDialog<void>(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey.shade800,
                                          titleTextStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          title: Text(
                                              'Are you sure you want to delete this user ? ${user.id}'),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red.shade800,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () async {
                                                //need to await the run of this event, to perform the other deletion

                                                context
                                                    .read<UsersPanelCubit>()
                                                    .deleteUser(user.id);

                                                if (Navigator.of(context,
                                                        rootNavigator: true)
                                                    .canPop()) {
                                                  Navigator.of(dialogContext,
                                                          rootNavigator: true)
                                                      .pop();
                                                }
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              onPressed: () {
                                                if (Navigator.of(context,
                                                        rootNavigator: true)
                                                    .canPop()) {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.close)),
                            ],
                          ),
                          const Divider()
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      context.read<UsersPanelCubit>().previousPage();
                    },
                  ),
                  Text('Page ${state.currentPage} of ${state.totalPages}'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      context.read<UsersPanelCubit>().nextPage();
                    },
                  ),
                ],
              ),
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
