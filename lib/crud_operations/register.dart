import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:final_project_new/pages/splash_screen.dart';
import 'package:final_project_new/widgets/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../models/users.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController firstnamecontroller;
  late TextEditingController lastnamecontroller;
  late TextEditingController emailcontroller;
  late TextEditingController passwordcontroller;
  late TextEditingController imagecontroller;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  late String error;
  late String success;
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
    final path = 'profilePic/${generateRandomString(5)}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    createUser(urlDownload);

    setState(() {
      uploadTask = null;
    });
  }

  @override
  void initState() {
    super.initState();
    firstnamecontroller = TextEditingController();
    lastnamecontroller = TextEditingController();
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    imagecontroller = TextEditingController();
    error = "";
    success = "";
  }

  @override
  void dispose() {
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    imagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _key,
        child: SafeArea(
          child: ListView(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 33,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Text("Sign up",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Center(
                    child: (pickedFile == null) ? imgNotExist() : imgExist(),
                  ),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    selectFile();
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text('Add Photo'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: TextFormField(
                    controller: firstnamecontroller,
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
                      prefixIcon: Icon(
                        Icons.people,
                        color: Colors.grey[200],
                      ),
                      labelText: "First Name",
                      labelStyle: TextStyle(color: Colors.grey[200]),
                      border: InputBorder.none,
                      fillColor: secondaryBlack,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field is Empty";
                      } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        return "Invalid Input this fields doesn't accept special characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: TextFormField(
                    controller: lastnamecontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field is Empty";
                      } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        return "Invalid Input this fields doesn't accept special characters";
                      } else {
                        return null;
                      }
                    },
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
                      prefixIcon: Icon(
                        Icons.people,
                        color: Colors.grey[200],
                      ),
                      labelText: "Last Name",
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
                    controller: emailcontroller,
                    validator: (emailcontroller) => emailcontroller != null &&
                            !EmailValidator.validate(emailcontroller)
                        ? 'Plss enter a valid email'
                        : null,
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
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey[200],
                      ),
                      labelText: "Email",
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
                    obscureText: true,
                    controller: passwordcontroller,
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
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey[200],
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.grey[200]),
                      border: InputBorder.none,
                      fillColor: secondaryBlack,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field is Empty";
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      final isFormValid = _key.currentState!.validate();
                      if (pickedFile == null) {
                        Fluttertoast.showToast(msg: "Please pick an Image");
                        return;
                      }
                      if (isFormValid) {
                        registerUser();
                      }
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    success,
                    style: TextStyle(
                      color: Color.fromARGB(255, 30, 180, 97),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future registerUser() async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      uploadFile();

      setState(() {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Account Created Succefully");
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        error = e.message.toString();
      });
    }
    Navigator.pop(context);
  }

  Future registerWithoutProfile() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;

    final docUser = FirebaseFirestore.instance.collection('Users').doc(userid);

    final newUser = Users(
      id: userid,
      firstname: firstnamecontroller.text,
      lastname: lastnamecontroller.text,
      email: emailcontroller.text,
      password: passwordcontroller.text,
      profilePic: '-',
    );

    final json = newUser.toJson();
    await docUser.set(json);
    setState(() {
      pickedFile = null;
    });

    Navigator.pop(context);
  }

  Future createUser(urlDownload) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;

    final docUser = FirebaseFirestore.instance.collection('Users').doc(userid);

    final newUser = Users(
      id: userid,
      firstname: firstnamecontroller.text,
      lastname: lastnamecontroller.text,
      email: emailcontroller.text,
      password: passwordcontroller.text,
      profilePic: urlDownload,
    );

    final json = newUser.toJson();
    await docUser.set(json);
    setState(() {
      pickedFile = null;
    });

    Navigator.pop(context);
  }

  Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Lottie.asset("assets/lottie_files/lottie-photo.json");
}
