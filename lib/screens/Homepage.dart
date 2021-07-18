import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:testone/screens/renderscreen.dart';
import 'package:testone/screens/updateanddelete.dart';

import 'addnewbook.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  bool lowtohigh = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Addnewbook();
          }));
        },
        backgroundColor: Colors.blue,
        elevation: 8,
        child: Icon(
          Icons.menu_book,
          size: 24,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Text(
          'Books',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  //need to navigate to login screen
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return RenderScreenWidget();
                  }), (route) => false);
                  Fluttertoast.showToast(
                      msg: "Logout successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: Text(
                  'Logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    lowtohigh = !lowtohigh;
                  });
                  Fluttertoast.showToast(
                      msg: lowtohigh ? "High to low" : "Low to high",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: Text(
                  'Filter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ]),
          ),
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
          ),
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              children: [
                TabBar(
                  onTap: (val) {
                    setState(() {
                      selectedIndex = val;
                    });
                  },
                  labelColor: Colors.green,
                  indicatorColor: Colors.blue,
                  tabs: [
                    Tab(
                      text: 'All Books',
                    ),
                    Tab(
                      text: 'Your books',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("books")
                              .orderBy('rating', descending: lowtohigh)
                              .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: (snapshot.data! as QuerySnapshot)
                                      .docs
                                      .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return allbooktile(
                                        ((snapshot.data! as QuerySnapshot)
                                            .docs[index]
                                            .data() as dynamic)["bookname"],
                                        ((snapshot.data! as QuerySnapshot)
                                            .docs[index]
                                            .data() as dynamic)["authorname"],
                                        ((snapshot.data! as QuerySnapshot)
                                                .docs[index]
                                                .data() as dynamic)["rating"]
                                            .toString());
                                  });
                            } else {
                              return Container();
                            }
                          }),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("books")
                              .where('createdby',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: (snapshot.data! as QuerySnapshot)
                                      .docs
                                      .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print((snapshot.data! as QuerySnapshot)
                                        .docs[index]
                                        .id);
                                    String id =
                                        (snapshot.data! as QuerySnapshot)
                                            .docs[index]
                                            .id;
                                    print('id');
                                    return yourbooktile(
                                        context,
                                        id,
                                        ((snapshot.data! as QuerySnapshot)
                                            .docs[index]
                                            .data() as dynamic)["bookname"],
                                        ((snapshot.data! as QuerySnapshot)
                                            .docs[index]
                                            .data() as dynamic)["authorname"],
                                        ((snapshot.data! as QuerySnapshot)
                                                .docs[index]
                                                .data() as dynamic)["rating"]
                                            .toString());
                                  });
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget allbooktile(String bookname, String authorname, String rating) {
  return Padding(
    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookname,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      authorname,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Rating',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    rating,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget yourbooktile(BuildContext context, String docid, String bookname,
    String authorname, String rating) {
  return Padding(
    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: GestureDetector(
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookname,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          authorname,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Rating',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        rating,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return UpdateandDelete(
              docid,
            );
          }));
        }),
  );
}
