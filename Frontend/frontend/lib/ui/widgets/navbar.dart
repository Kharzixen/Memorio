import 'package:flutter/material.dart';
import 'package:frontend/service/configuration_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ConfigurationService.navBarSize,
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
              text: "Albums",
              onPressed: () {
                context.go("/albums");
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
