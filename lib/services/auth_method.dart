import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_new/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Users');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(allData);
  }
}
