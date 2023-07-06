import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yearbook/onboarding/all_colleges/all_colleges_page.dart';
import 'package:yearbook/onboarding/invite_friends.dart';
import 'helper/helper_functions.dart';
import 'onboarding/onboarding_screens.dart';
import 'pages/navbarpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _getUserLoggedInStatus();
  }

  _getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;
          print("logged in");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        primaryColor: Color(0xFFFFCB37),
      ),
      // initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
      // routes: {
      //   '/': (context) => _isLoggedIn ? Home() : ChooseCollegePage(),
      //   "first": (context) => Onboarding(),
      // },
      //home: InviteFriends(),
      home: _isLoggedIn ? Home() : Onboarding(),
    );
  }
}
