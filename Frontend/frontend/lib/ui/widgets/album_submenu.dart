import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/album_bloc/album_bloc.dart';

class AlbumSubmenu extends StatelessWidget {
  final String currentPage;
  final ScrollController scrollController;
  const AlbumSubmenu(
      {Key? key, required this.currentPage, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: currentPage == "timeline"
                  ? const Color.fromRGBO(24, 119, 242, 1)
                  : Colors.white, // Set bottom border color here
              width: 1, // Set bottom border width here
            ))),
            height: 35,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.transparent;
                  },
                ),
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                context.read<AlbumBloc>().add(AlbumDisplayChangedToTimeline(
                    contentBefore: currentPage,
                    position: scrollController.position.pixels));
              },
              child: Text(
                "Timeline",
                style: TextStyle(
                  color: currentPage == "timeline"
                      ? const Color.fromRGBO(24, 119, 242, 1)
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: currentPage == "collection"
                  ? const Color.fromRGBO(24, 119, 242, 1)
                  : Colors.white,
              width: 1,
            ))),
            height: 35,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.transparent;
                  },
                ),
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                context.read<AlbumBloc>().add(AlbumDisplayChangedToCollection(
                    contentBefore: currentPage,
                    position: scrollController.position.pixels));
              },
              child: Text(
                "Collections",
                style: TextStyle(
                  color: currentPage == "collection"
                      ? const Color.fromRGBO(24, 119, 242, 1)
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.white, // Set bottom border color here
              width: 1, // Set bottom border width here
            ))),
            height: 35,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.transparent;
                  },
                ),
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                //context.read<AlbumBloc>().add(AlbumDisplayChangedToTimeline());
              },
              child: const Text(
                "Notes",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
