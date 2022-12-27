import 'package:final_project_new/crud_operations/login.dart';
import 'package:final_project_new/widgets/colors.dart';
import 'package:final_project_new/widgets/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../crud_operations/register.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/images/pinterest_icon_150.svg',
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Pinterest Clone',
                style: mainLetterHeader,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Share your memories, one picture at a time.',
                style: tagline,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/starting_page_logo.jpg'),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              color: Colors.red,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Login',
                style: postFonts,
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Register(),
                  ),
                );
              },
              color: Colors.redAccent,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Sign up',
                  style: postFonts,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
