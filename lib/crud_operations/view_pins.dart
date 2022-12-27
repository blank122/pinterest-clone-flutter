import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_new/models/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/pins.dart';

class ViewPins extends StatefulWidget {
  const ViewPins({
    super.key,
    required this.userpins,
  });
  final Pins userpins;

  @override
  State<ViewPins> createState() => _ViewPinsState();
}

class _ViewPinsState extends State<ViewPins> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              userpinsdetails(widget.userpins),
            ],
          ),
        ],
      ),
    );
  }

  Widget userpinsdetails(Pins userpin) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          postimage(userpin),
        ],
      );

  Widget postimage(Pins userpin) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            Text(userpin.pins_id),
            Container(
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(userpin.pinsimage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      );

  Stream<List<Pins>> readUserPost() =>
      FirebaseFirestore.instance.collection('Userpins').snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => Pins.fromJson(
                    doc.data(),
                  ),
                )
                .toList(),
          );
}
