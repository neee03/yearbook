import 'package:flutter/material.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:yearbook/pages/moments/feed_page.dart';
import 'package:yearbook/pages/moments/show_albums.dart';
import 'package:yearbook/pages/all_students/collegepage.dart';
import 'package:yearbook/pages/shuffle%20suggestions/shuffle_suggestions.dart';
import 'package:yearbook/pages/yearbook/yearbook_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int localcollegeid = 0;

  List<Widget> _children = [
    CollegePage(),
    ShuffleSuggestions(),
    YearbookPage(),
  ];

  // getCollegeid() async {
  //   await HelperFunctions.getUserCollegeidSharedPreference().then((collegeid) {
  //     if (collegeid == 1 ||
  //         collegeid == 2 ||
  //         collegeid == 4 ||
  //         collegeid == 6 ||
  //         collegeid == 10 ||
  //         collegeid == 14 ||
  //         collegeid == 99991) {
  //       setState(() {
  //         _children = [
  //           FeedPage(),
  //           CollegePage(),
  //           ShuffleSuggestions(),
  //           YearbookPage(),
  //         ];
  //         localcollegeid = collegeid;
  //       });
  //     } else {
  //       setState(() {
  //         _children = [
  //           CollegePage(),
  //           ShuffleSuggestions(),
  //           YearbookPage(),
  //         ];
  //         localcollegeid = collegeid;
  //       });
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getCollegeid();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children.isNotEmpty
          ? _children[_currentIndex]
          : CircularProgressIndicator(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: new Border(
            top: new BorderSide(
                color: Colors.black, width: 0.2, style: BorderStyle.solid),
          ),
        ),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.grey[500],
          selectedItemColor: Colors.grey[700],
          backgroundColor: Colors.white,
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          items: [
            // if (localcollegeid == 1 ||
            //     localcollegeid == 2 ||
            //     localcollegeid == 4 ||
            //     localcollegeid == 6 ||
            //     localcollegeid == 10 ||
            //     localcollegeid == 14 ||
            //     localcollegeid == 99991)
            //   new BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.camera_roll_rounded,
            //       size: 22,
            //     ),
            //     label: ('Moments'),
            //   ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: ('Class'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.shuffle),
              label: ('Shuffle'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.school_rounded),
              label: ('Yearbook'),
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
