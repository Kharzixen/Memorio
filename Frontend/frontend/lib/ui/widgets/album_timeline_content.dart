import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_bloc/album_bloc.dart';
import 'package:frontend/model/album_model.dart';
import 'package:go_router/go_router.dart';

class TimelineContentGrid extends StatelessWidget {
  final String albumId;
  final Map<String, List<Moment>> photosByDate;
  final bool animationEnabled;
  final bool hasMoreData;
  const TimelineContentGrid(
      {Key? key,
      required this.photosByDate,
      required this.albumId,
      required this.animationEnabled,
      required this.hasMoreData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.5),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450), // Animation duration
        transitionBuilder: (child, animation) {
          if (animationEnabled) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(1.0, 0.0), // Start from right
                end: Offset(0.0, 0.0), // End at the center
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: ContentWidget(
                  key: UniqueKey(),
                  albumId: albumId,
                  animationEnabled: animationEnabled,
                  hasMoreData: hasMoreData,
                  photosByDate: photosByDate,
                ),
              ),
            );
          } else {
            return ContentWidget(
              animationEnabled: animationEnabled,
              albumId: albumId,
              hasMoreData: hasMoreData,
              photosByDate: photosByDate,
            );
          }
        },
        child: ContentWidget(
          key: UniqueKey(),
          albumId: albumId,
          animationEnabled: animationEnabled,
          hasMoreData: hasMoreData,
          photosByDate: photosByDate,
        ),
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  final Map<String, List<Moment>> photosByDate;
  final bool animationEnabled;
  final bool hasMoreData;
  final String albumId;
  const ContentWidget(
      {Key? key,
      required this.photosByDate,
      required this.animationEnabled,
      required this.albumId,
      required this.hasMoreData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: photosByDate.keys.length,
          itemBuilder: (BuildContext context, int index) {
            String date = photosByDate.keys.elementAt(index);
            int photosLength = photosByDate[date]!.length;
            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Key for each date section
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: GestureDetector(
                    onDoubleTap: () {
                      context.read<AlbumBloc>().add(IncreaseGranularity());
                    },
                    onTap: () {
                      context.read<AlbumBloc>().add(DecreaseGranularity());
                    },
                    child: Text(
                      date,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 4,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.5),
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.push(
                            "/albums/${albumId}/${photosByDate[date]![index].entryId}");
                      },
                      child: Image.network(
                        photosByDate[date]![index].photo,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  itemCount: photosLength,
                ),
              ],
            );
          },
        ),
        if (hasMoreData)
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Center(
              child: SizedBox(
                width: 35,
                height: 35,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: SizedBox(
              height: 35,
            ),
          )
      ],
    );
  }
}
