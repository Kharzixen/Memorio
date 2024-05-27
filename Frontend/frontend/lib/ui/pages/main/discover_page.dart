import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/ui/widgets/follow_suggestions_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                "Discover",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.black,
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
                    text: "People",
                  ),
                  Tab(
                    text: "Album Hub",
                  ),
                  Tab(
                    text: "Notes",
                  )
                ],
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
            body: TabBarView(
              children: [
                const FollowingSuggestionWidget(),
                //second tab
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ));
  }
}
