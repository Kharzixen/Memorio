import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GNav(
          selectedIndex: 2,
          gap: 10,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.all(16),
          tabs: [
            GButton(
              icon: Icons.photo_library_outlined,
              text: "Gallery",
              onPressed: () {
                context.go("/gallery");
              },
            ),
            GButton(
              icon: Icons.add_box_outlined,
              text: "Create",
              onPressed: () {
                context.go("/create");
              },
            ),
            GButton(
                icon: Icons.home,
                text: "Home",
                onPressed: () {
                  context.go("/home");
                }),
            GButton(
                icon: Icons.search,
                text: "Discover",
                onPressed: () {
                  context.go("/discover");
                }),
            GButton(
                icon: Icons.person,
                text: "Profile",
                onPressed: () {
                  context.go("/profile");
                }),
          ],
        ),
      ),
    );
  }
}
