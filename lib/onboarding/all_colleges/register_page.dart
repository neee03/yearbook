import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:yearbook/main.dart';
import 'package:yearbook/onboarding/invite_friends.dart';
import 'package:yearbook/services/auth_services.dart';
import 'package:yearbook/shared/constants.dart';
import 'package:yearbook/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  final String imageurl;
  final DocumentSnapshot doc;
  RegisterPage({this.imageurl, this.doc});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Uri sendmail = Uri(
      scheme: 'mailto',
      path: 'relic.yearbook@gmail.com',
      query:
          'subject=I have a problem while registering an account.&body=(Please send this mail from your college email id)');

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String fullName = '';
  String email = '';
  String password = '';
  String quote = '';
  String error = '';
  String course;
  String batch;

  _onRegister(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth
          .registerWithEmailAndPassword(fullName, email, password, course,
              batch, widget.imageurl, widget.doc.data['collegeid'])
          .then((result) async {
        if (result != null) {
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(fullName);
          await HelperFunctions.saveUserCollegeidSharedPreference(
              widget.doc.data['collegeid']);
          await HelperFunctions.saveUserCourseSharedPreference(course);

          // print("Registered");
          // await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
          //   print("Logged in: $value");
          // });
          // await HelperFunctions.getUserEmailSharedPreference().then((value) {
          //   print("Email: $value");
          // });
          // await HelperFunctions.getUserNameSharedPreference().then((value) {
          //   print("Full Name: $value");
          // });
          // await HelperFunctions.getUserCollegeidSharedPreference()
          //     .then((value) {
          //   print("College id: $value");
          // });
          // await HelperFunctions.getUserCourseSharedPreference().then((value) {
          //   print("Course: $value");
          // });

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => InviteFriends()));
        } else {
          setState(() {
            error = 'Error while registering the user!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            body: Form(
                key: _formKey,
                child: Container(
                  color: Color(0xFFFFCB37),
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(error,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          Text("CREATE NEW ACCOUNT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Full Name'),
                            validator: (val) {
                              return RegExp(r"^[a-zA-Z]+").hasMatch(val)
                                  ? null
                                  : "Please enter your full name";
                            },
                            onChanged: (val) {
                              setState(() {
                                fullName = val
                                    .replaceAll(RegExp(' +'), ' ')
                                    .split(" ")
                                    .map((str) => str.length > 0
                                        ? '${str[0].toUpperCase()}${str.substring(1)}'
                                        : '')
                                    .join(" ");
                                print(fullName);
                              });
                            },
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: textInputDecoration.copyWith(
                                labelText: widget.doc.data['emaillabeltext']),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@+[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]")
                                      .hasMatch(val)
                                  ? null
                                  : "Please enter your valid email id";
                            },
                            onChanged: (val) {
                              setState(() {
                                email = val.toLowerCase();
                              });
                            },
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Password'),
                            validator: (val) => val.length < 6
                                ? 'Password not strong enough'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: DropdownButtonFormField<String>(
                              isDense: false,
                              isExpanded: true,
                              value: course,
                              dropdownColor: Colors.black,
                              hint: Text("Select Your Course",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              icon: Icon(
                                Icons.arrow_downward,
                                color: Color(0xFFffffff),
                              ),
                              iconSize: 20,
                              elevation: 15,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 3),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (val) => val != null
                                  ? null
                                  : "Please select your course",
                              onChanged: (String newValue) {
                                setState(() {
                                  course = newValue;
                                });
                              },
                              items: widget.doc.data['courses']
                                  .cast<String>()
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: DropdownButtonFormField<String>(
                              isDense: false,
                              isExpanded: true,
                              value: batch,
                              dropdownColor: Colors.black,
                              hint: Text("Select Batch (Your passing out year)",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              icon: Icon(
                                Icons.arrow_downward,
                                color: Color(0xFFffffff),
                              ),
                              iconSize: 20,
                              elevation: 15,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 3),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (val) => val != null
                                  ? null
                                  : "Please select your batch",
                              onChanged: (String newValue) {
                                setState(() {
                                  batch = newValue;
                                });
                              },
                              items: widget.doc.data['batch']
                                  .cast<String>()
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 100.0),
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                                elevation: 0.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Text('Continue',
                                    style: TextStyle(
                                        color: Color(0xFFFFCB37),
                                        fontSize: 16.0)),
                                onPressed: () async {
                                  _onRegister(context);
                                }),
                          ),
                          SizedBox(height: 10.0),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Having problems while registering? ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Contact Us',
                                    style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        var url = sendmail.toString();
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw "Could not launch the url";
                                        }
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(error,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                )),
          );
  }
}
