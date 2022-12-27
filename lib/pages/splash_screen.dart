import 'package:final_project_new/pages/debug_home.dart';
import 'package:final_project_new/pages/starting_page.dart';
import 'package:final_project_new/services/session.dart';
import 'package:final_project_new/widgets/textstyle.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Session()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Lottie.asset("assets/lottie_files/lottie-pinterest.json"),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Pinterest Clone',
              style: mainLetterHeader,
            )
          ],
        ),
      ),
    );
  }
}
