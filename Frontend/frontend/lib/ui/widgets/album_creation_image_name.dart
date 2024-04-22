import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_creation_bloc/album_creation_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumCreationPhotoAndNameSelection extends StatefulWidget {
  final TabController tabController;
  final formKey;
  final nameController;
  final descriptionController;
  const AlbumCreationPhotoAndNameSelection(
      {Key? key,
      required this.tabController,
      required this.formKey,
      required this.nameController,
      required this.descriptionController})
      : super(key: key);

  @override
  State<AlbumCreationPhotoAndNameSelection> createState() =>
      _AlbumCreationPhotoAndNameSelectionState();
}

class _AlbumCreationPhotoAndNameSelectionState
    extends State<AlbumCreationPhotoAndNameSelection>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AlbumCreationBloc, AlbumCreationState>(
      builder: (context, state) {
        if (state is AlbumCreationInProgressState) {
          if (state.image.isNotEmpty) {
            context.pop();
          }
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create a new album:",
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
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
                                  value: BlocProvider.of<AlbumCreationBloc>(
                                      context),
                                  child: const ChooseImageSourceBottomSheet());
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
                                  borderRadius: BorderRadius.circular(120),
                                  color: Colors.pink.shade100),
                              child: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                    ),
                    state.image.isNotEmpty
                        ? Positioned(
                            bottom: 0,
                            right: -12,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(120),
                                  color: Colors.white),
                              child: IconButton(
                                onPressed: () {
                                  context
                                      .read<AlbumCreationBloc>()
                                      .add(RemoveImage());
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
                                  borderRadius: BorderRadius.circular(120),
                                  color: Colors.white),
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context1) {
                                      return BlocProvider.value(
                                          value: BlocProvider.of<
                                              AlbumCreationBloc>(context),
                                          child:
                                              const ChooseImageSourceBottomSheet());
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
                            )),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: widget.formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: TextFormField(
                        controller: widget.nameController,
                        minLines: 1,
                        maxLines: 1,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          label: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Album name",
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please give the album a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: TextFormField(
                        controller: widget.descriptionController,
                        minLines: 2,
                        maxLines: 5,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          label: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Write description",
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
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      if (widget.formKey.currentState!.validate() &&
                          widget.tabController.index <
                              widget.tabController.length - 1) {
                        widget.tabController
                            .animateTo(widget.tabController.index + 1);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Next",
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.navigate_next,
                            size: 23,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }

        return Text(
          "Something Went wrong",
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ChooseImageSourceBottomSheet extends StatelessWidget {
  const ChooseImageSourceBottomSheet({super.key});

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
                onPressed: () {},
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
                  context
                      .read<AlbumCreationBloc>()
                      .add(ImageSelectionStarted());
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
