// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAK-G99NEDKJyccHwGVcvtMod66aVxgKzo',
    appId: '1:566193888765:web:4b4e7137dd54b205d58d94',
    messagingSenderId: '566193888765',
    projectId: 'final-project-new-7d119',
    authDomain: 'final-project-new-7d119.firebaseapp.com',
    storageBucket: 'final-project-new-7d119.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSgsIp8lVKY6j6TcGrO9MLO0JaEnxJeH0',
    appId: '1:566193888765:android:834a540a8f1d6eb5d58d94',
    messagingSenderId: '566193888765',
    projectId: 'final-project-new-7d119',
    storageBucket: 'final-project-new-7d119.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZ9cuIdteP5CnuoPXsRnENOGUT9lTQH_M',
    appId: '1:566193888765:ios:03b7ae158182e884d58d94',
    messagingSenderId: '566193888765',
    projectId: 'final-project-new-7d119',
    storageBucket: 'final-project-new-7d119.appspot.com',
    iosClientId: '566193888765-kue93ioqeg24j36b7o10pjmnc2mgu3s9.apps.googleusercontent.com',
    iosBundleId: 'com.example.finalProjectNew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZ9cuIdteP5CnuoPXsRnENOGUT9lTQH_M',
    appId: '1:566193888765:ios:03b7ae158182e884d58d94',
    messagingSenderId: '566193888765',
    projectId: 'final-project-new-7d119',
    storageBucket: 'final-project-new-7d119.appspot.com',
    iosClientId: '566193888765-kue93ioqeg24j36b7o10pjmnc2mgu3s9.apps.googleusercontent.com',
    iosBundleId: 'com.example.finalProjectNew',
  );
}
