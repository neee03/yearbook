import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:yearbook/main.dart';
import 'package:yearbook/pages/navbarpage.dart';

class InviteFriends extends StatefulWidget {
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFCB37),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 7,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
                child: Text(
              "Pick 3 friends",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
                child: Text(
              "Relic app literally only works with friends",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.8,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50.0,
              child: RaisedButton(
                  elevation: 0.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('Invite friends 😎',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    await Share.share(
                        "Heyyyy, try this yearbook app where all our friends are writing each other letters, this is sooo cool! 🔥\n\n\nGet the app now! \n\nFor Android: https://play.google.com/store/apps/details?id=app.yearbook.yearbookapp \n\nFor iPhone: https://apps.apple.com/in/app/relic-your-virtual-yearbook/id1571515236#?platform=iphone",
                        subject: "Yearbook App!");
                    Timer(Duration(seconds: 4), () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MyApp()));
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
