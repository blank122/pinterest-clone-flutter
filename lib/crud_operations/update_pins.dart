import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/pins.dart';
import '../widgets/colors.dart';

class UpdatePins extends StatefulWidget {
  const UpdatePins({
    super.key,
    required this.pin_id,
    required this.pin_title,
    required this.pin_category,
    required this.pin_image,
  });

  final pin_id;
  final pin_title;
  final pin_category;
  final pin_image;

  @override
  State<UpdatePins> createState() => _UpdatePinsState();
}

class _UpdatePinsState extends State<UpdatePins> {
  late TextEditingController pinstitlecontroller;
  late TextEditingController pinscategory;

  late String imgUrl;
  late String error;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future uploadFile() async {
    final path = 'UserPins/${generateRandomString(8)}';
    print('update path Link: $path');
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      setState(() {
        uploadTask = ref.putFile(file);
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = e.message.toString();
      });
    }

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('update Download Link: $urlDownload');
    print('post id');
    print(widget.pin_id);
    print('img url');
    print(widget.pin_image);
    updatePins(widget.pin_id, urlDownload);

    setState(() {
      uploadTask = null;
    });
  }

  @override
  void initState() {
    super.initState();
    pinstitlecontroller = TextEditingController(
      text: widget.pin_title,
    );
    pinscategory = TextEditingController(
      text: widget.pin_category,
    );

    imgUrl = widget.pin_image;
    error = "";
  }

  @override
  void dispose() {
    pinstitlecontroller.dispose();
    pinscategory.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlack,
        elevation: 0,
        title: const Text('Edit Pins'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Color.fromARGB(142, 158, 158, 158),
                    ),
                  ),
                  child: Center(
                    child: (pickedFile == null) ? checkImgVal() : imgExist(),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    selectFile();
                  },
                  icon:
                      const Icon(Icons.camera), //icon data for elevated button
                  label: const Text("Select Picture"), //label text
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red //elevated btton background color
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 15.0),
                  child: TextFormField(
                    controller: pinstitlecontroller,
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
                      labelText: "Title",
                      labelStyle: TextStyle(color: Colors.grey[200]),
                      border: InputBorder.none,
                      fillColor: secondaryBlack,
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 15.0),
                  child: TextFormField(
                    controller: pinscategory,
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
                      labelText: "Category",
                      labelStyle: TextStyle(color: Colors.grey[200]),
                      border: InputBorder.none,
                      fillColor: secondaryBlack,
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      (pickedFile != null)
                          ? uploadFile()
                          : updateNoFile(widget.pin_id);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                buildProgress(),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    error,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future updatePins(String id, String image) async {
    final docUser = FirebaseFirestore.instance.collection('Userpins').doc(id);
    await docUser.update({
      'pinstitle': pinstitlecontroller.text,
      'pinscategory': pinscategory.text,
      'pinsimage': image,
    });

    Navigator.pop(context);
  }

  Future updateNoFile(String id) async {
    final docUser = FirebaseFirestore.instance.collection('Userpins').doc(id);
    await docUser.update({
      'pinstitle': pinstitlecontroller.text,
      'pinscategory': pinscategory.text,
    });

    Navigator.pop(context);
  }

  Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Image.network(
        widget.pin_image,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExistBlank() => Image.asset(
        'assets/images/no-image.png',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget checkImgVal() {
    return (widget.pin_image == '-') ? imgNotExistBlank() : imgNotExist();
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
