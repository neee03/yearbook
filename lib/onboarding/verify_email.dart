import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:yearbook/main.dart';
import 'package:yearbook/pages/navbarpage.dart';
import 'package:yearbook/services/database_services.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email, fullName, password, course, batch, imageurl;
  final int collegeid;

  VerifyEmailPage(
      {this.email,
      this.fullName,
      this.password,
      this.course,
      this.batch,
      this.imageurl,
      this.collegeid});
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  Timer timer;

  @override
  void initState() {
    getUser().then((user) {
      if (user != null) {
        user.sendEmailVerification();
      }
    });

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "🔑  Verify Email",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "A verification email has been sent to your registered college mail.\n\nPlease check your inbox (or spam) and click on the link to verify your email.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                LinearProgressIndicator(),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Waiting for you to verify...",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> checkEmailVerified() async {
    getUser().then((user) async {
      await user.reload();
      if (user.isEmailVerified) {
        timer.cancel();

        // Create a new document for the user with uid
        await DatabaseService(uid: user.uid).updateUserData(
            widget.fullName,
            widget.email,
            widget.password,
            widget.course,
            widget.batch,
            widget.imageurl,
            widget.collegeid);

        //Shared preferences
        await HelperFunctions.saveUserLoggedInSharedPreference(true);
        await HelperFunctions.saveUserEmailSharedPreference(widget.email);
        await HelperFunctions.saveUserNameSharedPreference(widget.fullName);
        await HelperFunctions.saveUserCollegeidSharedPreference(
            widget.collegeid);
        await HelperFunctions.saveUserCourseSharedPreference(widget.course);

        print("Registered");

        // await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
        //   print("Logged in: $value");
        // });
        // await HelperFunctions.getUserEmailSharedPreference().then((value) {
        //   print("Email: $value");
        // });
        // await HelperFunctions.getUserNameSharedPreference().then((value) {
        //   print("Full Name: $value");
        // });

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
      }
    });
  }
}
