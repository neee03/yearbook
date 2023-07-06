import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:yearbook/main.dart';
import 'package:path/path.dart';
import 'package:yearbook/pages/navbarpage.dart';
import 'package:yearbook/services/auth_services.dart';
import 'package:yearbook/services/database_services.dart';
import 'package:yearbook/shared/loading.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final db = Firestore.instance;
  final AuthService _auth = AuthService();
  FirebaseUser _user;

  final picker = ImagePicker();
  File _image;
  bool _isLoading = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadFile(File _image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('uploads/${basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text("Settings",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600)),
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            body: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 30),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Made with love by ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              TextSpan(
                                  text: "Ishan Goswami ",
                                  style: TextStyle(
                                      color: Colors.blueAccent[400],
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(
                                          'https://www.instagram.com/theishangoswami/');
                                    }),
                              TextSpan(
                                text: "\nand ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              TextSpan(
                                  text: "Nihal Goyal.",
                                  style: TextStyle(
                                      color: Colors.blueAccent[400],
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(
                                          'https://www.instagram.com/nihal_goyal/');
                                    }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                      ),
                      child: RaisedButton(
                        elevation: 4,
                        color: Color(0xFFFFCB37),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              "Change your profile picture",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () async {
                          await getImage();
                          if (_image != null) {
                            setState(() {
                              _isLoading = true;
                            });
                            String imageurl = await uploadFile(_image);
                            String userId =
                                (await FirebaseAuth.instance.currentUser()).uid;
                            await HelperFunctions
                                    .getUserCollegeidSharedPreference()
                                .then((value) async {
                              await DatabaseService(uid: userId)
                                  .updateUserProfilePicture(imageurl, value);
                            });
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                      ),
                      child: RaisedButton(
                        elevation: 4,
                        color: Color(0xFFFF0000),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.subdirectory_arrow_left_rounded,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => MyApp()),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                      ),
                      child: RaisedButton(
                        elevation: 4,
                        color: Color(0xFFFFFFFF),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.message_rounded,
                              color: Colors.deepOrange,
                              size: 25.0,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              "Suggest New Features",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          launch(
                              "https://api.whatsapp.com/send?phone=918800209871&text=Hey,%20my%20wishlist%20features%20for%20the%20Relic%20app%20is...%20(Write%20your%20suggestions%20and%20the%20features%20you%20would%20like%20to%20see)");
                        },
                      ),
                    ),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                      ),
                      child: RaisedButton(
                        elevation: 4,
                        color: Color(0xFFFFFFFF),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.bug_report_rounded,
                              color: Colors.yellow[600],
                              size: 25,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              "Report Bugs",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          launch(
                              "mailto:relic.yearbook@gmail.com?subject=Reporting in App Bugs&body=(Please describe and provide screenshot or screenrecording of the issue)");
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                      ),
                      child: RaisedButton(
                        elevation: 4,
                        color: Color(0xFFFFFFFF),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.share_rounded,
                              color: Colors.blue,
                              size: 25,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              "Share with Friends",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          Share.share(
                              "Heyyyy, try this yearbook app where all our friends are writing each other letters, this is sooo cool! 🔥\n\n\nGet the app now! \n\nAndroid: https://play.google.com/store/apps/details?id=app.yearbook.yearbookapp \n\niPhone: https://apps.apple.com/in/app/relic-your-virtual-yearbook/id1571515236#?platform=iphone",
                              subject: "Yearbook App!");
                        },
                      ),
                    ),
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                      ),
                      child: RaisedButton(
                        elevation: 4,
                        color: Color(0xFFFFFFFF),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.instagram,
                              color: Color(0xFFfd1d1d),
                              size: 25,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              "Connect on Instagram",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          launch('https://www.instagram.com/relic.app/');
                        },
                      ),
                    ),
                    Platform.isAndroid
                        ? Container(
                            height: 70,
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 10,
                            ),
                            child: RaisedButton(
                              elevation: 4,
                              color: Color(0xFFFFFFFF),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.favorite,
                                    color: Color(0xffff4da6),
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Text(
                                    "Rate app on Play Store",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: () {
                                launch(
                                    'https://play.google.com/store/apps/details?id=app.yearbook.yearbookapp');
                              },
                            ),
                          )
                        : Container(
                            height: 70,
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 10,
                            ),
                            child: RaisedButton(
                              elevation: 4,
                              color: Color(0xFFFFFFFF),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.favorite,
                                    color: Color(0xffff4da6),
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Text(
                                    "Rate app on App Store",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: () {
                                launch(
                                    'https://apps.apple.com/in/app/relic-your-virtual-yearbook/id1571515236#?platform=iphone');
                              },
                            ),
                          ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
