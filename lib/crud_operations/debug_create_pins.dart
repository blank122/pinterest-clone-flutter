import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:final_project_new/widgets/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/pins.dart';

class DebugCreatePins extends StatefulWidget {
  const DebugCreatePins({super.key});

  @override
  State<DebugCreatePins> createState() => _DebugCreatePinsState();
}

class _DebugCreatePinsState extends State<DebugCreatePins> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late TextEditingController pinTitle;
  late TextEditingController pinCategory;
  late String userFirstname;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'UserPins/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    createPins(urlDownload);

    setState(() {
      uploadTask = null;
    });
  }

  @override
  void initState() {
    super.initState();
    pinTitle = TextEditingController();
    pinCategory = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pinTitle.dispose();
    pinCategory.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Color.fromARGB(142, 158, 158, 158),
                  ),
                ),
                child: Center(
                  child: (pickedFile == null) ? imgNotExist() : imgExist(),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  selectFile();
                },
                icon: const Icon(
                  Icons.add_a_photo,
                  color: primaryBlack,
                ),
                label: const Text(
                  'Add Photo',
                  style: TextStyle(color: primaryBlack),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: TextFormField(
                  controller: pinTitle,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: primaryBlack),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: primaryBlack),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: "Add a Title",
                    labelStyle: TextStyle(color: Colors.grey[200]),
                    border: InputBorder.none,
                    fillColor: secondaryBlack,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: TextFormField(
                  controller: pinCategory,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: primaryBlack),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: primaryBlack),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: "Add a Category",
                    labelStyle: TextStyle(color: Colors.grey[200]),
                    border: InputBorder.none,
                    fillColor: secondaryBlack,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: uploadFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      border: Border.all(
                        color: primaryBlack,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Publish',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Image.asset(
        'assets/images/no-image.png',
        fit: BoxFit.cover,
      );

  Future createPins(urlDownload) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    final docUser = FirebaseFirestore.instance
        .collection('Users')
        .doc(userid)
        .get()
        .then((ds) {});
    final docPins = FirebaseFirestore.instance.collection('Userpins').doc();

    final newUserPins = Pins(
      pins_id: docPins.id,
      pinscategory: pinCategory.text,
      pinsimage: urlDownload,
      pinstitle: pinTitle.text,
      userId: userid,

      // numcomments: numcomCtrl.text,
      // numshare: numshareCtrl.text,
      // isLiked: false,
    );

    final json = newUserPins.toJson();
    await docPins.set(json);

    print(newUserPins.pins_id);
    setState(() {
      pickedFile = null;
      pinTitle.text = " ";
      pinCategory.text = " ";
    });
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });
}
