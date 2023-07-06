import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:path/path.dart';
import 'package:yearbook/main.dart';
import 'package:yearbook/shared/loading.dart';

class TagFriendsScreen extends StatefulWidget {
  final File image;
  TagFriendsScreen({this.image});

  @override
  _TagFriendsScreenState createState() => _TagFriendsScreenState();
}

class _TagFriendsScreenState extends State<TagFriendsScreen> {
  List albumtopphotos = [];

  List taggedusersnames = [];
  List taggedusersids = [];

  String currentusername;
  String currentuserid = '';

  String searchname;
  int collegeid;
  bool _isLoading = false;

  Future<dynamic> searchUser() async {
    if (collegeid == 1) {
      QuerySnapshot qn = await Firestore.instance
          .collection("users")
          .where('fullName', isGreaterThanOrEqualTo: searchname)
          .where('fullName', isLessThan: searchname + 'z')
          .orderBy('fullName', descending: false)
          .getDocuments();
      return qn.documents;
    } else {
      QuerySnapshot qn = await Firestore.instance
          .collection("users$collegeid")
          .where('fullName', isGreaterThanOrEqualTo: searchname)
          .where('fullName', isLessThan: searchname + 'z')
          .orderBy('fullName', descending: false)
          .getDocuments();
      return qn.documents;
    }
  }

  Future<String> uploadFile(File _image) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        'albums$collegeid/${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}/${basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  addPost(String imageurl, List taggedusersids, taggedusersnames) async {
    final firestoreInstance = Firestore.instance;
    String docId =
        firestoreInstance.collection('albums$collegeid').document().documentID;
    await firestoreInstance
        .collection('albums$collegeid')
        .document(docId)
        .setData({
      'imageurl': imageurl,
      'documentid': docId,
      'funnycount': 1,
      'firecount': 1,
      'hearteyescount': 1,
      'taggedusersids': taggedusersids,
      'taggedusersnames': taggedusersnames,
      'time': FieldValue.serverTimestamp(),
    });
  }

  @override
  void initState() {
    super.initState();
    getCollegeidandname();
    getUserId();
  }

  getUserId() async {
    currentuserid = (await FirebaseAuth.instance.currentUser()).uid;
  }

  getCollegeidandname() async {
    await HelperFunctions.getUserCollegeidSharedPreference().then((value) {
      setState(() {
        collegeid = value;
      });
    });
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        currentusername = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              elevation: 0,
              title: Text(
                'Tag Friends',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Builder(
              builder: (ctx) => FloatingActionButton.extended(
                elevation: 7,
                onPressed: () async {
                  if (taggedusersnames.isNotEmpty) {
                    setState(() {
                      _isLoading = true;
                      taggedusersids.add(currentuserid);
                      taggedusersnames.add(currentusername);
                    });
                    String uploadedimageurl = await uploadFile(widget.image);
                    await addPost(
                        uploadedimageurl, taggedusersids, taggedusersnames);

                    print('done');
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyApp()));
                  } else {
                    Scaffold.of(ctx).showSnackBar(SnackBar(
                        content: Text("Tag atleast one friends."),
                        duration: const Duration(seconds: 2)));
                  }
                },
                label: Text(
                  'POST',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 20,
                ),
                backgroundColor: Color(0xFFFFCB37),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Image.file(
                        widget.image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      Expanded(
                          child: Text(
                              taggedusersnames.join("," + " ").toString())),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10,
                    top: 10,
                  ),
                  child: Text("Tag all your friends who are in the photo"),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, bottom: 10, top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                    child: TextFormField(
                      autofocus: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: "Search friends",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                      validator: (val) {
                        return RegExp(r"^[a-zA-Z]+").hasMatch(val)
                            ? null
                            : "Please enter a name";
                      },
                      onChanged: (val) {
                        setState(() {
                          searchname = val
                              .replaceAll(RegExp(' +'), ' ')
                              .split(" ")
                              .map((str) => str.length > 0
                                  ? '${str[0].toUpperCase()}${str.substring(1)}'
                                  : '')
                              .join(" ");

                          searchUser();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: searchUser(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 5),
                            width: double.infinity,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (_, index) {
                                  return ListTile(
                                    onTap: () {
                                      if (taggedusersnames.contains(snapshot
                                          .data[index].data['fullName'])) {
                                        Scaffold.of(_).showSnackBar(SnackBar(
                                            content: Text("Already tagged"),
                                            duration:
                                                const Duration(seconds: 1)));
                                      } else {
                                        setState(() {
                                          taggedusersids.add(snapshot
                                              .data[index].data['documentid']);
                                          taggedusersnames.add(snapshot
                                              .data[index].data['fullName']);
                                        });
                                      }
                                    },
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10),
                                    leading: CircleAvatar(
                                      radius: 21.0,
                                      backgroundImage: NetworkImage(
                                          "${snapshot.data[index].data['profilePic']}"),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    title: Text(
                                      snapshot.data[index].data['fullName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return Center(
                            child: Container(
                              child: Text("Search a friend..."),
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          );
  }
}
