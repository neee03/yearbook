import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yearbook/onboarding/all_colleges/start_page.dart';

class ListOfSchools extends StatefulWidget {
  @override
  _ListOfSchoolsState createState() => _ListOfSchoolsState();
}

class _ListOfSchoolsState extends State<ListOfSchools> {
  Future<dynamic> getColleges() async {
    QuerySnapshot qn = await Firestore.instance
        .collection('schools')
        .orderBy('collegename')
        .getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
      ),
      child: FutureBuilder(
          future: getColleges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 50.0,
                      child: RaisedButton(
                          color: Colors.white,
                          elevation: 0,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    StartPage(doc: snapshot.data[index])));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            snapshot.data[index].data['collegename'],
                            style: TextStyle(
                              color: Color(0xFFFFCB37),
                            ),
                          )),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Container(
                  child: Text("#@*%! Please try again later."),
                ),
              );
            }
          }),
    );
  }
}
