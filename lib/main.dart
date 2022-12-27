import 'package:final_project_new/crud_operations/login.dart';
import 'package:final_project_new/pages/splash_screen.dart';
import 'package:final_project_new/widgets/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'firebase_options.dart';
import 'services/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: primaryBlack,
        colorScheme: ColorScheme.fromSeed(
          seedColor: secondaryBlack,
          primary: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
