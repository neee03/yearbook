import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:yearbook/pages/moments/tag_friends_page.dart';
import 'package:yearbook/pages/settings/settings.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final picker = ImagePicker();

  List funnycount = [];
  List firecount = [];
  List hearteyescount = [];

  File image;
  bool _isLoading = false;
  int collegeid;

  Future<dynamic> getPhotos() async {
    QuerySnapshot qn = await Firestore.instance
        .collection("albums$collegeid")
        .orderBy('time', descending: true)
        .getDocuments();
    setState(() {
      if (qn != null) {
        qn.documents.forEach((docs) {
          funnycount.add(docs.data['funnycount']);
          firecount.add(docs.data['firecount']);
          hearteyescount.add(docs.data['hearteyescount']);
        });
      }
    });

    return qn.documents;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  funnyIncrement(String photodocumentid) {
    Firestore.instance
        .collection('albums$collegeid')
        .document(photodocumentid)
        .updateData({
      'funnycount': FieldValue.increment(1),
    });
  }

  fireIncrement(String photodocumentid) {
    Firestore.instance
        .collection('albums$collegeid')
        .document(photodocumentid)
        .updateData({
      'firecount': FieldValue.increment(1),
    });
  }

  hearteyesIncrement(String photodocumentid) {
    Firestore.instance
        .collection('albums$collegeid')
        .document(photodocumentid)
        .updateData({
      'hearteyescount': FieldValue.increment(1),
    });
  }

  Future<File> getImageFileFromAssets() async {
    final byteData =
        await rootBundle.load('assets/images/backgroundinstagram.png');

    final file =
        File('${(await getTemporaryDirectory()).path}/backgroundinstagram.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  @override
  void initState() {
    super.initState();
    getCollegeidandname();
  }

  getCollegeidandname() async {
    await HelperFunctions.getUserCollegeidSharedPreference().then((value) {
      setState(() {
        collegeid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Moments",
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
        ],
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await getImage();
          if (image != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TagFriendsScreen(
                      image: image,
                    )));
          }
        },
        label: Text(
          'Post Group Photo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        icon: Icon(
          Icons.add_a_photo_rounded,
          color: Colors.black,
          size: 20,
        ),
        backgroundColor: Color(0xFFFFCB37),
      ),
      body: FutureBuilder(
          future: getPhotos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                        color: Colors.grey[200],
                        thickness: 5,
                      ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    ScreenshotController screenshotController =
                        ScreenshotController();
                    return Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 10,
                              bottom: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '📸',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "In photo",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        snapshot.data[index]
                                            .data['taggedusersnames']
                                            .join("," + " ")
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Screenshot(
                            controller: screenshotController,
                            child: GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  funnycount[index] = funnycount[index] + 1;
                                });
                                funnyIncrement(
                                    snapshot.data[index].data['documentid']);
                              },
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data[index].data['imageurl'],
                                // height: MediaQuery.of(context).size.height * 0.6,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 10,
                              bottom: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          funnycount[index] =
                                              funnycount[index] + 1;
                                        });
                                        funnyIncrement(snapshot
                                            .data[index].data['documentid']);
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0))),
                                      ),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "😂 ",
                                                style: TextStyle(fontSize: 17)),
                                            TextSpan(
                                                text: funnycount[index]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          firecount[index] =
                                              firecount[index] + 1;
                                        });
                                        fireIncrement(snapshot
                                            .data[index].data['documentid']);
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0))),
                                      ),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "🔥 ",
                                                style: TextStyle(fontSize: 16)),
                                            TextSpan(
                                                text:
                                                    firecount[index].toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          hearteyescount[index] =
                                              hearteyescount[index] + 1;
                                        });
                                        hearteyesIncrement(snapshot
                                            .data[index].data['documentid']);
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0))),
                                      ),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "😍 ",
                                                style: TextStyle(fontSize: 16)),
                                            TextSpan(
                                                text: hearteyescount[index]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          await screenshotController
                                              .capture()
                                              .then((image) async {
                                            File instabackground =
                                                await getImageFileFromAssets();
                                            SocialShare.shareInstagramStory(
                                              image.path,
                                              backgroundTopColor: "#000000",
                                              backgroundBottomColor: "#000000",
                                              backgroundImagePath:
                                                  instabackground.path,
                                            ).then((data) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            });
                                          });
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 2),
                                            child: FaIcon(
                                              FontAwesomeIcons.instagram,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            gradient: SweepGradient(
                                              colors: [
                                                Color(0xFF833AB4), // Purple
                                                Color(0xFFF77737), // Orange
                                                Color(0xFFE1306C), // Red-pink
                                                Color(0xFFC13584), // Red-purple
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return Center(
                child: Container(
                  child: Text("Loading..."),
                ),
              );
            }
          }),
    );
  }
}
