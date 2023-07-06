import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yearbook/onboarding/all_colleges/listofcolleges.dart';
import 'package:yearbook/onboarding/all_colleges/listofschools.dart';
import 'package:yearbook/onboarding/all_colleges/start_page.dart';

class AllCollegesPage extends StatefulWidget {
  @override
  _AllCollegesPageState createState() => _AllCollegesPageState();
}

class _AllCollegesPageState extends State<AllCollegesPage> {
  int sharedValue = 0;
  final Uri sendmail = Uri(
      scheme: 'mailto',
      path: 'relic.yearbook@gmail.com',
      query:
          'subject=Add my college.&body=Please write the name of your college/school:');

  Future<dynamic> getColleges() async {
    QuerySnapshot qn = await Firestore.instance
        .collection('colleges')
        .orderBy('collegename')
        .getDocuments();
    return qn.documents;
  }

  final Map<int, Widget> coursewidgets = const <int, Widget>{
    0: Text("Colleges"),
    1: Text("Schools"),
  };

  List<Widget> bodies = [
    ListOfColleges(),
    ListOfSchools(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, 90),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoSlidingSegmentedControl<int>(
                        backgroundColor: Colors.white70,
                        children: coursewidgets,
                        onValueChanged: (int val) {
                          setState(() {
                            sharedValue = val;
                          });
                        },
                        groupValue: sharedValue,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Request to add your own college/school',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  var url = sendmail.toString();
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw "Could not launch the url";
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            backgroundColor: Color(0xFFFFCB37),
            body: bodies[sharedValue]));
  }
}
