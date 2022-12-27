import 'package:final_project_new/pages/debug_home.dart';
import 'package:final_project_new/pages/debug_user_profile.dart';
import 'package:final_project_new/pages/user_profile.dart';
import 'package:final_project_new/pages/user_profile_logout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NavigationDrawer extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser!;
  NavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      );
  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const SizedBox(
                height: double.infinity, child: Icon(Icons.person)),
            title: const Text('Signed In As: '),
            subtitle: Text(currentUser.email!),
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.home)],
            ),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DebugHome(),
                  ));
            },
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.home)],
            ),
            title: const Text('Profile Details'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfile(),
                  ));
            },
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.person)],
            ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Logout Successfully",
                fontSize: 16,
              );
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      );
}
