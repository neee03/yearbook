// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:share/share.dart';
// import 'package:yearbook/helper/helper_functions.dart';
// import 'package:yearbook/pages/all_students/search_screen.dart';
// import 'package:yearbook/pages/all_students/srcc/usersofbcom.dart';
// import 'package:yearbook/pages/all_students/srcc/usersofecon.dart';
// import 'package:yearbook/pages/all_students/sscbs/usersofbfia.dart';
// import 'package:yearbook/pages/all_students/sscbs/usersofbsc.dart';
// import 'package:yearbook/pages/settings/settings.dart';

// class ViewStudents extends StatefulWidget {
//   @override
//   _ViewStudentsState createState() => _ViewStudentsState();
// }

// class _ViewStudentsState extends State<ViewStudents> {
//   int sharedValue = 0;
//   final FirebaseMessaging _fcm = FirebaseMessaging();

//   Map<int, Widget> coursewidgets = <int, Widget>{
//     0: Text(""),
//     1: Text(""),
//   };

//   List<Widget> bodies = [
//     Text(""),
//     Text(""),
//   ];

//   @override
//   void initState() {
//     // TODO: implement initState
//     getCollegeid();
//     super.initState();
//   }

//   getCollegeid() async {
//     await HelperFunctions.getUserCollegeidSharedPreference().then((value) {
//       if (value == 1) {
//         setState(() {
//           coursewidgets = <int, Widget>{
//             0: Text("BMS"),
//             1: Text("BFIA"),
//             2: Text("BSC"),
//           };
//           bodies = [
//             Usersofbms(),
//             Usersofbfia(),
//             Usersofbsc(),
//           ];
//         });
//       }
//       if (value == 2) {
//         setState(() {
//           coursewidgets = <int, Widget>{
//             0: Text("B.Com"),
//             1: Text("B.A. Econ"),
//           };
//           bodies = [
//             Usersofbcom(),
//             Usersofecon(),
//           ];
//         });
//       }
//       _fcm.subscribeToTopic('${value}college');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           title: Text(
//             "Relic",
//             style: TextStyle(
//                 fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
//           ),
//           actions: [
//             IconButton(
//                 padding: EdgeInsets.symmetric(horizontal: 20.0),
//                 icon: Icon(Icons.settings, color: Colors.black, size: 25.0),
//                 onPressed: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => SettingsPage()));
//                 }),
//             IconButton(
//                 padding: EdgeInsets.symmetric(horizontal: 20.0),
//                 icon:
//                     Icon(Icons.search_rounded, color: Colors.black, size: 26.0),
//                 onPressed: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => SearchScreen()));
//                 }),
//           ],
//           backgroundColor: Colors.white,
//           bottom: PreferredSize(
//             preferredSize: Size(double.infinity, 30),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: CupertinoSlidingSegmentedControl<int>(
//                   children: coursewidgets,
//                   onValueChanged: (int val) {
//                     setState(() {
//                       sharedValue = val;
//                     });
//                   },
//                   groupValue: sharedValue,
//                 ),
//               ),
//             ),
//           ),
//         ),
// floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
// floatingActionButton: FloatingActionButton.extended(
//   elevation: 7,
//   onPressed: () {
//     Share.share(
//         "Hey, I would love it if you could sign my yearbook, it very similar to the scribble day where we sign each other's t-shirts but it's now in a yearbook.\n\n❤️ Get the app: https://play.google.com/store/apps/details?id=app.yearbook.yearbookapp",
//         subject: "Yearbook App!");
//   },
//   label: Text(
//     'Get yearbook signatures',
//     style: TextStyle(
//       fontSize: 14,
//       fontWeight: FontWeight.w600,
//       color: Colors.black,
//     ),
//   ),
//   icon: Icon(
//     Icons.edit_rounded,
//     color: Colors.black,
//     size: 20,
//   ),
//   backgroundColor: Color(0xFFFFCB37),
// ),
//         body: bodies[sharedValue],
//       ),
//     );
//   }
// }
