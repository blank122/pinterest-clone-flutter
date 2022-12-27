import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_new/crud_operations/view_pins.dart';
import 'package:final_project_new/models/pins.dart';
import 'package:final_project_new/widgets/capital_letter.dart';
import 'package:final_project_new/widgets/colors.dart';
import 'package:final_project_new/widgets/textstyle.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../models/users.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlack,
        title: const Text('All'),
        elevation: 0,
      ),
      body: StreamBuilder<List<Pins>>(
        stream: readUserPost(),
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

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
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
            const SizedBox(
              height: 15,
            ),
            postimage(userpost),
          ],
        ),
      );

  Widget postdetails(Pins userpost) => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ignore: avoid_print
            // Text(userpost.pins_id),
            Text(
              userpost.pinstitle.toCapitalized(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
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
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "This Pin was inspired by your recent activity",
                                  style: letterHeader,
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // ignore: avoid_print
                                TextButton(
                                  onPressed: () async {
                                    final status =
                                        await Permission.storage.request();

                                    if (status.isGranted) {
                                      final externalDir =
                                          await getExternalStorageDirectory();

                                      final id =
                                          await FlutterDownloader.enqueue(
                                        url: userpost.pinsimage,
                                        savedDir: externalDir!.path,
                                        fileName:
                                            '${generateRandomString(5)}.jpg',
                                        showNotification: true,
                                        openFileFromNotification: true,
                                      );
                                    } else {}
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Download",
                                    style: postFonts,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Report",
                                  style: postFonts,
                                  textAlign: TextAlign.left,
                                )
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
                                  color: Colors.grey.shade300),
                              child: const Text("Close",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
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

  updateLike(String id, bool status) {
    final docUser = FirebaseFirestore.instance.collection('UserPost').doc(id);
    docUser.update({
      'isLiked': status,
    });
  }

  // Future<String> getStorageUrl(String fileName) async {
  //   String url = "";
  //   final storageReference =
  //       FirebaseStorage.instance.ref().child("Userpins/$fileName");
  //   url = await storageReference.getDownloadURL();
  //   return url;
  // }

  // Future downloadFile({required String url, String? fileName}) async {
  //   // final file = await downloadImage(url, fileName!);
  //   // if (file == null) return;
  //   // print('Path: ${file.path}');

  //   // print('Success');
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final file = File('${appStorage.path}/${fileName}');
  // }

  // Future<File?> downloadImage(String url, String name) async {
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final file = File('${appStorage.path}/${name}');

  //   try {
  //     final response = await Dio().get(
  //       url,
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         followRedirects: false,
  //         receiveTimeout: 0,
  //       ),
  //     );

  //     final storeFile = file.openSync(mode: FileMode.write);
  //     storeFile.writeFromSync(response.data);
  //     await storeFile.close();

  //     return file;
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
