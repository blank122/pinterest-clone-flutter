import 'package:email_validator/email_validator.dart';
import 'package:final_project_new/crud_operations/register.dart';
import 'package:final_project_new/pages/splash_screen.dart';
import 'package:final_project_new/widgets/colors.dart';
import 'package:final_project_new/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernamecontroller;
  late TextEditingController passwordcontroller;
  late String error;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    usernamecontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Login Your Account',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Lottie.asset(
                        "assets/lottie_files/lottie-pinterest.json"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15),
                    child: TextFormField(
                      controller: usernamecontroller,
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
                          borderSide: const BorderSide(color: secondaryBlack),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey[200],
                        ),
                        labelText: "Email Address",
                        labelStyle: TextStyle(color: Colors.grey[200]),
                        border: InputBorder.none,
                        fillColor: secondaryBlack,
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: passwordcontroller,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Empty";
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: primaryBlack),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: secondaryBlack),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.grey[200],
                        ),
                        border: InputBorder.none,
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.grey[200]),
                        fillColor: secondaryBlack,
                        filled: true,
                      ),
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

                        if (isFormValid) {
                          signIn();
                        }
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10.0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                        child: Text('Create an Account')),
                  ),
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
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernamecontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      setState(() {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Login Successfully");
        error = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.toString().contains('user-not-found')) {
        setState(() {
          error = 'Users not found';
        });
      }
      if (e.toString().contains('wrong-password')) {
        setState(() {
          error = 'Wrong password';
        });
      }
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
