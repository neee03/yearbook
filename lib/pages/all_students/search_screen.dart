import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:yearbook/pages/yearbook/write_page.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name;
  String userid = '';
  int collegeid;
  Future<dynamic> searchUser() async {
    if (collegeid == 1) {
      QuerySnapshot qn = await Firestore.instance
          .collection("users")
          .where('fullName', isGreaterThanOrEqualTo: name)
          .where('fullName', isLessThan: name + 'z')
          .orderBy('fullName', descending: false)
          .getDocuments();
      return qn.documents;
    } else {
      QuerySnapshot qn = await Firestore.instance
          .collection("users$collegeid")
          .where('fullName', isGreaterThanOrEqualTo: name)
          .where('fullName', isLessThan: name + 'z')
          .orderBy('fullName', descending: false)
          .getDocuments();
      return qn.documents;
    }
  }

  @override
  void initState() {
    super.initState();
    getCollegeid();
    getUserId();
  }

  getUserId() async {
    userid = (await FirebaseAuth.instance.currentUser()).uid;
  }

  getCollegeid() async {
    await HelperFunctions.getUserCollegeidSharedPreference().then((value) {
      setState(() {
        collegeid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Search"),
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 60),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10, bottom: 10, top: 5),
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
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                    validator: (val) {
                      return RegExp(r"^[a-zA-Z]+").hasMatch(val)
                          ? null
                          : "Please enter a name";
                    },
                    onChanged: (val) {
                      setState(() {
                        name = val
                            .replaceAll(RegExp(' +'), ' ')
                            .split(" ")
                            .map((str) => str.length > 0
                                ? '${str[0].toUpperCase()}${str.substring(1)}'
                                : '')
                            .join(" ");
                        print(name);
                        searchUser();
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            elevation: 7,
            onPressed: () {
              Share.share(
                  "Heyyyy, try this yearbook app where all our friends are writing each other letters, this is sooo cool! 🔥\n\n\nGet the app now! \n\nFor Android: https://play.google.com/store/apps/details?id=app.yearbook.yearbookapp \n\nFor iPhone: https://apps.apple.com/in/app/relic-your-virtual-yearbook/id1571515236#?platform=iphone",
                  subject: "Yearbook App!");
            },
            label: Text(
              'Invite friends',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            icon: Icon(
              Icons.people_rounded,
              color: Colors.black,
              size: 20,
            ),
            backgroundColor: Color(0xFFFFCB37),
          ),
          body: FutureBuilder(
              future: searchUser(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return Container(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10, top: 10),
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
                                  child:
                                      snapshot.data[index].data['profilePic'] !=
                                              ""
                                          ? CachedNetworkImage(
                                              imageUrl: snapshot.data[index]
                                                  .data['profilePic'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              fit: BoxFit.fitWidth,
                                            )
                                          : Image.network(
                                              "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              fit: BoxFit.fitWidth,
                                            ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
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
                                // DOCUMENT ID
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
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
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Already Signed"),
                                                        duration:
                                                            const Duration(
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
                                                                      .data[
                                                                  'fullName'],
                                                              documentid: snapshot
                                                                      .data[index]
                                                                      .data[
                                                                  'documentid'],
                                                              collegeid:
                                                                  collegeid,
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
                      child: Text("Search a friend..."),
                    ),
                  );
                }
              })),
    );
  }
}
