import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/colors.dart';

class UserProfileLogout extends StatefulWidget {
  const UserProfileLogout({super.key});

  @override
  State<UserProfileLogout> createState() => _UserProfileLogoutState();
}

class _UserProfileLogoutState extends State<UserProfileLogout> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlack,
        elevation: 0,
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Signed in as: ${user.email!}'),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Logout Successfully");

                FirebaseAuth.instance.signOut();
              },
              color: Colors.red,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
