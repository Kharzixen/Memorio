import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/database.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Data data = Data();
    return SafeArea(
        child: Drawer(
      backgroundColor: Colors.grey.shade800,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.grey.shade900),
              accountEmail: Text(
                data.profile.email,
                style: TextStyle(fontSize: 15),
              ),
              accountName: Text(
                data.profile.username,
                style: TextStyle(fontSize: 15),
              ),
              currentAccountPicture: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        image: data.profile.pfp, fit: BoxFit.cover)),
              )),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: Icon(Icons.music_note),
            title: Text('Festivals'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: Icon(Icons.people),
            title: Text('People'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: Icon(Icons.send),
            title: Text('Messages'),
          ),
          Divider(),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => context.push("/settings"),
          ),
          Divider(),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: Icon(Icons.description),
            title: Text('Terms and Conditions'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => (context.go("/")),
          ),
        ],
      ),
    ));
  }
}
