import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yearbook/services/auth_services.dart';

class UpdateDocIds extends StatefulWidget {
  @override
  _UpdateDocIdsState createState() => _UpdateDocIdsState();
}

class _UpdateDocIdsState extends State<UpdateDocIds> {
  List alluserslist = [];

  updatedocids() async {
    await Firestore.instance
        .collection("users6")
        .where('batch', isEqualTo: '2021')
        .getDocuments()
        .then((ds) {
      setState(() {
        if (ds != null) {
          ds.documents.forEach((docs) {
            alluserslist.add(docs.data['documentid']);
          });
        }
      });
      print(alluserslist.length);
      updateIdsindocument(alluserslist);
    });
  }

  updateIdsindocument(List alldocumentid) async {
    alldocumentid.forEach((individualdoc) async {
      await Firestore.instance
          .collection('users6')
          .document('0allusersdocumentids')
          .updateData({
        'usersids': FieldValue.arrayUnion([individualdoc]),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(alluserslist);
    return Scaffold(
      body: Center(
          child: RaisedButton(
        child: Text("Update"),
        onPressed: () {
          updatedocids();

          //updateIdsindocument(alluserslist);
        },
      )),
    );
  }
}
