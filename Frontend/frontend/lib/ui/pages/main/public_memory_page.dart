import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/public_memory_cubit/public_memory_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/ui/widgets/public_memory_header.dart';
import 'package:go_router/go_router.dart';
import 'package:widget_zoom/widget_zoom.dart';

class PublicMemoryPage extends StatelessWidget {
  final String memoryId;
  final String albumId;
  const PublicMemoryPage(
      {super.key, required this.albumId, required this.memoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.chat_rounded,
                size: 23,
              )),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<PublicMemoryCubit, PublicMemoryState>(
        builder: (context, state) {
          //circular progress indicator
          if (state is PublicMemoryLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          if (state is PublicMemoryLoadedState) {
            if (state.asyncMethodInProgress) {
              return Stack(
                children: [
                  Content(memory: state.memory),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Content(memory: state.memory);
            }
          }

          if (state is PublicMemoryDeletedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.canPop()) {
                context.pop(PopPayload<String>(ActionType.deleted, memoryId));
              }
            });

            return const SizedBox();
          }

          if (state is PublicMemoryErrorState) {
            return Center(
              child: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return const Text(
            "An unexpected error occurred",
            style: TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }
}

class Content extends StatelessWidget {
  final DetailedPublicMemory memory;
  const Content({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            color: Colors.white.withOpacity(0.08),
            child: Align(
              alignment: Alignment.topCenter,
              child: WidgetZoom(
                heroAnimationTag: "tag",
                zoomWidget: CachedNetworkImage(
                  imageUrl: memory.photo,
                  httpHeaders:
                      HttpHeadersFactory.getDefaultRequestHeaderForImage(
                          TokenManager().accessToken!),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          PublicMemoryHeader(
            memory: memory,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
