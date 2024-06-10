import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/collection_preview_bloc/collections_preview_bloc.dart';
import 'package:frontend/bloc/timeline_bloc/timeline_bloc.dart';
import 'package:frontend/cubit/disposable_camera_cubit/disposable_camera_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/action_types_for_pop_payload.dart';
import 'package:frontend/model/utils/pop_payload.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:frontend/ui/widgets/create_disposable_camera_memory_bottom_sheet.dart';
import 'package:frontend/ui/widgets/disposable_camera_widget.dart';
import 'package:frontend/ui/widgets/private_album_collections_content.dart';
import 'package:frontend/ui/widgets/private_album_timeline_content.dart';
import 'package:frontend/ui/widgets/create_memory_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateAlbumPage extends StatefulWidget {
  final String albumId;
  final AlbumPreview albumPreview;
  const PrivateAlbumPage(
      {Key? key, required this.albumId, required this.albumPreview})
      : super(key: key);

  @override
  State<PrivateAlbumPage> createState() => _PrivateAlbumPageState();
}

class _PrivateAlbumPageState extends State<PrivateAlbumPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<DisposableCameraCubit>()
        .loadDisposableCamera(widget.albumId, StorageService().userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton:
            BlocBuilder<DisposableCameraCubit, DisposableCameraState>(
          builder: (context, state) {
            if (state is DisposableCameraLoadedState) {
              if (state.albumInfo.disposableCamera.isActive) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: "addMemoryTag",
                      backgroundColor: Colors.grey.shade900.withOpacity(0.6),
                      onPressed: () async {
                        var response = await showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context1) {
                            return BlocProvider.value(
                              value: context.read<TimelineBloc>(),
                              child: CreateMemoryBottomSheet(
                                album: SimplePrivateAlbum.fromAlbumPreview(
                                    widget.albumPreview),
                              ),
                            );
                          },
                        );
                        if (response != null) {
                          PopPayload popResponse = response as PopPayload;
                          if (popResponse.actionType == ActionType.created &&
                              context.mounted) {
                            context.read<TimelineBloc>().add(
                                NewMemoryCreatedTimeline(
                                    popResponse.data! as PrivateMemory));
                          }
                        }
                      },
                      child: const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    FloatingActionButton(
                      heroTag: "addDisposableCameraMemoryTag",
                      backgroundColor: Colors.grey.shade900.withOpacity(0.6),
                      onPressed: () async {
                        var response = await showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context1) {
                            return CreateDisposableCameraMemoryBottomSheet(
                              simpleAlbum: SimplePrivateAlbum.fromAlbumPreview(
                                  widget.albumPreview),
                            );
                          },
                        );
                        if (response != null) {
                          PopPayload popResponse = response as PopPayload;
                          if (popResponse.actionType == ActionType.created &&
                              context.mounted) {
                            context.read<DisposableCameraCubit>().addNewMemory(
                                popResponse.data! as PrivateMemory);
                          }
                        }
                      },
                      child: const Icon(
                        Icons.camera,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                );
              }
            }

            return FloatingActionButton(
              heroTag: "addMemoryTag",
              backgroundColor: Colors.grey.shade900.withOpacity(0.6),
              onPressed: () async {
                var response = await showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context1) {
                    return BlocProvider.value(
                      value: context.read<TimelineBloc>(),
                      child: CreateMemoryBottomSheet(
                        album: SimplePrivateAlbum.fromAlbumPreview(
                            widget.albumPreview),
                      ),
                    );
                  },
                );
                if (response != null) {
                  PopPayload popResponse = response as PopPayload;
                  if (popResponse.actionType == ActionType.created &&
                      context.mounted) {
                    context.read<TimelineBloc>().add(NewMemoryCreatedTimeline(
                        popResponse.data! as PrivateMemory));
                  }
                }
              },
              child: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 30,
              ),
            );
          },
        ),
        backgroundColor: Colors.black,
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, _) {
              return [
                SliverAppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.black,
                  pinned: true,
                  floating: true,
                  title: GestureDetector(
                    onTap: () async {
                      var returnObject = await context.push(
                          "/albums/${widget.albumPreview.albumId}/details");
                      if (returnObject != null) {
                        PopPayload popPayload =
                            returnObject as PopPayload<String>;

                        if (popPayload.actionType == ActionType.leaved) {
                          if (context.mounted) {
                            context.pop(popPayload);
                          }
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  widget.albumPreview.albumPicture,
                                  headers: HttpHeadersFactory
                                      .getDefaultRequestHeaderForImage(
                                          TokenManager().accessToken!),
                                )),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(right: 13.0),
                            child: Text(
                              widget.albumPreview.name,
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: const TabBar(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    dividerColor: Colors.white,
                    dividerHeight: 2,
                    indicatorColor: Colors.blue,
                    unselectedLabelColor: Colors.white,
                    labelColor: Colors.blue,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        text: "Timeline",
                      ),
                      Tab(
                        text: "Collection",
                      ),
                      Tab(
                        text: "Camera",
                      )
                    ],
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      BlocProvider.value(
                        value: context.read<TimelineBloc>(),
                        child: PrivateAlbumTimelineContentGrid(
                          album: SimplePrivateAlbum.fromAlbumPreview(
                              widget.albumPreview),
                        ),
                      ),

                      BlocProvider.value(
                        value: context.read<CollectionsPreviewBloc>(),
                        child: PrivateAlbumCollectionsContent(
                          album: SimplePrivateAlbum.fromAlbumPreview(
                              widget.albumPreview),
                        ),
                      ),
                      //third tab
                      BlocProvider.value(
                        value: context.read<DisposableCameraCubit>(),
                        child: DisposableCameraWidget(
                          albumId: widget.albumId,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
