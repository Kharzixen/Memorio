import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/cubit/create_disposable_camera_memory_cubit/create_disposable_camera_memory_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

class DisposableCameraMemoryImageAndDescriptionWidget extends StatefulWidget {
  final Uint8List image;
  final TabController tabController;
  const DisposableCameraMemoryImageAndDescriptionWidget(
      {super.key, required this.image, required this.tabController});

  @override
  State<DisposableCameraMemoryImageAndDescriptionWidget> createState() =>
      _DisposableCameraMemoryImageAndDescriptionWidgetState();
}

class _DisposableCameraMemoryImageAndDescriptionWidgetState
    extends State<DisposableCameraMemoryImageAndDescriptionWidget>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            "Share the moment",
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Image.memory(
            widget.image,
            fit: BoxFit.cover,
            frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: frame != null
                    ? child
                    : const Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(strokeWidth: 6),
                        ),
                      ),
              );
            }),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(
                  StorageService().pfp,
                  headers: HttpHeadersFactory.getDefaultRequestHeaderForImage(
                      TokenManager().accessToken!),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                StorageService().username,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: TextFormField(
            controller: textEditingController,
            minLines: 2,
            maxLines: 5,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Write description:",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
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
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              BlocBuilder<CreateDisposableCameraMemoryCubit,
                  CreateDisposableCameraMemoryState>(builder: (context, state) {
                if (state is DisposableCameraMemoryCreationInProgressState) {
                  if (!state.saveInProgress && !state.savedToGallery) {
                    return TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(115, 50)),
                      onPressed: () {
                        context
                            .read<CreateDisposableCameraMemoryCubit>()
                            .saveImage();
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              Text(
                                "Save",
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
                                Icons.download,
                                size: 23,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state.saveInProgress) {
                    return TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: Size(115, 50)),
                        onPressed: () {
                          context
                              .read<CreateDisposableCameraMemoryCubit>()
                              .saveImage();
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: CircularProgressIndicator(),
                        ));
                  } else if (state.savedToGallery) {
                    return TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: Size(115, 50)),
                        onPressed: () {
                          context
                              .read<CreateDisposableCameraMemoryCubit>()
                              .saveImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Saved",
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
                                Icons.download_done,
                                size: 23,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ));
                  }
                }

                return const Text("Something went wrong");
              }),
              const Spacer(),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white, fixedSize: Size(115, 50)),
                  onPressed: () {
                    if (widget.tabController.index <
                        widget.tabController.length - 1) {
                      context
                          .read<CreateDisposableCameraMemoryCubit>()
                          .setDescription(textEditingController.text);
                      widget.tabController
                          .animateTo(widget.tabController.index + 1);
                    }
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
