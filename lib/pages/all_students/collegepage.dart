import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:share/share.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:yearbook/pages/all_students/listofstudents/listofstudents2021.dart';
import 'package:yearbook/pages/all_students/listofstudents/listofstudents2022.dart';
import 'package:yearbook/pages/all_students/search_screen.dart';
import 'package:yearbook/pages/settings/settings.dart';

class CollegePage extends StatefulWidget {
  @override
  _CollegePageState createState() => _CollegePageState();
}

class _CollegePageState extends State<CollegePage> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  int localcollegeid;
  String usercourse;
  List<String> courselist = [];
  int sharedValue = 0;
  final Map<int, Widget> coursewidgets = const <int, Widget>{
    0: Text("Batch 2021"),
    1: Text("Batch 2022"),
  };

  //SnapLiveCameraContent snapLiveCameraContent = new SnapLiveCameraContent();

  @override
  void initState() {
    super.initState();
    getUserCourse();
    getCourses();
  }

  getUserCourse() async {
    await HelperFunctions.getUserCourseSharedPreference().then((course) async {
      setState(() {
        courselist.add(course);
        usercourse = course;
      });
    });
  }

  Future<dynamic> getCourses() async {
    await HelperFunctions.getUserCollegeidSharedPreference()
        .then((collegeid) async {
      setState(() {
        localcollegeid = collegeid;
      });
      await Firestore.instance
          .collection("courses")
          .where('collegeid', isEqualTo: collegeid)
          .orderBy('noofusers', descending: true)
          .getDocuments()
          .then((ds) {
        setState(() {
          if (ds != null) {
            ds.documents.forEach((docs) {
              if (docs.data['coursename'] != usercourse) {
                courselist.add(docs.data['coursename']);
              }
            });
          }
        });
      });

      _fcm.subscribeToTopic('${collegeid}college');
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodies = [
      SafeArea(
        child: DefaultTabController(
          length: courselist.length,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                child: ButtonsTabBar(
                  buttonMargin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 4,
                    bottom: 4,
                  ),
                  radius: 8,
                  height: 40,
                  backgroundColor: Colors.white,
                  unselectedBackgroundColor: Colors.grey[200],
                  unselectedLabelStyle:
                      TextStyle(color: Colors.grey[700], fontSize: 12),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  tabs: List<Widget>.generate(courselist.length, (int index) {
                    print(courselist[0]);
                    return new Tab(text: "      ${courselist[index]}      ");
                  }),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children:
                      List<Widget>.generate(courselist.length, (int index) {
                    return new Listofstudents2021(
                      course: courselist[index],
                      collegeid: localcollegeid,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      SafeArea(
        child: DefaultTabController(
          length: courselist.length,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                child: ButtonsTabBar(
                  buttonMargin: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 4,
                    bottom: 4,
                  ),
                  radius: 8,
                  height: 40,
                  backgroundColor: Colors.white,
                  unselectedBackgroundColor: Colors.grey[200],
                  unselectedLabelStyle:
                      TextStyle(color: Colors.grey[700], fontSize: 12),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  tabs: List<Widget>.generate(courselist.length, (int index) {
                    print(courselist[0]);
                    return new Tab(text: "      ${courselist[index]}      ");
                  }),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children:
                      List<Widget>.generate(courselist.length, (int index) {
                    return new Listofstudents2022(
                      course: courselist[index],
                      collegeid: localcollegeid,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            "Relic",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          actions: [
            IconButton(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                icon: Icon(Icons.settings, color: Colors.black, size: 25.0),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                }),
            IconButton(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                icon:
                    Icon(Icons.search_rounded, color: Colors.black, size: 26.0),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                }),
          ],
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
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
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          elevation: 7,
          onPressed: () {
            Share.share(
                "Heyyyy, try this yearbook app where all our friends are writing each other letters, this is sooo cool! 🔥\n\n\nGet the app now! \n\nFor Android: https://play.google.com/store/apps/details?id=app.yearbook.yearbookapp \n\nFor iPhone: https://apps.apple.com/in/app/relic-your-virtual-yearbook/id1571515236#?platform=iphone",
                subject: "Yearbook App!");
          },
          label: Text(
            'Get yearbook signatures',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          icon: Icon(
            Icons.edit_rounded,
            color: Colors.black,
            size: 20,
          ),
          backgroundColor: Color(0xFFFFCB37),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: bodies[sharedValue],
        ));
  }
}
