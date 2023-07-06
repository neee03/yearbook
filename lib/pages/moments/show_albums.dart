import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yearbook/pages/moments/feed_page.dart';
import 'package:yearbook/pages/moments/imagestack_albums.dart';

class ShowAlbums extends StatefulWidget {
  @override
  _ShowAlbumsState createState() => _ShowAlbumsState();
}

class _ShowAlbumsState extends State<ShowAlbums> {
  Future<dynamic> getAlbums() async {
    QuerySnapshot qn =
        await Firestore.instance.collection("albums1").getDocuments();
    return qn.documents;
  }

  // List<String> toStringList(List dlist) {
  //   dlist.forEach((photo) {
  //     imagelist.add(photo.toString());
  //   });
  //   return imagelist.toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Moments",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: getAlbums(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    List<String> imagelist = [];
                    snapshot.data[index].data['topphotos'].forEach((photo) {
                      imagelist.add(photo.toString());
                    });
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FeedPage()));
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5),
                                child: Text(
                                  snapshot.data[index].data['albumname']
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: ImageStack(
                                  imageList: imagelist,
                                  // imageList: toStringList(
                                  //     snapshot.data[index].data['topphotos']),
                                  imageRadius: 110,
                                  imageCount: 4,
                                  imageBorderWidth: 2,
                                  totalCount: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Container(
                  child: Text("Error 404! Check back again shortly."),
                ),
              );
            }
          }),
    );
  }
}
