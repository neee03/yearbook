import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:yearbook/pages/yearbook/write_page.dart';

class ShuffleSuggestions extends StatefulWidget {
  @override
  _ShuffleSuggestionsState createState() => _ShuffleSuggestionsState();
}

class _ShuffleSuggestionsState extends State<ShuffleSuggestions> {
  List<dynamic> userids = [];
  int localcollegeid;
  String currentuserid = '';
  DocumentSnapshot document;
  DocumentSnapshot user1, user2, user3;
  int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsersids();
    getCurrentUserid();
  }

  getCurrentUserid() async {
    currentuserid = (await FirebaseAuth.instance.currentUser()).uid;
  }

  getAllUsersids() async {
    await HelperFunctions.getUserCollegeidSharedPreference()
        .then((collegeid) async {
      if (collegeid == 1) {
        document = await Firestore.instance
            .collection('users')
            .document('0allusersdocumentids')
            .get();
      } else {
        document = await Firestore.instance
            .collection('users$collegeid')
            .document('0allusersdocumentids')
            .get();
      }
      setState(() {
        userids = document.data['usersids'].map((v) => v).toList();
        localcollegeid = collegeid;
        userids.shuffle();
      });
    });
  }

  Future<dynamic> getUser1() async {
    print(userids[i]);
    if (localcollegeid == 1) {
      user1 = await Firestore.instance
          .collection('users')
          .document(userids[i])
          .get();
      return user1;
    } else {
      user1 = await Firestore.instance
          .collection('users$localcollegeid')
          .document(userids[i])
          .get();
      return user1;
    }
  }

  Future<dynamic> getUser2() async {
    print(userids[i + 1]);
    if (localcollegeid == 1) {
      user2 = await Firestore.instance
          .collection('users')
          .document(userids[i + 1])
          .get();
      return user2;
    } else {
      user2 = await Firestore.instance
          .collection('users$localcollegeid')
          .document(userids[i + 1])
          .get();
      return user2;
    }
  }

  Future<dynamic> getUser3() async {
    print(userids[i + 2]);
    if (localcollegeid == 1) {
      user3 = await Firestore.instance
          .collection('users')
          .document(userids[i + 2])
          .get();
      return user3;
    } else {
      user3 = await Firestore.instance
          .collection('users$localcollegeid')
          .document(userids[i + 2])
          .get();
      return user3;
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(userids);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Suggested signatures",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 1,
        splashColor: Colors.orange,
        onPressed: () {
          print(userids.length);
          print(i);
          setState(() {
            i = i + 3;
          });
        },
        label: Text(
          'Shuffle Suggestions',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        icon: Icon(
          Icons.shuffle_rounded,
          color: Colors.black,
          size: 22,
        ),
        backgroundColor: Color(0xFFFFCB37),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          userids.length >= (i + 3)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: getUser1(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List isSigned1 = snapshot.data['receivedfromusers'];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Card(
                                elevation: 20,
                                color: Color(0xFFFEEFA8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      child: snapshot.data['profilePic'] != ""
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  snapshot.data['profilePic'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Text(
                                            snapshot.data['fullName'],
                                            //overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Text(
                                            "${snapshot.data['numberofsignreceived'].toString()} Signatures",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18,
                                          ),
                                          isSigned1.contains(currentuserid) ==
                                                  true
                                              ? ButtonTheme(
                                                  height: 30,
                                                  minWidth: 150,
                                                  child: Center(
                                                    child: FlatButton(
                                                      color: Colors.grey[400],
                                                      child: Text(
                                                        "Signed",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Scaffold.of(context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Already Signed"),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1)));
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : ButtonTheme(
                                                  height: 30,
                                                  minWidth: 150,
                                                  child: Center(
                                                    child: FlatButton(
                                                      color: Color(0xFFFFCB37),
                                                      child: Text(
                                                        "Sign",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WritePage(
                                                                          receivername:
                                                                              snapshot.data['fullName'],
                                                                          documentid:
                                                                              snapshot.data['documentid'],
                                                                        )));
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                      future: getUser2(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List isSigned2 = snapshot.data['receivedfromusers'];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Card(
                                elevation: 20,
                                color: Color(0xFFFEEFA8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      child: snapshot.data['profilePic'] != ""
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  snapshot.data['profilePic'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Text(
                                            snapshot.data['fullName'],
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Text(
                                            "${snapshot.data['numberofsignreceived'].toString()} Signatures",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18,
                                          ),
                                          isSigned2.contains(currentuserid) ==
                                                  true
                                              ? ButtonTheme(
                                                  height: 30,
                                                  minWidth: 150,
                                                  child: Center(
                                                    child: FlatButton(
                                                      color: Colors.grey[400],
                                                      child: Text(
                                                        "Signed",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Scaffold.of(context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Already Signed"),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1)));
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : ButtonTheme(
                                                  height: 30,
                                                  minWidth: 150,
                                                  child: Center(
                                                    child: FlatButton(
                                                      color: Color(0xFFFFCB37),
                                                      child: Text(
                                                        "Sign",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WritePage(
                                                                          receivername:
                                                                              snapshot.data['fullName'],
                                                                          documentid:
                                                                              snapshot.data['documentid'],
                                                                        )));
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                      future: getUser3(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List isSigned3 = snapshot.data['receivedfromusers'];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Card(
                                elevation: 20,
                                color: Color(0xFFFEEFA8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      child: snapshot.data['profilePic'] != ""
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  snapshot.data['profilePic'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Text(
                                            snapshot.data['fullName'],
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Text(
                                            "${snapshot.data['numberofsignreceived'].toString()} Signatures",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18,
                                          ),
                                          isSigned3.contains(currentuserid) ==
                                                  true
                                              ? ButtonTheme(
                                                  height: 30,
                                                  minWidth: 150,
                                                  child: Center(
                                                    child: FlatButton(
                                                      color: Colors.grey[400],
                                                      child: Text(
                                                        "Signed",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Scaffold.of(context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Already Signed"),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1)));
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : ButtonTheme(
                                                  height: 30,
                                                  minWidth: 150,
                                                  child: Center(
                                                    child: FlatButton(
                                                      color: Color(0xFFFFCB37),
                                                      child: Text(
                                                        "Sign",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WritePage(
                                                                          receivername:
                                                                              snapshot.data['fullName'],
                                                                          documentid:
                                                                              snapshot.data['documentid'],
                                                                        )));
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    Center(child: Text("You have seen all profiles")),
                    FlatButton(
                      color: Colors.blueAccent,
                      child: Text(
                        "Keep showing friends...",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          userids.shuffle();
                          i = 0;
                        });
                      },
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
