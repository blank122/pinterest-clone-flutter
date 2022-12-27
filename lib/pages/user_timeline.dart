//show all the post posted by the current user login
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_new/crud_operations/update_pins.dart';
import 'package:final_project_new/crud_operations/view_pins.dart';
import 'package:final_project_new/models/pins.dart';
import 'package:final_project_new/widgets/capital_letter.dart';
import 'package:final_project_new/widgets/colors.dart';
import 'package:final_project_new/widgets/textstyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/drawer.dart';

class UserTimeline extends StatefulWidget {
  const UserTimeline({super.key});

  @override
  State<UserTimeline> createState() => _UserTimelineState();
}

class _UserTimelineState extends State<UserTimeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: primaryBlack,
        title: const Text('User Timeline'),
        elevation: 0,
      ),
      body: StreamBuilder<List<Pins>>(
        stream: readUserPost(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            // return ListView(
            //   children: users.map(postimage).toList(),
            // );

            return GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.565,
              ),
              children: users.map(newuserpost).toList(),
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

  Widget newuserpost(Pins userpost) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewPins(
                userpins: userpost,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            postimage(userpost),
          ],
        ),
      );
  deleteUser(String id) {
    print('id of user = $id');
    final docUser = FirebaseFirestore.instance.collection('Userpins').doc(id);
    docUser.delete();
    Navigator.pop(context);
  }

  Widget postdetails(Pins userpost) => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userpost.pinstitle.toCapitalized(),
              style: letterHeader,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.black54,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 15),
                            child: Divider(
                              color: Colors.grey,
                              height: 5,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdatePins(
                                          pin_id: userpost.pins_id,
                                          pin_title: userpost.pinstitle,
                                          pin_category: userpost.pinscategory,
                                          pin_image: userpost.pinsimage,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Edit",
                                    style: letterHeader,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showActionSheet(context, userpost.pins_id);
                                  },
                                  child: Text(
                                    "Delete",
                                    style: letterHeader,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 26),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: primaryBlack,
                              ),
                              child: Text(
                                "Close",
                                style: letterHeader,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );

  void _showActionSheet(BuildContext context, String id) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Confirmation $id'),
        message: Text(
          'Are you sure you want to delete this post? Doing this will not undo any changes.',
          style: letterHeader,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              deleteUser(id);
            },
            child: Text(
              'Continue',
              style: letterHeader,
            ),
          ),
        ],
        cancelButton: Container(
          color: primaryBlack,
          child: CupertinoActionSheetAction(
            child: Text(
              'Cancel',
              style: letterHeader,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget postimage(Pins userpost) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(),
          //     child: SizedBox(
          //       child: FadeInImage.assetNetwork(
          //         placeholder: 'assets/images/please-wait.gif',
          //         image: userpost.pinsimage,
          //         fit: BoxFit.cover,
          //         fadeInDuration: const Duration(milliseconds: 2),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/loader.gif',
                image: userpost.pinsimage,
                height: 250,
              ),
            ),
          ),
          postdetails(userpost),
        ],
      );

  var nametxtStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  Future<int> readUserPostLength() =>
      FirebaseFirestore.instance.collection('Userpins').snapshots().length;

  Stream<List<Pins>> readUserPost(id) => FirebaseFirestore.instance
      .collection('Userpins')
      .where('userId', isEqualTo: id)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Pins.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );

  updateLike(String id, bool status) {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    docUser.update({
      'isLiked': status,
    });
  }
}
