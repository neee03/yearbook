import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yearbook/pages/yearbook/write_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Listofstudents2021 extends StatefulWidget {
  final String course;
  final int collegeid;
  Listofstudents2021({
    this.course,
    this.collegeid,
  });
  @override
  _Listofstudents2021State createState() => _Listofstudents2021State();
}

class _Listofstudents2021State extends State<Listofstudents2021> {
  Future _data;
  String userid = '';
  Future<dynamic> getViewUser() async {
    if (widget.collegeid == 1) {
      QuerySnapshot qn = await Firestore.instance
          .collection("users")
          .where('course', isEqualTo: widget.course)
          .where('batch', isEqualTo: '2021')
          .orderBy('time', descending: true)
          .getDocuments();
      // if (qn != null) {
      //   qn.documents.forEach((docs) {
      //     print(docs.data['email']);
      //   });
      //   print('done');
      // }
      return qn.documents;
    } else {
      QuerySnapshot qn = await Firestore.instance
          .collection("users${widget.collegeid}")
          .where('course', isEqualTo: widget.course)
          .where('batch', isEqualTo: '2021')
          .orderBy('time', descending: true)
          .getDocuments();
      // if (qn != null) {
      //   qn.documents.forEach((docs) {
      //     print(docs.data['email']);
      //     print(docs.data['numberofsignsent']);
      //   });
      //   print('done');
      // }
      return qn.documents;
    }
  }

  @override
  void initState() {
    super.initState();
    _data = getViewUser();
    getUserId();
  }

  getUserId() async {
    userid = (await FirebaseAuth.instance.currentUser()).uid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _data,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            print(snapshot.data.length);
            return Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
              width: double.infinity,
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height * 0.81),
                  ),
                  itemBuilder: (_, index) {
                    List isSigned =
                        snapshot.data[index].data['receivedfromusers'];
                    return Card(
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            child: snapshot.data[index].data['profilePic'] != ""
                                ? CachedNetworkImage(
                                    imageUrl:
                                        snapshot.data[index].data['profilePic'],
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    fit: BoxFit.fitWidth,
                                  )
                                : Image.network(
                                    "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              snapshot.data[index].data['fullName'],
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          // // DOCUMENT ID
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 5.0),
                          //   child: Text(
                          //     snapshot.data[index].data['documentid'],
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       fontWeight: FontWeight.w400,
                          //       fontSize: 14,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              "${snapshot.data[index].data['numberofsignreceived'].toString()} Signatures",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          isSigned.contains(userid) == true
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: ButtonTheme(
                                    height: 30,
                                    minWidth: double.infinity,
                                    child: Center(
                                      child: FlatButton(
                                        color: Colors.grey[400],
                                        child: Text(
                                          "Signed",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content:
                                                      Text("Already Signed"),
                                                  duration: const Duration(
                                                      seconds: 1)));
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: ButtonTheme(
                                    height: 30,
                                    minWidth: double.infinity,
                                    child: Center(
                                      child: FlatButton(
                                        color: Color(0xFFFFCB37),
                                        child: Text(
                                          "Sign",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WritePage(
                                                        receivername: snapshot
                                                            .data[index]
                                                            .data['fullName'],
                                                        documentid: snapshot
                                                            .data[index]
                                                            .data['documentid'],
                                                      )));
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    );
                  }),
            );
          } else {
            return Center(
              child: Container(
                child: Text("Error 404! Check back again shortly."),
              ),
            );
          }
        });
  }
}
