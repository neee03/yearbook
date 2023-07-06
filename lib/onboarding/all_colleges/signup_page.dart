import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yearbook/helper/helper_functions.dart';
import 'package:yearbook/main.dart';
import 'package:yearbook/services/auth_services.dart';
import 'package:yearbook/services/database_services.dart';
import 'package:yearbook/shared/constants.dart';
import 'package:yearbook/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends StatefulWidget {
  final DocumentSnapshot doc;
  SignInPage({this.doc});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final Uri sendmail = Uri(
      scheme: 'mailto',
      path: 'relic.yearbook@gmail.com',
      query:
          'subject=I have a problem while signing up into my existing account.&body=(Please send this mail from your registered email id)');

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  _onSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth
          .signInWithEmailAndPassword(email, password)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseService()
              .getUserData(email, widget.doc.data['collegeid']);

          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data['fullName']);
          await HelperFunctions.saveUserCollegeidSharedPreference(
              widget.doc.data['collegeid']);
          await HelperFunctions.saveUserCourseSharedPreference(
              userInfoSnapshot.documents[0].data['course']);

          // print("Signed In");
          // await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
          //   print("Logged in: $value");
          // });
          // await HelperFunctions.getUserEmailSharedPreference().then((value) {
          //   print("Email: $value");
          // });
          // await HelperFunctions.getUserNameSharedPreference().then((value) {
          //   print("Full Name: $value");
          // });

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MyApp()));
        } else {
          setState(() {
            error = 'Error signing in!';
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
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Form(
              key: _formKey,
              child: Container(
                color: Color(0xFFFFCB37),
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
                        Text("SIGN INTO EXISTING ACCOUNT",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: textInputDecoration.copyWith(
                              labelText: widget.doc.data['emaillabeltext']),
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@+[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]")
                                    .hasMatch(val)
                                ? null
                                : "Please enter your registered email";
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: RaisedButton(
                              elevation: 0.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Sign In',
                                  style: TextStyle(
                                      color: Color(0xFFFFCB37),
                                      fontSize: 16.0)),
                              onPressed: () {
                                _onSignIn();
                              }),
                        ),
                        SizedBox(height: 10.0),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Forgot your password? ",
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
              ),
            ));
  }
}
