import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateMemoryCreationHashtagsSelectionWidget extends StatelessWidget {
  final TabController tabController;

  const PrivateMemoryCreationHashtagsSelectionWidget(
      {Key? key, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> hashtags = [
      "portrait",
      "party",
      "fun",
      "adventure",
      "hashtag1",
      "hashtag2"
    ];
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            "Choose hashtags for this memory:",
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Wrap(
            children: hashtags
                .map((e) => TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "#",
                            style: GoogleFonts.lato(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            e,
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ))
                .toList()),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: TextFormField(
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
                    "Write hashtags:",
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
          height: 25,
        ),
        Row(
          children: [
            TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  if (tabController.index > 0) {
                    // context
                    //     .read<MemoryCreationBloc>()
                    //     .add(NextPageFetched());
                    tabController.animateTo(tabController.index - 1);
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.navigate_before,
                        size: 23,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Back",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )),
            Spacer(),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                if (tabController.index < tabController.length - 1) {
                  tabController.animateTo(tabController.index + 1);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          ],
        ),
      ],
    );
  }
}
