//users profile
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_new/widgets/bottom_nav.dart';
import 'package:final_project_new/widgets/colors.dart';
import 'package:final_project_new/widgets/textstyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/users.dart';
import '../widgets/drawer.dart';

class DebugUserProfile extends StatefulWidget {
  const DebugUserProfile({super.key});

  @override
  State<DebugUserProfile> createState() => _DebugUserProfileState();
}

class _DebugUserProfileState extends State<DebugUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: primaryBlack,
        title: const Text('User Profile'),
        elevation: 0,
      ),
      body: StreamBuilder<List<Users>>(
        stream: readUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Something went wrong ${snapshot.error}',
              style: errorTextStyle,
            );
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget imgExist(img) => CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(img),
      );

  Widget imgNotExist() => const CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
            'https://www.pngkey.com/png/detail/121-1219231_user-default-profile.png'),
      );

  Widget buildUser(Users user) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              ),
              Text("User id: ${user.id}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Name: ",
                style: letterHeader,
                textAlign: TextAlign.left,
              ),
              Text('${user.firstname}  ${user.lastname}', style: letterHeader),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Email: ",
                style: letterHeader,
                textAlign: TextAlign.left,
              ),
              Text(
                ' ${user.email}',
                style: letterHeader,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.arrow_back,
              size: 32,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            label: const Text(
              'SIGN OUT',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ],
      );

  Stream<List<Users>> readUser(id) => FirebaseFirestore.instance
      .collection('Users')
      .where('id', isEqualTo: id)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Users.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );

  Widget read(uid) {
    var collection = FirebaseFirestore.instance.collection('Users');
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: collection.doc(uid).snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');

              if (snapshot.hasData) {
                final users = snapshot.data!.data();
                final newUser = Users(
                  id: users!['id'],
                  firstname: users['firstname'],
                  lastname: users['lastname'],
                  password: users['password'],
                  email: users['email'],
                  profilePic: users['profilePic'],
                );

                return buildUser(newUser);
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
