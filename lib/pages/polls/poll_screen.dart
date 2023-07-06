import 'package:flutter/material.dart';
import 'package:yearbook/pages/settings/settings.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({Key key}) : super(key: key);

  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Polls",
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
      body: Text("Hello"),
    );
  }
}
