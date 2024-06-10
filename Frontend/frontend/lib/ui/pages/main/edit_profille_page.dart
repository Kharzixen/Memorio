import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text("Edit Profile",
              style: GoogleFonts.lato(color: Colors.white)),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSuccessState) {
              context.pop(PopPayload<User>(ActionType.updated, state.user));
            }
          },
          builder: (context, state) {
            if (state is EditProfileLoadedState) {
              final TextEditingController controller =
                  TextEditingController(text: state.bio);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text("Change profile picture:",
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context1) {
                                    return BlocProvider.value(
                                        value: context.read<EditProfileCubit>(),
                                        child: ChooseImageSourceBottomSheet(
                                          textEditingController: controller,
                                        ));
                                  });
                            },
                            child: state.image.isNotEmpty
                                ? Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(120),
                                      image: DecorationImage(
                                          image: MemoryImage(
                                            state.image,
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  )
                                : Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(120),
                                        color: Colors.pink.shade100,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              state.user.pfpLink,
                                            ),
                                            fit: BoxFit.cover)),
                                  ),
                          ),
                          state.image.isNotEmpty
                              ? Positioned(
                                  bottom: 0,
                                  right: -12,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(120),
                                        color: Colors.white),
                                    child: IconButton(
                                      onPressed: () {
                                        context
                                            .read<EditProfileCubit>()
                                            .removeImage(controller.text);
                                      },
                                      color: Colors.white,
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 25,
                                      ),
                                    ),
                                  ))
                              : Positioned(
                                  bottom: 0,
                                  right: -12,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(120),
                                        color: Colors.white),
                                    child: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context1) {
                                            return BlocProvider.value(
                                                value: context
                                                    .read<EditProfileCubit>(),
                                                child:
                                                    ChooseImageSourceBottomSheet(
                                                  textEditingController:
                                                      controller,
                                                ));
                                          },
                                        );
                                      },
                                      color: Colors.white,
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                        color: Colors.black,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Text(
                      "Change your bio:",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    TextFormField(
                      controller: controller,
                      minLines: 4,
                      maxLines: 8,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Write description for disposable camera",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.replay,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                size: 45,
                              )),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                          child: IconButton(
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
                                      title: const Text(
                                          'Are you sure you want update your bio ?'),
                                      actions: [
                                        TextButton(
                                          child: const Text(
                                            'Update',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () async {
                                            context
                                                .read<EditProfileCubit>()
                                                .updateProfile(controller.text);

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
                                                  fontWeight: FontWeight.bold)),
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
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 45,
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

class ChooseImageSourceBottomSheet extends StatelessWidget {
  final TextEditingController textEditingController;
  const ChooseImageSourceBottomSheet(
      {super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.grey.shade900),
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Select Album Cover',
              style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                    maximumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white),
                onPressed: () {
                  context.read<EditProfileCubit>().loadNewImage(
                      ImageSource.camera, textEditingController.text);
                },
                child: const SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 20,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Take a photo",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    "or",
                    style: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                    maximumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white),
                onPressed: () {
                  context.read<EditProfileCubit>().loadNewImage(
                      ImageSource.gallery, textEditingController.text);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 24,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Choose from Gallery",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
